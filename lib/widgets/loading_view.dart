import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/exceptions/error_message_handler.dart';
import 'package:flutter_uni_kit/theme/framework_dimens.dart';
import 'package:flutter_uni_kit/widgets/fp_cached_network_image.dart';

bool _isNoNetwork(DioException e) {
  if (e.type != DioExceptionType.connectionError) {
    return false;
  }
  var error = e.error;
  return error is SocketException && error.osError?.errorCode == 101;
}

_execIfNotNull<T>(T? param, void Function(T it) method) {
  if (param != null) {
    method.call(param);
  }
}

typedef ReloadingCallback = void Function();

enum _LoadingStatus {
  loading,
  noData,
  showContent,
}

class NoDataHolder {

  static NoDataHolder copyFrom(NoDataHolder from) {
    return NoDataHolder()
      .._icon = from._icon
      .._desc = from._desc
      .._action = from._action;
  }

  Widget? _icon;
  Widget? _desc;
  Widget? _action;
  Color? _background;

  void setIcon(Widget? icon) {
    _icon = icon;
  }

  void setIconAsset(String assetPath) {
    _icon = Image.asset(assetPath, fit: BoxFit.scaleDown);
  }

  void setIconUrl(String url) {
    _icon = FPCachedNetworkImage(imageUrl: url);
  }

  void setDesc(Widget? desc) {
    _desc = desc;
  }

  void setDescText(String desc) {
    _desc = _getDescText(desc);
  }

  void setAction(Widget? action) {
    _action = action;
  }

  void setBackgroundColor(Color? color) {
    _background = color;
  }

  Widget _getDescText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: const Color(0xFF25282B),
          fontSize: FrameworkDimens().fontM,
          fontWeight: FontWeight.w600),
    );
  }
}

/// 加载状态组件
/// 通过[LoadingViewController]控制加载状态
class LoadingView extends StatefulWidget {

  final LoadingViewController controller;
  final ReloadingCallback? onReloading;
  final Widget? child;

  const LoadingView({
    super.key,
    required this.controller,
    this.onReloading,
    this.child,
  });

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {

  void refreshState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller._bind(this);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller._status == _LoadingStatus.showContent) {
      return widget.child ?? const SizedBox();
    }
    return _buildLoadingContent();
  }

  Widget _buildLoadingContent() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onReloading == null ? null : () {
        if (widget.controller._status == _LoadingStatus.noData) {
          widget.onReloading?.call();
        }
      },
      child: Container(
        color: widget.controller._noDataHolder._background,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
                child: widget.controller._noDataHolder._icon,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: widget.controller._noDataHolder._desc,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: widget.controller._noDataHolder._action,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingViewController {

  static NoDataHolder Function() defaultLoadingHolder = () {
    return NoDataHolder()
      ..setIcon(const CircularProgressIndicator())
      ..setDescText("");
  };
  static NoDataHolder Function() defaultEmptyHolder = () {
    return NoDataHolder()
      ..setIcon(const Icon(Icons.unarchive))
      ..setDescText("No data");
  };
  static NoDataHolder Function() defaultFailedHolder = () {
    return NoDataHolder()
      ..setIcon(const Icon(Icons.error))
      ..setDescText("Request failed");
  };
  static NoDataHolder Function() defaultNoNetworkHolder = () {
    return NoDataHolder()
      ..setIcon(const Icon(Icons.wifi_off))
      ..setDescText("No network");
  };

  static String Function() defaultTimeoutText = () => "Timeout";
  static String Function() defaultNetworkErrorText = () => "Connection error";

  _LoadingViewState? _state;
  final loadingHolder = defaultLoadingHolder();
  final emptyHolder = defaultEmptyHolder();
  final failedHolder = defaultFailedHolder();
  final noNetworkHolder = defaultNoNetworkHolder();

  _LoadingStatus _status = _LoadingStatus.showContent;
  NoDataHolder _noDataHolder = LoadingViewController.defaultLoadingHolder();

  void _bind(_LoadingViewState state) {
    _state = state;
  }

  void showLoading({
    Widget? icon,
    String? iconAsset,
    Widget? desc,
    String? descText,
    Color? background,
  }) {
    var holder = NoDataHolder.copyFrom(loadingHolder);
    _execIfNotNull(icon, (it) => holder.setIcon(it));
    _execIfNotNull(iconAsset, (it) => holder.setIconAsset(it));
    _execIfNotNull(desc, (it) => holder.setDesc(it));
    _execIfNotNull(descText, (it) => holder.setDescText(it));
    _execIfNotNull(background, (it) => holder.setBackgroundColor(it));
    _status = _LoadingStatus.loading;
    _noDataHolder = holder;
    _state?.refreshState();
  }

  void showSucceed({
    bool empty = false,
  }) {
    if (empty) {
      var holder = NoDataHolder.copyFrom(emptyHolder);
      _status = _LoadingStatus.noData;
      _noDataHolder = holder;
      _state?.refreshState();
      return;
    }
    if (_status == _LoadingStatus.showContent) {
      return;
    }
    _status = _LoadingStatus.showContent;
    _noDataHolder = loadingHolder;
    _state?.refreshState();
  }

  void showFailed({
    Exception? e,
    Widget? icon,
    String? iconAsset,
    Widget? desc,
    String? descText,
    Widget? action,
    Color? background,
  }) {
    NoDataHolder holder = NoDataHolder.copyFrom(failedHolder);
    _execIfNotNull(e, (it) {
      if (e is DioException) {
        if (_isNoNetwork(e)) {
          holder = NoDataHolder.copyFrom(noNetworkHolder);
        }
        else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout
        ) {
          holder.setDescText(defaultTimeoutText());
        }
        else {
          holder.setDescText(defaultNetworkErrorText());
        }
      }
      else {
        holder.setDescText(it.getMessage());
      }
    });
    _execIfNotNull(icon, (it) => holder.setIcon(it));
    _execIfNotNull(iconAsset, (it) => holder.setIconAsset(it));
    _execIfNotNull(desc, (it) => holder.setDesc(it));
    _execIfNotNull(descText, (it) => holder.setDescText(it));
    _execIfNotNull(action, (it) => holder.setAction(it));
    _execIfNotNull(background, (it) => holder.setBackgroundColor(it));
    _status = _LoadingStatus.noData;
    _noDataHolder = holder;
    _state?.refreshState();
  }

  void showNoNetwork() {
    _status = _LoadingStatus.noData;
    _noDataHolder = noNetworkHolder;
    _state?.refreshState();
  }

  void showCustom(NoDataHolder Function(NoDataHolder) builder) {
    _status = _LoadingStatus.noData;
    _noDataHolder = NoDataHolder();
    _state?.refreshState();
  }
}