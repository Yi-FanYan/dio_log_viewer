import 'dart:convert';

import 'package:dio_log_viewer/src/page/json_wrap_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class JsonHandlePage extends StatefulWidget {
  final String jsonStr;
  const JsonHandlePage(this.jsonStr, {super.key});

  @override
  State<JsonHandlePage> createState() => _JsonHandlePageState();
}

class _JsonHandlePageState extends State<JsonHandlePage> {
  dynamic _parseResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PlanText',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxHeight: 220, minWidth: double.infinity),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(widget.jsonStr),
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        try {
                          _parseResult = jsonDecode(widget.jsonStr);
                        } catch (e) {
                          _parseResult = e.toString();
                        }
                        setState(() {});
                      },
                      child: const Text('JsonDec')),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          _parseResult = jsonEncode(widget.jsonStr);
                        } catch (e) {
                          _parseResult = e.toString();
                        }
                        setState(() {});
                      },
                      child: const Text('JsonEnc')),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          _parseResult = base64Decode(widget.jsonStr);
                        } catch (e) {
                          _parseResult = e.toString();
                        }
                        setState(() {});
                      },
                      child: const Text('Base64Dec')),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          var bytes = utf8.encode(widget.jsonStr);
                          _parseResult = base64Encode(bytes);
                        } catch (e) {
                          _parseResult = e.toString();
                        }
                        setState(() {});
                      },
                      child: const Text('Base64Enc')),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          _parseResult = Uri.decodeFull(widget.jsonStr);
                        } catch (e) {
                          _parseResult = e.toString();
                        }
                        setState(() {});
                      },
                      child: const Text('UrlDec')),
                  ElevatedButton(
                      onPressed: () {
                        try {
                          _parseResult = Uri.encodeFull(widget.jsonStr);
                        } catch (e) {
                          _parseResult = e.toString();
                        }
                        setState(() {});
                      },
                      child: const Text('UrlEnc')),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Text(
                    'Handle Result',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Builder(builder: (context) {
                    return TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _parseResult.toString())).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Copy Success!'),
                              showCloseIcon: true,
                              closeIconColor: Colors.white,
                            ));
                          });
                        },
                        child: const Text('Copy'));
                  })
                ],
              ),
              JsonWrapWidget(_parseResult)
            ],
          ),
        ),
      ),
    );
  }
}
