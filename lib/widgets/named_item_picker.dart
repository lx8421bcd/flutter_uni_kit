import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/dialogs/dialogs.dart';
import 'package:flutter_uni_kit/widgets/wheel_view.dart';

abstract class NamePickerItem {
  String get name;
}

class NamedItemPicker<T extends NamePickerItem> {
  final String? title;
  final List<T> items;
  T? _selected;

  NamedItemPicker({this.title, required this.items, T? selected})
      : assert(items.isNotEmpty),
        _selected = selected;

  Widget _pickerContent(BuildContext context) {
    var index = items.indexWhere((element) => element.name == _selected?.name);
    var selectedIndex = 0;
    if (index != -1) {
      selectedIndex = index;
    } else {
      _selected = items.first;
    }
    return SafeArea(
      child: SizedBox(
        height: 325,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("Cancel",
                      style: TextStyle(
                          color: _cancelColor(context), fontSize: 15)),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  title ?? "",
                  style: TextStyle(fontSize: 16, color: _titleColor(context)),
                ),
                TextButton(
                  child: Text("Confirm",
                      style: TextStyle(
                          color: _confirmColor(context), fontSize: 15)),
                  onPressed: () {
                    Navigator.pop(context, _selected);
                  },
                ),
              ],
            ),
            const Divider(
              height: 1,
              color: Color(0xFFEDEDED),
            ),
            Expanded(
              child: WheelView(
                initialItem: selectedIndex,
                perspective: 0.006,
                overAndUnderCenterOpacity: 0.2,
                onSelectedItemChanged: (index) {
                  _selected = items[index];
                },
                children: items.map((item) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<T?> show(BuildContext context) async {
    return await _pickerContent(context).showAsBottomDialogContent();
  }
}

Color? Function(BuildContext context) _titleColor = (context) {
  return Theme.of(context).textTheme.displayLarge?.color;
};

Color? Function(BuildContext context) _confirmColor = (context) {
  return Theme.of(context).primaryColor;
};

Color? Function(BuildContext context) _cancelColor = (context) {
  return Theme.of(context).disabledColor;
};

Color? Function(BuildContext context) _dividerColor = (context) {
  return Theme.of(context).dividerColor;
};
