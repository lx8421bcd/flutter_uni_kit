import 'package:example/test/form_test.dart';
import 'package:example/themes/app_colors.dart';
import 'package:example/test/button_style_test.dart';
import 'package:example/test/device_function_test.dart';
import 'package:example/test/dialog_test.dart';
import 'package:example/test/download_test.dart';
import 'package:example/test/image_compress_test.dart';
import 'package:example/test/image_viewer_test.dart';
import 'package:example/test/input_widget_test.dart';
import 'package:example/test/localization_test.dart';
import 'package:example/test/notification_test.dart';
import 'package:example/test/theme_test.dart';
import 'package:example/test/widget_api_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/widgets/navigation_bar.dart';


/// 测试模块容器页面
///
/// @author linxiao
/// @since 2023-11-01
class TestRootPage extends StatefulWidget {
  const TestRootPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TestRootPageState();
  }
}

class _TestRootPageState extends State<StatefulWidget> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(0);

  @override
  String? get restorationId => "TestRootPage";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex.value = index;
    });
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selected_index');
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var drawerItems = <_DrawerItem>[];
    drawerItems.add(_DrawerItem(
        name: "Theme test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const ThemeTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Notification test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => NotificationTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Download test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const DownloadTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Image Viewer test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const ImageViewerTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Widget API test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const WidgetApiTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Button styles test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const ButtonTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Dialog style test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const DialogTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Localization test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const LocalizationTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Image compress test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const ImageCompressTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "InputWidget test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const InputWidgetTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Device functions test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const DeviceFunctionTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    drawerItems.add(_DrawerItem(
        name: "Form test",
        container: drawerItems,
        currentIndexGetter: () => _selectedIndex.value,
        pageBuilder: () => const FormTestPage(),
        onItemTapped: (index) {
          _onItemTapped(index);
        }));
    final drawerListItems = ListView(
      children: drawerItems.map((e) => e.getDrawerListItem(context)).toList(),
    );
    GlobalKey<ScaffoldState> key = GlobalKey();
    return Scaffold(
      key: key,
      appBar: AppNavigationBar(
        title: AppNavigationBar.buildTitleText(context, drawerItems[_selectedIndex.value].name),
        showBack: false,
        actionButtonLeft: [
          IconButton(
              onPressed: () {
                key.currentState?.openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: AppColors.title.get(),
              )),
        ],
      ),
      body: drawerItems[_selectedIndex.value].pageBuilder(),
      drawer: Drawer(
        child: drawerListItems,
      ),
    );
  }
}

class _DrawerItem {
  String name;
  List<_DrawerItem> container;
  int Function() currentIndexGetter;
  Widget Function() pageBuilder;
  void Function(int index) onItemTapped;

  _DrawerItem(
      {required this.name,
      required this.container,
      required this.currentIndexGetter,
      required this.pageBuilder,
      required this.onItemTapped});

  ListTile getDrawerListItem(BuildContext context) {
    return ListTile(
      title: Text(name),
      selected: container.indexOf(this) == currentIndexGetter(),
      leading: const Icon(Icons.settings),
      onTap: () {
        onItemTapped(container.indexOf(this));
        Navigator.pop(context);
      },
    );
  }
}
