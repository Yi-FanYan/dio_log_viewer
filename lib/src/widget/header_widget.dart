import 'dart:convert';

import 'package:dio_log_viewer/src/widget/divid_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../page/json_wrap_widget.dart';

class HeaderWidget extends StatefulWidget {
  final String title;
  final bool isShowSegment;
  final dynamic result;
  const HeaderWidget(
      {super.key,
      required this.title,
      required this.result,
      this.isShowSegment = false});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late dynamic requestResult = widget.result;
  final jsonIndent = const JsonEncoder.withIndent('  ');
  String formatType = 'Prettify';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: widget.isShowSegment ? null : 44.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 15,
                    color: Theme.of(context).primaryColor,
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (widget.isShowSegment)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      final res = widget.result is String
                          ? widget.result
                          : jsonEncode(widget.result);
                      Clipboard.setData(ClipboardData(text: res)).then((res) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Copy Success!"),
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                          ),
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.teal,
                      size: 20,
                    ),
                    tooltip: 'Copy',
                  ),
                  const DividerWidget(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          formatType = 'Prettify';
                          requestResult = widget.result;
                        });
                      },
                      child: Text(
                        'Prettify',
                        style: TextStyle(
                            fontWeight: formatType == 'Prettify'
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                  const DividerWidget(),
                  TextButton(
                      onPressed: () {
                        var jsonRes = jsonIndent.convert(widget.result);
                        setState(() {
                          formatType = 'Json';
                          requestResult = jsonRes;
                        });
                      },
                      child: Text(
                        'Json',
                        style: TextStyle(
                            fontWeight: formatType == 'Json'
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                  const DividerWidget(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          formatType = 'Text';
                          requestResult = json.encode(widget.result);
                        });
                      },
                      child: Text(
                        'Text',
                        style: TextStyle(
                            fontWeight: formatType == 'Text'
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                ],
              )
          ],
        ),
        JsonWrapWidget(requestResult)
      ],
    );
  }
}
