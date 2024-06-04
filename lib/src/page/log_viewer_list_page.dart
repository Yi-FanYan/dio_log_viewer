import 'dart:math';

import 'package:dio_log_viewer/src/page/log_detail.dart';
import 'package:dio_log_viewer/src/utils/log_map_util.dart';
import 'package:dio_log_viewer/src/entity/result_entity.dart';
import 'package:dio_log_viewer/src/utils/method_color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogViewerListPage extends StatefulWidget {
  const LogViewerListPage({super.key});

  @override
  State<LogViewerListPage> createState() => _LogViewerListPageState();
}

class _LogViewerListPageState extends State<LogViewerListPage> {
  late final width = MediaQuery.of(context).size.width;

  bool isRotate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogViewer'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isRotate = !isRotate;
                });
              },
              icon: TweenAnimationBuilder(
                tween: isRotate
                    ? Tween(begin: 0.0, end: 4 * pi)
                    : Tween(begin: 4 * pi, end: 0.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, double value, child) {
                  return Transform.rotate(
                    angle: value,
                    child: child,
                  );
                },
                child: const Icon(Icons.refresh),
              )),
          IconButton(
              onPressed: () {
                LogMapUtil.removeLog();
                setState(() {});
              },
              icon: const Icon(Icons.delete_forever_sharp)),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth != width) {
          return const SizedBox();
        }
        return LoggerRequestViewer(
          onChange: (ResultEntity res) {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) {
                return LogDetail(entity: res);
              }),
            );
          },
        );
      }),
    );
  }
}

class LoggerRequestViewer extends StatelessWidget {
  final ValueChanged<ResultEntity>? onChange;
  const LoggerRequestViewer({super.key, this.onChange});

  @override
  Widget build(BuildContext context) {
    if (LogMapUtil.logList.isEmpty) {
      return const Center(
        child: Text('No Network Data'),
      );
    }
    return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final res = LogMapUtil.resultById(LogMapUtil.logList[index]);
          if (res == null) return const SizedBox();
          final method = res.options.method;
          final startTime = DateTime.fromMillisecondsSinceEpoch(res.startTime!)
              .toString()
              .split(' ')
              .last;
          return RequestItem(
            method: method,
            link: res.options.uri.toString(),
            methodColor: MethodColorUtil.getMethodColor(method),
            isError: res.err != null,
            statusCode: res.response?.statusCode ?? 200,
            time:
                res.endTime != null ? '${res.endTime! - res.startTime!}ms' : '',
            startTime: startTime,
            onTap: () {
              onChange?.call(res);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
        itemCount: LogMapUtil.logList.length);
  }
}

class RequestItem extends StatelessWidget {
  final String method;
  final String link;
  final Color methodColor;
  final bool isError;
  final int statusCode;
  final String time;
  final String startTime;
  final GestureTapCallback? onTap;
  const RequestItem(
      {super.key,
      required this.method,
      required this.link,
      required this.methodColor,
      required this.statusCode,
      required this.time,
      required this.startTime,
      this.onTap,
      this.isError = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isError ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ]),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: methodColor,
                  ),
                  child: Text(
                    '$method${statusCode != 200 ? '：$statusCode' : ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          width: 0.5,
                          color: methodColor)),
                  child: Text(time == '' ? 'Loading' : time,
                      style: TextStyle(color: methodColor, fontSize: 12)),
                ),
                const Spacer(),
                Text(
                  startTime,
                  style: TextStyle(fontSize: 13, color: methodColor),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(link,
                  style: TextStyle(
                      color: isError ? Colors.red : Colors.black,
                      fontSize: 15)),
            )
          ],
        ),
      ),
    );
  }
}
