import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

/// 下载开始回调
typedef DownloadStartCallback = void Function();
/// 下载进度回调
typedef DownloadProgressCallback = void Function(int received, int total);
/// 下载暂停回调
typedef DownloadPauseCallback = void Function();
/// 下载取消回调
typedef DownloadCancelCallback = void Function();
/// 下载成功回调
typedef DownloadSuccessCallback = void Function();
/// 下载失败回调
typedef DownloadErrorCallback = void Function(Exception e);

enum DownloadStatus {
  pending,
  downloading,
  paused,
  completed,
  error,
  canceled
}

/// 基于dio的下载任务封装
///
/// @author linxiao
/// @since 2023-12-28
class FileDownloadTask {

  static const _pauseTag = "pause";
  static const _cancelTag = "cancel";

  /// 下载用dio
  static Dio defaultDio = Dio();

  final String downloadUrl;
  final String savePath;
  Dio dio = defaultDio;
  Options downloadOptions = Options(method: "GET");
  String lengthHeader = Headers.contentLengthHeader;
  Map<String, dynamic>? queryParameters;
  Object? data;

  DownloadStartCallback? startCallback;
  DownloadProgressCallback? progressCallback;
  DownloadPauseCallback? pauseCallback;
  DownloadCancelCallback? cancelCallback;
  DownloadSuccessCallback? successCallback;
  DownloadErrorCallback? errorCallback;


  DownloadStatus _status = DownloadStatus.pending;
  ProgressCallback? _progressCallback;
  CancelToken? _cancelToken;
  File get _tempFile => File("$savePath.temp");

  FileDownloadTask({
    required this.downloadUrl,
    required this.savePath,
  });

  DownloadStatus get status => _status;

  void start() async {
    if (_status == DownloadStatus.downloading) {
      return; // 下载中，阻断重复调用
    }
    _status = DownloadStatus.pending;
    startCallback?.call();
    File downloadedFile = File(savePath);
    var tempFile = _tempFile;
    if (downloadedFile.existsSync()) {
      // 文件已存在，判定为下载已完成
      _status = DownloadStatus.completed;
      if (tempFile.existsSync()) {
        tempFile.deleteSync(recursive: true);
      }
      successCallback?.call();
      return;
    }
    if (_cancelToken == null || _cancelToken!.isCancelled) {
      _cancelToken = CancelToken();
    }
    // 下载开始
    _status = DownloadStatus.downloading;
    try {
      _progressCallback = (int received, int total) {
        progressCallback?.call(received, total);
      };
      await _resumeDownload(cancelToken: _cancelToken);
      // 如有不明缓存，删除
      File cachedFile = File(savePath);
      if (cachedFile.existsSync()) {
        cachedFile.deleteSync(recursive: true);
      }
      tempFile.renameSync(savePath);
      _status = DownloadStatus.completed;
      successCallback?.call();
    } on Exception catch (e) {
      bool isUserCanceled(e) {
        return e is DioException && e.type == DioExceptionType.cancel;
      }
      if (!isUserCanceled(e)) {
        _status = DownloadStatus.error;
        errorCallback?.call(e);
      }
    }
    _progressCallback = null;
    _cancelToken = null;
  }

  void pause() async {
    if (_status == DownloadStatus.completed) {
      return;
    }
    _progressCallback = null;
    _cancelToken?.cancel(_pauseTag);
    _status = DownloadStatus.paused;
    if (_cancelToken != null) {
      pauseCallback?.call();
    }
    _cancelToken = null;
  }

  void cancel() async {
    if (_status == DownloadStatus.completed) {
      return;
    }
    _progressCallback = null;
    _cancelToken?.cancel(_cancelTag);
    _status = DownloadStatus.canceled;
    var tempFile = _tempFile;
    var hasTempFile = tempFile.existsSync();
    if (hasTempFile) {
      tempFile.deleteSync(recursive: true);
      cancelCallback?.call();
    }
    _cancelToken = null;
  }

  /// 恢复下载文件，支持断点续传，修改自[Dio.download]
  Future<Response> _resumeDownload({
    CancelToken? cancelToken,
  }) async {
    File downloadedFile = _tempFile;
    if (!downloadedFile.existsSync()) {
      downloadedFile.createSync(recursive: true);
    }
    var downloadStart = downloadedFile.lengthSync();
    downloadOptions.responseType = ResponseType.stream;
    downloadOptions.headers ??= {};
    downloadOptions.headers?["Range"] = "bytes=$downloadStart-";
    Response<ResponseBody> response;
    try {
      response = await dio.request<ResponseBody>(
        downloadUrl,
        data: data,
        options: downloadOptions,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? CancelToken(),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        if (e.response!.requestOptions.receiveDataWhenStatusError == true) {
          final res = await BackgroundTransformer().transformResponse(
            e.response!.requestOptions..responseType = ResponseType.json,
            e.response!.data as ResponseBody,
          );
          e.response!.data = res;
        } else {
          e.response!.data = null;
        }
      }
      rethrow;
    }
    final completer = Completer<Response>();
    Future<Response> future = completer.future;
    // 是否支持断点续传判断
    bool supportResume = response.headers.value("Content-Range") != null;
    RandomAccessFile raf = downloadedFile.openSync(mode: supportResume ? FileMode.append : FileMode.write);
    int received = supportResume ? downloadStart : 0;
    final stream = response.data!.stream;
    bool compressed = false;
    int left = 0;
    final contentEncoding = response.headers.value(Headers.contentEncodingHeader);
    if (contentEncoding != null) {
      compressed = ['gzip', 'deflate', 'compress'].contains(contentEncoding);
    }
    if (lengthHeader == Headers.contentLengthHeader && compressed) {
      left = -1;
    } else {
      left = int.parse(response.headers.value(lengthHeader) ?? '-1');
    }
    int total = received + left;
    Future<void>? asyncWrite;
    bool closed = false;
    Future<void> closeAndDelete() async {
      if (!closed) {
        closed = true;
        await asyncWrite;
        await raf.close().catchError((_) => raf);
      }
    }

    late StreamSubscription subscription;
    subscription = stream.listen(
      (data) {
        subscription.pause();
        // Write file asynchronously
        asyncWrite = raf.writeFrom(data).then((result) {
          // Notify progress
          received += data.length;
          _progressCallback?.call(received, total);
          raf = result;
          if (cancelToken == null || !cancelToken.isCancelled) {
            subscription.resume();
          }
        }).catchError((Object e) async {
          try {
            await subscription.cancel();
            closed = true;
            await raf.close().catchError((_) => raf);
          } finally {
            completer.completeError(
              _assureDioException(e, response.requestOptions),
            );
          }
        });
      },
      onDone: () async {
        try {
          await asyncWrite;
          closed = true;
          await raf.close().catchError((_) => raf);
          completer.complete(response);
        } catch (e) {
          completer.completeError(
            _assureDioException(e, response.requestOptions),
          );
        }
      },
      onError: (e) async {
        try {
          await closeAndDelete();
        } finally {
          completer.completeError(
            _assureDioException(e, response.requestOptions),
          );
        }
      },
      cancelOnError: true,
    );
    cancelToken?.whenCancel.then((_) async {
      await subscription.cancel();
      await closeAndDelete();
    });

    final timeout = response.requestOptions.receiveTimeout;
    if (timeout != null) {
      future = future.timeout(timeout).catchError(
            (dynamic e, StackTrace s) async {
          await subscription.cancel();
          await closeAndDelete();
          if (e is TimeoutException) {
            throw DioException.receiveTimeout(
              timeout: timeout,
              requestOptions: response.requestOptions,
              error: e,
            );
          } else {
            throw e;
          }
        },
      );
    }
    return _listenCancelForAsyncTask(cancelToken, future);
  }

  DioException _assureDioException(
      Object err,
      RequestOptions requestOptions,
      ) {
    if (err is DioException) {
      return err;
    }
    return DioException(
      requestOptions: requestOptions,
      error: err,
    );
  }

  Future<T> _listenCancelForAsyncTask<T>(
      CancelToken? cancelToken,
      Future<T> future,
      ) {
    return Future.any([
      if (cancelToken != null) cancelToken.whenCancel.then((e) => throw e),
      future,
    ]);
  }
}