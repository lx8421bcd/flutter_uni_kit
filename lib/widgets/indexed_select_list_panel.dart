import 'package:azlistview_plus/azlistview_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uni_kit/theme/framework_colors.dart';

import 'input_widget.dart';


class IndexedListItem extends ISuspensionBean {

  String index;
  String name;
  VoidCallback? selectCallback;
  Widget Function(String index, int position)? itemBuilder;

  IndexedListItem({
    required this.name,
    this.selectCallback,
    this.itemBuilder,
    String? indexTag,
  }): index = indexTag ?? name.characters.firstOrNull ?? "";

  @override
  String getSuspensionTag() {
    return index;
  }
}

class IndexedListHeader extends ISuspensionBean {

  String index;
  Widget child;

  IndexedListHeader({
    required this.index,
    required this.child,
  });

  @override
  String getSuspensionTag() {
    return index;
  }
}

class IndexedSelectListPanel extends StatefulWidget {

  static Widget Function(BuildContext context) defaultSearchIcon = (context) {
    return Icon(Icons.search,
      color: Colors.grey,
      size: 24,
    );
  };

  static Color Function(BuildContext context) defaultTitleColor = (context) {
    return Colors.black;
  };

  static Color Function(BuildContext context) defaultTextColor = (context) {
    return Colors.black;
  };

  static Color Function(BuildContext context) defaultSelectedTextColor = (context) {
    return const Color(0xFF159CFF);
  };

  static Color Function(BuildContext context) defaultItemDividerColor = (context) {
    return Color(0xFFD1DAE7);
  };

  static double Function(BuildContext context) defaultTextSize = (context) {
    return 14;
  };

  final List<IndexedListHeader> headers;
  final List<IndexedListItem> itemList;
  final void Function(List<ISuspensionBean> list)? sort;
  final bool showIndex;
  final bool showSearch;
  final String searchHint;
  final FocusNode? searchFocusNode;

  const IndexedSelectListPanel({
    super.key,
    required this.itemList,
    this.sort = defaultSort,
    this.headers = const [],
    this.showIndex = true,
    this.showSearch = true,
    this.searchHint = "",
    this.searchFocusNode,
  });

  @override
  State<IndexedSelectListPanel> createState() => _IndexedSelectListPanelState();

  static void defaultSort(List<ISuspensionBean> list) {
    list.sort((a, b) => a.getSuspensionTag().compareTo(b.getSuspensionTag()));
  }
}

class _IndexedSelectListPanelState extends State<IndexedSelectListPanel> {

  final searchEditController = TextEditingController();
  final itemList = <ISuspensionBean>[];
  String currentSearchKeyword = "";
  void Function() searchListener = () {};

  void loadList(String keyword) {
    setState(() {
      if(keyword.isEmpty) {
        itemList.clear();
        itemList.addAll(widget.itemList);
        widget.sort?.call(itemList);
        itemList.insertAll(0, widget.headers);
      }
      else {
        itemList.clear();
        var subList = widget.itemList
            .where((item) => item.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
        itemList.addAll(subList);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    searchListener = () async {
      String keyword = searchEditController.text;
      if (keyword == currentSearchKeyword) {
        return;
      }
      loadList(keyword);
      currentSearchKeyword = keyword;
    };
    searchEditController.addListener(searchListener);
    loadList("");
  }

  @override
  void didUpdateWidget(covariant IndexedSelectListPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadList("");
  }

  @override
  void dispose() {
    searchEditController.removeListener(searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SuspensionUtil.setShowSuspensionStatus(itemList);
    return Column(
      children: [
        widget.showSearch ? Container(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: InputWidget(
            controller: searchEditController,
            inputAction: TextInputAction.search,
            hintText: widget.searchHint,
            focusNode: widget.searchFocusNode,
            prefixWidget: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: IndexedSelectListPanel.defaultSearchIcon(context),
            ),
            showClearButton: true,
            inputConfigs: InputConfigs(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: IndexedSelectListPanel.defaultItemDividerColor(context),
                  width: 1
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: IndexedSelectListPanel.defaultSelectedTextColor(context),
                  width: 1
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              backgroundColor: FrameworkColors().background(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)
            ),
          ),
        ) : const SizedBox(),
        Expanded(
          child: SafeArea(
            child: AzListView(
              data: itemList,
              itemCount: itemList.length,
              itemBuilder: (context, position) {
                if (itemList[position] is IndexedListHeader) {
                  return (itemList[position] as IndexedListHeader).child;
                }
                var item = itemList[position] as IndexedListItem;
                if (item.itemBuilder != null) {
                  return item.itemBuilder!.call(item.index, position);
                }
                // default item widget
                bool showUnderline = widget.showIndex
                    ? (position + 1 < itemList.length && (itemList[position + 1] as IndexedListItem).index == item.index)
                    : true;
                return InkWell(
                  onTap: () {
                    item.selectCallback?.call();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: showUnderline ? Border(
                        bottom: BorderSide(
                          color: IndexedSelectListPanel.defaultItemDividerColor(context),
                          width: 1.0,
                        ),
                      ) : null,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.name,
                        maxLines: 2,
                        style: TextStyle(
                          color: IndexedSelectListPanel.defaultTitleColor(context),
                          fontSize: IndexedSelectListPanel.defaultTextSize(context),
                        )
                      ),
                    ),
                  ),
                );
              },
              susItemBuilder: widget.showIndex
              ? (context, index) {
                if (itemList[index] is IndexedListHeader) {
                  return const SizedBox();
                }
                return Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 12),
                  color: const Color(0xFFEEF4FE),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(itemList[index].getSuspensionTag(),
                      style: TextStyle(
                        color: Color(0xFF52575C),
                        fontSize: IndexedSelectListPanel.defaultTextSize(context),
                      ),
                    ),
                  ),
                );
              }
              : null,
              indexBarData: SuspensionUtil.getTagIndexList(itemList),
              indexBarWidth: widget.showIndex ? kIndexBarWidth : 0,
              indexBarOptions: IndexBarOptions(
                needRebuild: true,
                color: Colors.transparent,
                textStyle: TextStyle(color: IndexedSelectListPanel.defaultTextColor(context)),
                // downTextStyle: TextStyle(color: AppColors.main),
                selectTextStyle: TextStyle(color: IndexedSelectListPanel.defaultSelectedTextColor(context)),
                selectItemDecoration: const BoxDecoration(
                    color: Colors.transparent
                ) // 必须设置背景才能正常显示选中颜色
                // localImages: [imgFavorite], //local images.
              ),
            ),
          ),
        ),
      ],
    );
  }
}
