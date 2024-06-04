import 'package:dio/dio.dart';
import 'package:dio_log_viewer/src/entity/result_entity.dart';
import 'dart:core';

class LogMapUtil {
  LogMapUtil._();

  static final Map<int, ResultEntity> _logMap = {};
  static final List<int> _logList = [];

  static List<int> get logList => _logList;

  static ResultEntity? resultById(int id) => _logMap[id];

  static addRequestLog(RequestOptions options, int maxLogCount) {
    if (_logList.length >= maxLogCount) {
      final lastId = _logList.last;
      _logMap.remove(lastId);
      _logList.removeLast();
    }

    final key = options.hashCode;
    _logList.insert(0, key);
    _logMap[key] = ResultEntity(
        options: options, startTime: DateTime.now().millisecondsSinceEpoch);
  }

  static addErrorLog(dynamic error) {
    final resEntity = _logMap[error.requestOptions.hashCode];
    resEntity?.err = error;
    resEntity?.endTime = DateTime.now().millisecondsSinceEpoch;
  }

  static addResponseLog(Response response) {
    final resEntity = _logMap[response.requestOptions.hashCode];
    resEntity?.response = response;
    resEntity?.endTime = DateTime.now().millisecondsSinceEpoch;
  }

  static removeLog() {
    _logList.clear();
    _logMap.clear();
  }
}
