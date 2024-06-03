import 'package:dio/dio.dart';
import 'package:dio_log_viewer/src/utils/log_map_util.dart';

class DioLogViewerInterceptor extends Interceptor {

  final bool enable;
  final int maxLogCount;

  DioLogViewerInterceptor({this.enable = true,this.maxLogCount = 50});


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if(enable) LogMapUtil.addRequestLog(options,maxLogCount);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(enable) LogMapUtil.addResponseLog(response);
    handler.next(response);
  }

  @override
  void onError(dynamic err, ErrorInterceptorHandler handler) {
    if(enable) LogMapUtil.addErrorLog(err);
    handler.next(err);
  }

}
