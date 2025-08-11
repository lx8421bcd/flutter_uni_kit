import 'dart:async';

/// 全局事件总线管理
///
/// @author linxiao
/// @since 2023-10-27
class EventBus {

  static const _defaultBusName = "DEFAULT_BUS";
  static final Map<String, EventBus> _busContainer = {};

  static EventBus get([String busName = _defaultBusName, bool sync = false]) {
    if (busName.isEmpty) {
      busName = _defaultBusName;
    }
    return _busContainer[busName] ?? EventBus._internal(busName, sync: sync);
  }

  final StreamController _streamController;
  final String busName;
  final Map<dynamic, List<_BusSubscription>> _subscriptions = {};

  EventBus._internal(this.busName, {bool sync = false})
      : _streamController = StreamController.broadcast(sync: sync) {
   // init codes
    _busContainer[busName] = this;
  }

  void register<T>(dynamic subscriber, void Function(T event) onData) {
    var stream = T == dynamic
        ? _streamController.stream as Stream<T>
        : _streamController.stream.where((event) => event is T).cast<T>();
    var subscription = stream.listen(onData);
    var subscribeList = _subscriptions[subscriber];
    if (subscribeList == null) {
      subscribeList = [];
      _subscriptions[subscriber] = subscribeList;
    }
    subscribeList.add(_BusSubscription(T, subscription));
  }

  void unregister<T>(dynamic subscriber) {
    var subscriberSubscriptions = _subscriptions[subscriber];
    if (subscriberSubscriptions == null) {
      return;
    }
    subscriberSubscriptions.removeWhere((element) {
      if (element.type == T || T == dynamic) {
        element.subscription.cancel();
        return true;
      }
      return false;
    });
    if (subscriberSubscriptions.isEmpty) {
      _subscriptions.remove(subscriber);
    }
  }

  void post(event) {
    _streamController.add(event);
  }

  void destroy() {
    _subscriptions.forEach((key, subscriberSubscriptions) {
      for (var busSubscription in subscriberSubscriptions) {
        busSubscription.subscription.cancel();
      }
      subscriberSubscriptions.clear();
    });
    _subscriptions.clear();
    _streamController.close();
    _busContainer.remove(this);
  }
}

class _BusSubscription<T> {
  T type;
  StreamSubscription subscription;
  _BusSubscription(this.type, this.subscription);
}