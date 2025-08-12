## Features

本项目提供了一个flutter app开发常见的工具函数、组件、样式、颜色配置等解决方案的合集，属于业务无关代码库，用于在开发app时通过接入此项目快速完成框架搭建。


## Getting started

1. 在flutter app项目的```pubspec.yaml```文件中添加依赖配置
    ```yaml
    dependencies:
      flutter_uni_kit:
        git:
          url: git@github.com:lx8421bcd/flutter_uni_kit.git # 本项目git地址
          ref: 1.0 # 需要使用的本项目版本
    ```
2. 按照[framework_config_sample.dart](lib/framework_config_sample.dart)在应用Project中创建framework配置，按照自己项目的需求定制framework
3. 按照[net_api_config_sample.dart](lib/net_api_config_sample.dart)配置framework网络框架
4. 在应用入口位置，添加上面两个配置的出初始化函数（e.g. [main.dart](example/lib/main.dart)）
5. 按需取用本项目所提供的组件和功能

其他部分功能，不适宜放在framework内的（如flutter_gen, intl等），可以参看[example](./example)内的解决方案


## Usage

本项目提供以下功能

常用模块：

* [alerts](lib/alerts): 常见样式Alert弹窗， 包括Toast、AlertDialog、BottomAlertDialog、PopupWindow
* [dialogs](lib/dialogs)：dialog封装，可将Widget以Dialog形式展示
* [image_picker_dialog.dart](lib/dialogs/image_picker_dialog.dart)：图片选择弹窗，BottomAlertDialog样式
* [theme](lib/theme)：Theme管理，Theme切换，浅色/暗色模式切换管理
* [event_bus.dart](lib/event/event_bus.dart): 事件总线，通用应用内低耦合事件广播方式
* [error_message_handler.dart](lib/exceptions/error_message_handler.dart)：异常信息转换工具，用于将异常信息对象（Error、Exception）快速转换为UI展示信息
* [notifications.dart](lib/notification/notifications.dart)：通知管理，包含native通知初始化，快速创建通知，检查是否有通知权限等功能的封装
* [net](lib/net)：网络框架，基于Dio封装，支持统一解析业务请求结构，统一处理业务错误，支持详细请求日志打印
* [file_download.dart](lib/net/file_download.dart)：简易文件下载，基于Dio，支持断点续传
* [permission_functions.dart](lib/permission/permission_functions.dart)：权限管理支持，相机、录音等敏感权限申请管理封装
* [log.dart](lib/common/log.dart)：日志管理，基于Logger封装的日志打印功能
* [app_settings.dart](lib/app_settings.dart)：全局设置缓存，基于Hive封装

自定义组件封装

* [auto_hide_keyboard.dart](lib/widgets/auto_hide_keyboard.dart) 点击外部自动隐藏软键盘组件
* [border_button.dart](lib/widgets/border_button.dart) 边框按钮
* [color_button.dart](lib/widgets/color_button.dart) 纯色按钮
* [gradient_button.dart](lib/widgets/gradient_button.dart) 过渡色按钮
* [expansion_layout.dart](lib/widgets/expansion_layout.dart) 折叠-展开布局
* [image_viewer.dart](lib/widgets/image_viewer.dart) 查看大图组件
* [input_widget.dart](lib/widgets/input_widget.dart) 复合Input组件
* [loading_view.dart](lib/widgets/loading_view.dart) 加载状态组件
* [navigation_bar.dart](lib/widgets/navigation_bar.dart) 通用导航栏组件
* [obscure_switch_input.dart](lib/widgets/obscure_switch_input.dart) 密码现实隐藏切换Input
* [rich_text_builder.dart](lib/widgets/rich_text_builder.dart) 富文本构建工具
* [setting_item.dart](lib/widgets/setting_item.dart) 通用设置项组件
* [wheel_view.dart](lib/widgets/wheel_view.dart) 滚轮单选组件
* [wheel_datetime_picker.dart](lib/widgets/wheel_datetime_picker.dart) 基于滚轮的时间日期选择组件

常用功能封装

* [datetime_functions.dart](lib/common/datetime_functions.dart)：时间日期相关封装，获取今日0时，时间日期格式转换等功能
* [image_compress.dart](lib/common/image_compress.dart)：图片压缩封装，基于尺寸压缩至指定大小，基于质量压缩至指定大小，复合压缩的功能
* 其它简单功能，详见[common](lib/common)


## Additional information

本库的设计目的与本人Android Native库作品[QuickDevFramework](https://github.com/lx8421bcd/QuickDevFramework)的思路是一致的，
即在作为日常代码积累的同时，也能能让这些积累的代码发挥作用，所幸flutter目前复用代码及样式不需要像原生那样考虑那么多继承关系，可以更方便的作为一个lib来使用。

本项目内的代码为纯dart代码，理论上来说可以应用在macos和Windows项目上，但部分组件设计时可能未考虑PC级布局适配，需要单独处理。
