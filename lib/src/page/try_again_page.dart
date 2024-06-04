import 'package:dio/dio.dart';
import 'package:dio_log_viewer/src/utils/method_color_util.dart';
import 'package:dio_log_viewer/src/widget/header_widget.dart';
import 'package:flutter/material.dart';

import '../entity/result_entity.dart';

class TryAgainPage extends StatefulWidget {
  final ResultEntity entity;
  const TryAgainPage(this.entity, {super.key});

  @override
  State<TryAgainPage> createState() => _TryAgainPageState();
}

class _TryAgainPageState extends State<TryAgainPage>
    with AutomaticKeepAliveClientMixin {
  final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3.0,
            spreadRadius: 1.0),
      ]);

  late final _tempDio = Dio()
    ..options.copyWith(
        method: widget.entity.options.method,
        connectTimeout: widget.entity.options.connectTimeout,
        receiveTimeout: widget.entity.options.receiveTimeout,
        sendTimeout: widget.entity.options.sendTimeout,
        contentType: widget.entity.options.contentType,
        responseType: widget.entity.options.responseType,
        extra: widget.entity.options.extra,
        queryParameters: widget.entity.options.queryParameters,
        validateStatus: widget.entity.options.validateStatus,
        followRedirects: widget.entity.options.followRedirects,
        maxRedirects: widget.entity.options.maxRedirects,
        listFormat: widget.entity.options.listFormat)
    ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      options.headers.addAll(widget.entity.options.headers);
      return handler.next(options); //continue
    }));

  bool isExpandRequest = false;

  bool isLoading = false;

  late ResultEntity tempResult = ResultEntity(options: widget.entity.options);

  _loadData() async {
    isLoading = true;
    tempResult = ResultEntity(options: widget.entity.options);
    setState(() {});
    tempResult.startTime = DateTime.now().millisecondsSinceEpoch;
    try {
      final res = await _tempDio.requestUri(
        widget.entity.options.uri,
        options: Options(method: widget.entity.options.method),
        data:
            widget.entity.options.data ?? widget.entity.options.queryParameters,
      );
      tempResult.response = res;
    } on Exception catch (err) {
      tempResult.err = err;
    } finally {
      tempResult.endTime = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: decoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                    text: TextSpan(children: [
                  WidgetSpan(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                          color: MethodColorUtil.getMethodColor(
                              widget.entity.options.method),
                          borderRadius: BorderRadius.circular(2.0)),
                      child: Text(
                        widget.entity.options.method,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  TextSpan(
                      text: widget.entity.options.uri.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15))
                ])),
                const SizedBox(height: 15),
                Material(
                    child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: InkWell(
                      splashColor: Colors.white.withOpacity(0.3),
                      onTap: isLoading ? null : _loadData,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 45,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isLoading)
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 20,
                                height: 20,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            const Text(
                              'Try Now',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),
                ))
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: isExpandRequest
                ? BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8))
                : decoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpandRequest = !isExpandRequest;
                    });
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Text(
                          'Request',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const Spacer(),
                        Icon(isExpandRequest
                            ? Icons.arrow_drop_down
                            : Icons.arrow_right)
                      ],
                    ),
                  ),
                ),
                if (isExpandRequest)
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 15.0, left: 12.0, right: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderWidget(
                            title: 'Header',
                            result: widget.entity.options.headers),
                        if (widget.entity.options.queryParameters.isNotEmpty)
                          HeaderWidget(
                            title: 'Parameters',
                            result: widget.entity.options.queryParameters,
                          ),
                        if (widget.entity.options.data != null)
                          HeaderWidget(
                              title: 'Body',
                              result: widget.entity.options.data),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 45,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: const Row(
                    children: [
                      Text(
                        'Response',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tempResult.endTime != null)
                        HeaderWidget(
                          title: 'Duration',
                          result: {
                            'startTime': DateTime.fromMillisecondsSinceEpoch(
                                    tempResult.startTime!)
                                .toString(),
                            'endTime': tempResult.endTime != null
                                ? DateTime.fromMillisecondsSinceEpoch(
                                        tempResult.endTime!)
                                    .toString()
                                : '',
                            'duration':
                                '${tempResult.endTime! - tempResult.startTime!}ms',
                          },
                          isShowSegment: true,
                        ),
                      if (tempResult.response != null)
                        HeaderWidget(
                          title: 'Header',
                          result: tempResult.response!.headers.map,
                          isShowSegment: true,
                        ),
                      if (tempResult.response != null)
                        HeaderWidget(
                          title: 'Data',
                          result: tempResult.response?.data,
                          isShowSegment: true,
                        ),
                      if (tempResult.err != null)
                        HeaderWidget(
                          title: 'Error',
                          result: tempResult.err.toString(),
                          isShowSegment: true,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
