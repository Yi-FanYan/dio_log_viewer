
import 'package:dio/dio.dart';
import 'package:dio_log_viewer/src/widget/header_widget.dart';
import 'package:flutter/material.dart';

class ResponsePage extends StatefulWidget {
  final Response? response;
  const ResponsePage(this.response, {super.key});

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.response == null
        ? const Center(child: Text('No response'))
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal:12),
          child: SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderWidget(title: 'Header', result: widget.response?.headers.map,isShowSegment: true,),
            HeaderWidget(title: 'Data', result: widget.response?.data,isShowSegment: true,),
            const SizedBox(height: 20)
          ],
      ),
    ),
        );
  }
  @override
  bool get wantKeepAlive => true;
}
