import 'package:dio/dio.dart';

class ResultEntity {
  RequestOptions options;
  Response? response;
  Exception? err;
  int? startTime;
  int? endTime;
  ResultEntity({required this.options, this.response, this.err,this.startTime,this.endTime});

  @override
  String toString() {
    return '''ResultEntity{
      options: $options,'
      response: $response,'
      err: $err,'
      startTime: ${startTime == null ? '': DateTime.fromMillisecondsSinceEpoch(startTime!)},'
      endTime: ${endTime == null ? '': DateTime.fromMillisecondsSinceEpoch(endTime!)}
    } ''';
  }
}