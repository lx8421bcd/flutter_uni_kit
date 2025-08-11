/// 分页加载计算工具
///
/// @author linxiao
/// @since 2023-11-24
class PageLoadCounter {

  /// 单页数据量
  int pageSize = 10;
  /// 页码
  int _pageNum = 0;
  /// 已加载数据量
  int _loadedCount = 0;
  /// 是否有更多数据
  bool _hasMorePage = true;

  PageLoadCounter({
    this.pageSize = 10,
  });

  int get nextPage {
    _pageNum = _pageNum + 1;
    return _pageNum;
  }

  bool get isEmpty {
    return _pageNum <= 1 && _loadedCount <= 0;
  }

  int get pageNum => _pageNum;

  int get loadedCount => _loadedCount;

  bool get hasMore => _hasMorePage;

  void onPageLoaded(int dataCount) {
    _loadedCount += dataCount;
    // 如果当前加载的数据没有达到请求所需的分页数据量，则可以认为数据已加载完毕，没有更多分页
    _hasMorePage = dataCount >= pageSize;
  }

  void reset() {
    _pageNum = 0;
    _loadedCount = 0;
    _hasMorePage = true;
  }
}