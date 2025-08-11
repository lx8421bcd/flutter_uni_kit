
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/widgets/loading_view.dart';
import 'package:get/get.dart';


/// 加载组件测试页面
///
/// @author linxiao
/// @since 2023-11-02
class LoadingSamplePage extends StatelessWidget {

  LoadingSamplePage({super.key});

  final LoadingSampleController controller = LoadingSampleController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.updateState();
    });
    return Scaffold(
      appBar: AppBar(title: const Text("Loading samples")),
      body: GetBuilder(
        init: controller,
        builder: (ctl) {
          return LoadingView(
            controller: controller.loadingViewController,
            onReloading: () => controller.loadMore(),
            child: EasyRefresh(
                controller: controller.refreshController,
                header: const MaterialHeader(),
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 3));
                  controller.updateState();
                },
                onLoad: () async {
                  await Future.delayed(const Duration(seconds: 3));
                  controller.loadMore();
                },
                child: ListView.builder(
                    itemCount: ctl.dataList.length,
                    itemExtent: 50.0, //强制高度为50.0
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Text(ctl.dataList[index]));
                    }
                )
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          controller.updateState();
        }
      ),
    );
  }

}

class LoadingSampleController extends GetxController {

  LoadingViewController loadingViewController = LoadingViewController();
  EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  int errorCode = 0;
  List<String> dataList = <String>[];

  Future<void> updateState() async {
    refreshController.finishRefresh();
    if (dataList.isEmpty) {
      loadingViewController.showLoading();
    }
    await Future.delayed(const Duration(seconds: 3));
    errorCode++;
    dataList.clear();
    if (errorCode > 3) {
      errorCode = 0;
    }
    switch (errorCode) {
      case 0:
        for (var i = 1; i <= 20; i++) {
          dataList.add("Test loading data item $i");
        }
        loadingViewController.showSucceed();
        break;
      case 2:
        loadingViewController.showFailed(
          e: DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: "test"
          )
        );
      case 3:
        loadingViewController.showFailed();
        break;
      default:
        loadingViewController.showSucceed(empty: true);
    }
    update();
  }

  void loadMore() {
    if (errorCode != 0) {
      return;
    }
    if (dataList.length >= 40) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    var start = dataList.length + 1;
    var end = start + 10;
    for (var i = start; i < end; i++) {
      dataList.add("Test loading data item $i");
    }
    refreshController.finishLoad();
    update();
  }

}


