import 'dart:async';

import 'package:effectivelearning/helper.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class DataConnectivityService {
  StreamController<DataConnectionStatus> connectivityStreamController = StreamController<DataConnectionStatus>();
  DataConnectivityService() {
    zlog("First Call");
    DataConnectionChecker().onStatusChange.listen((dataConnectionStatus) {
      zlog("Connectivity Changes");
      zlog(dataConnectionStatus);
      connectivityStreamController.add(dataConnectionStatus);
    });
  }
}