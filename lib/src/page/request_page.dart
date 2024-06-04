import 'package:dio/dio.dart';
import 'package:dio_log_viewer/src/widget/header_widget.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  final RequestOptions requestOptions;
  final int startTime;
  final int? endTime;
  const RequestPage(this.requestOptions, this.startTime, this.endTime,
      {super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              title: 'Url',
              result: widget.requestOptions.uri.toString(),
            ),
            HeaderWidget(
              title: 'Method',
              result: widget.requestOptions.method,
            ),
            HeaderWidget(
              title: 'Duration',
              result: {
                'startTime':
                    DateTime.fromMillisecondsSinceEpoch(widget.startTime)
                        .toString(),
                'endTime': widget.endTime != null
                    ? DateTime.fromMillisecondsSinceEpoch(widget.endTime!)
                        .toString()
                    : '',
                'duration': widget.endTime != null
                    ? '${widget.endTime! - widget.startTime}ms'
                    : '',
              },
            ),
            if (widget.requestOptions.queryParameters.isNotEmpty)
              HeaderWidget(
                title: 'Parameters',
                isShowSegment: true,
                result: widget.requestOptions.queryParameters,
              ),
            if (widget.requestOptions.data != null)
              HeaderWidget(
                  title: 'Body',
                  isShowSegment: true,
                  result: widget.requestOptions.data),
            HeaderWidget(
              title: 'Header',
              isShowSegment: true,
              result: widget.requestOptions.headers,
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
