import 'package:flutter/material.dart';

import '../widget/header_widget.dart';

class ErrorPage extends StatefulWidget {
  final dynamic error;
  const ErrorPage(this.error, {super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

// DioException({
// required this.requestOptions,
// this.response,
// this.type = DioExceptionType.unknown,
// this.error,
// StackTrace? stackTrace,
// this.message,
// })
class _ErrorPageState extends State<ErrorPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.error == null
        ? const Center(child: Text('No Error'))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderWidget(
                    title: 'Error',
                    result: widget.error.toString(),
                    isShowSegment: true,
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
