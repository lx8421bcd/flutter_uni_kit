import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/widgets/wheel_view.dart';
import 'package:example/themes/app_colors.dart';
import 'package:flutter_uni_kit/alerts/toast_alert.dart';
import 'package:flutter_uni_kit/alerts/dialog_alert.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/dialogs/popup_window.dart';
import 'package:flutter_uni_kit/widgets/wheel_datetime_picker.dart';
import 'package:flutter_uni_kit/widgets/wheel_datetime_picker_panel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// flutter dialog交互功能测试页面
///
/// @author linxiao
/// @since 2023-11-10
class DialogTestPage extends StatefulWidget {
  const DialogTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DialogTestPageState();
  }
}

class _DialogTestPageState extends State<DialogTestPage>
    with WidgetsBindingObserver {
  final popupDirection = "↑".obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey popupAlertKey = GlobalKey();
    GlobalKey popupKey = GlobalKey();
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ElevatedButton(
          onPressed: () {
            WheelDatetimePickerPanel(
              wheelIndicator: WheelView.defaultMaskedIndicator,
              mode: WheelDateTimePickerMode.date,
              selectedDateTime: DateTime.now(),
              maxDateTime: DateTime.now(),
              monthBuilder: (context, dateTime, selected) {
                List<String> months = [
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December'
                ];
                var textStyle = selected
                    ? WheelDateTimePicker.defaultItemSelectedTextStyle
                    : WheelDateTimePicker.defaultItemTextStyle;
                return Text(months[dateTime - 1], style: textStyle);
              },
              title: (selectedDateTime) {
                var str = DateFormat("yyyy-MM-dd", "en_US").format(selectedDateTime);
                return str;
              },
              onSelected: (selectedDateTime) {
                Get.back();
                var str = DateFormat("yyyy-MM-dd", "en_US").format(selectedDateTime);
                toastAlert("selected: $str");
              },
            ).showAsBottomDialogContent(context: context);
          },
          child: const Text("show date picker"),
        ),
        ElevatedButton(
            child: const Text("show alert dialog simple"),
            onPressed: () {
              DialogAlert()
              // ..withTitle("Test Dialog Alert")
              ..verticalActionOrientation = true
              ..setMessage("simple dialog alert test")
              ..setAction(
                  actionText: "OK",
                  action: () {
                    Navigator.pop(context);
                  })
              // .withActionButton("YES", () {
              //   Navigator.pop(context);
              // })
              ..setAction(
                  actionText: "Cancel",
                  action: () {
                    Navigator.pop(context);
                  },
                  negative: true)
              ..show(context);
            }),
        ElevatedButton(
            child: const Text("show alert dialog full"),
            onPressed: () {
              DialogAlert()
              ..setTitle("Test Dialog Alert")
              ..setMessage(_testLongText)
              ..setAction(
                  actionText: "Accept",
                  action: () {
                    Navigator.pop(context);
                  })
              ..setAction(
                  actionText: "Reject",
                  action: () {
                    Navigator.pop(context);
                  },
                  negative: true)
              ..cancelable = false
              ..show(context);
            }),
        ElevatedButton(
            child: const Text("show single select"),
            onPressed: () {
              DialogAlert()
              ..setTitle("Single select style")
              ..setMessage("select one of the items")
              ..setAction(
                  actionText: "Item1",
                  action: () {
                    toastAlert("item1 selected");
                    Navigator.pop(context);
                  })
              ..setAction(
                  actionText: "Item2",
                  action: () {
                    toastAlert("item2 selected");
                    Navigator.pop(context);
                  })
              ..setAction(
                  actionText: "Item3",
                  action: () {
                    toastAlert("item3 selected");
                    Navigator.pop(context);
                  })
              ..setAction(
                  actionText: "Cancel",
                  action: () {
                    Navigator.pop(context);
                  },
                  negative: true)
              ..show(context);
            }),
        ElevatedButton(
            child: const Text("show bottom alert"),
            onPressed: () {
              DialogAlert()
              // .withTitle("Test Dialog Alert")
              ..setMessage(_testLongText)
              ..setAction(
                  actionText: "OK",
                  action: () {
                    Navigator.pop(context);
                  })
              ..setAction(
                  actionText: "Cancel",
                  action: () {
                    Navigator.pop(context);
                  },
                  negative: true)
              ..showBottom(context);
            }),
        ElevatedButton(
            child: const Text("show bottom dialog style single select"),
            onPressed: () {
              var itemTextStyle = TextStyle(color: AppColors.title.get());
              DialogAlert()
              // .withTitle("Single select style")
              // .withMessage("select one of the items")
              ..setAction(
                  actionText: "Item1",
                  action: () {
                    toastAlert("item1 selected");
                    Navigator.pop(context);
                  },
                  actionTextStyle: itemTextStyle)
              ..setAction(
                  actionText: "Item2",
                  action: () {
                    toastAlert("item2 selected");
                    Navigator.pop(context);
                  },
                  actionTextStyle: itemTextStyle)
              ..setAction(
                  actionText: "Item3",
                  action: () {
                    toastAlert("item3 selected");
                    Navigator.pop(context);
                  },
                  actionTextStyle: itemTextStyle)
              ..setAction(
                actionText: "Cancel",
                action: () {
                  Navigator.pop(context);
                },
                negative: true,
              )
              ..cancelable = false
              ..showBottom(context);
            }),
        ElevatedButton(
            key: popupAlertKey,
            child: const Text("show popup alert"),
            onPressed: () {
              var itemTextStyle = TextStyle(color: AppColors.title.get());
              DialogAlert()
              // .withTitle("Test Popup")
              // .withMessage("test popup text")
              ..setAction(
                  actionText: "Item1",
                  action: () {
                    toastAlert("item1 selected");
                    Navigator.pop(context);
                  },
                  actionTextStyle: itemTextStyle)
              ..setAction(
                  actionText: "Item2",
                  action: () {
                    toastAlert("item2 selected");
                    Navigator.pop(context);
                  },
                  actionTextStyle: itemTextStyle)
              ..setAction(
                  actionText: "Item3",
                  action: () {
                    toastAlert("item3 selected");
                    Navigator.pop(context);
                  },
                  actionTextStyle: itemTextStyle)
              ..showPopup(targetKey: popupAlertKey);
            }),
        Container(
          width: 200,
          height: 100,
          color: AppColors.foreground.get(),
          child: Center(
            child: ElevatedButton(
                key: popupKey,
                child: Obx(
                    () => Text("show popup window ${popupDirection.value}")),
                onPressed: () {
                  var gravity = PopupGravity.bottom;
                  switch (popupDirection.value) {
                    case "↑":
                      gravity = PopupGravity.top;
                      popupDirection.value = "↓";
                      break;
                    case "↓":
                      gravity = PopupGravity.bottom;
                      popupDirection.value = "←";
                      break;
                    case "←":
                      gravity = PopupGravity.left;
                      popupDirection.value = "→";
                    case "→":
                      gravity = PopupGravity.right;
                      popupDirection.value = "↑";
                  }
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("close")),
                  ).showAsPopupWindowContent(
                    targetKey: popupKey,
                    gravity: gravity,
                  );
                }),
          ),
        ),
        ElevatedButton(
            child: const Text("show highlight popup"),
            onPressed: () {
              // showPopupWindow(
              //   child: Container(
              //     color: Colors.white,
              //     margin: const EdgeInsets.all(10),
              //     child: const Padding(
              //       padding: EdgeInsets.all(15),
              //       child: Text("highlight widget desc"),
              //     ),
              //   ),
              //   targetKey: popupKey,
              //   highlightGuideStyle: true
              // );
              HighlightGuideQueue()
              ..addGuide(
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("highlight widget desc1"),
                  ),
                ),
                targetKey: popupAlertKey,
              )
              ..addGuide(
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("highlight widget desc2"),
                  ),
                ),
                targetKey: popupKey,
              )
              ..show(context);
            }),
      ],
    );
  }
}

String _testLongText = '''
A closely related widget is a persistent bottom sheet, 
which shows information that supplements the primary 
content of the app without preventing the user from 
interacting with the app. Persistent bottom sheets 
can be created and displayed with the showBottomSheet 
function or the ScaffoldState..showBottomSheet method.
The isScrollControlled parameter specifies whether 
this is a route for a bottom sheet that will utilize 
DraggableScrollableSheet. Consider setting this parameter 
to true if this bottom sheet has a scrollable child, 
such as a ListView or a GridView, to have the 
bottom sheet be draggable.
A closely related widget is a persistent bottom sheet, 
which shows information that supplements the primary 
content of the app without preventing the user from 
interacting with the app. Persistent bottom sheets 
can be created and displayed with the showBottomSheet 
function or the ScaffoldState..showBottomSheet method.
The isScrollControlled parameter specifies whether 
this is a route for a bottom sheet that will utilize 
DraggableScrollableSheet. Consider setting this parameter 
to true if this bottom sheet has a scrollable child, 
such as a ListView or a GridView, to have the 
bottom sheet be draggable.
''';

