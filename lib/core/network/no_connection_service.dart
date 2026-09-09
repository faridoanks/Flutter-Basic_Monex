import 'package:connectivity_plus/connectivity_plus.dart';

class NoConnectionService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasInternet() async {
    final result = await _connectivity.checkConnectivity();

    return !result.contains(ConnectivityResult.none);
  }

  Stream<List<ConnectivityResult>> get onConnectionChanged {
    return _connectivity.onConnectivityChanged;
  }
}