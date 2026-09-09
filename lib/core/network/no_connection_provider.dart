import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monex/core/network/no_connection_service.dart';

class NoConnectionNotifier extends Notifier<bool?> {
  final NoConnectionService _service = NoConnectionService();

  @override
  bool? build() {
    _initialize();

    _service.onConnectionChanged.listen((event) {
      state = !event.contains(ConnectivityResult.none);
    });

    return null;
  }

  void _initialize() async {
    state = await _service.hasInternet();

    _service.onConnectionChanged.listen((event) {
      state = !event.contains(ConnectivityResult.none);
    });
  }

  Future<bool> checkInternet() async {
    state = await _service.hasInternet();
    return state ?? false;
  }
}

final noConnectionProvider = NotifierProvider<NoConnectionNotifier, bool?>(
  NoConnectionNotifier.new,
);

final noConnectionImageProvider = Provider((ref) {
  return "assets/images/no_connection.svg";
});
