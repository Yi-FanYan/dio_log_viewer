import 'dart:convert';

import 'package:dio_log_viewer/src/page/json_handle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './theme.dart';

class JsonViewer extends StatelessWidget {
  final dynamic jsonObj;
  final ColorTheme colorTheme;

  const JsonViewer(this.jsonObj, {super.key, required this.colorTheme});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        child: getContentWidget(jsonObj));
  }

  Widget getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewer(content, notRoot: false, colorTheme: colorTheme);
    } else if (content is Map<String, dynamic>) {
      return JsonObjectViewer(content, notRoot: false, colorTheme: colorTheme);
    } else {
      return Text(content?.toString() ?? '');
    }
  }
}

class JsonObjectViewer extends StatefulWidget {
  final ColorTheme colorTheme;

  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  const JsonObjectViewer(this.jsonObj,
      {super.key, this.notRoot = false, required this.colorTheme});

  @override
  JsonObjectViewerState createState() => JsonObjectViewerState();
}

class JsonObjectViewerState extends State<JsonObjectViewer> {
  Map<String, bool> openFlag = {};

  @override
  void didUpdateWidget(covariant JsonObjectViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    openFlag = {};
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: _getList()),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  _getList() {
    List<Widget> list = [];
    for (MapEntry entry in widget.jsonObj.entries) {
      if (openFlag[entry.key] == null) {
        openFlag[entry.key] =
            widget.notRoot == false && _isExtensible(entry.value);
      }

      list.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          getKeyWidget(entry),
          Text(':', style: TextStyle(color: widget.colorTheme.colon)),
          const SizedBox(width: 3),
          _copyValue(context, _getValueWidget(entry.value, widget.colorTheme),
              entry.value),
        ],
      ));
      list.add(const SizedBox(height: 4));

      if ((openFlag[entry.key] ?? false) && entry.value != null) {
        list.add(getContentWidget(entry.value, widget.colorTheme));
      }
    }
    return list;
  }

  Widget getKeyWidget(MapEntry entry) {
    if (_isExtensible(entry.value)) {
      return InkWell(
          onTap: () {
            setState(() {
              openFlag[entry.key] = !(openFlag[entry.key] ?? false);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (openFlag[entry.key] ?? false)
                  ? const Icon(Icons.keyboard_arrow_down, size: 18)
                  : const Icon(Icons.keyboard_arrow_right, size: 18),
              Text(entry.key,
                  style: TextStyle(color: widget.colorTheme.propertyKey)),
            ],
          ));
    }

    return Row(children: [
      const Icon(Icons.keyboard_arrow_right,
          color: Color.fromARGB(0, 0, 0, 0), size: 18),
      Text(entry.key, style: TextStyle(color: widget.colorTheme.propertyKey)),
    ]);
  }

  static getContentWidget(dynamic content, ColorTheme colorTheme) {
    if (content is List) {
      return JsonArrayViewer(content, notRoot: true, colorTheme: colorTheme);
    } else {
      return JsonObjectViewer(content, notRoot: true, colorTheme: colorTheme);
    }
  }
}

class JsonArrayViewer extends StatefulWidget {
  final ColorTheme colorTheme;
  final List<dynamic> jsonArray;
  final bool notRoot;

  const JsonArrayViewer(this.jsonArray,
      {super.key, this.notRoot = false, required this.colorTheme});

  @override
  State<JsonArrayViewer> createState() => _JsonArrayViewerState();
}

class _JsonArrayViewerState extends State<JsonArrayViewer> {
  late List<bool> openFlag;

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot) {
      return Container(
          padding: const EdgeInsets.only(left: 14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getList()));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  @override
  void initState() {
    super.initState();
    openFlag = List.filled(widget.jsonArray.length, false);
  }

  _getList() {
    List<Widget> list = [];
    int i = 0;
    for (dynamic content in widget.jsonArray) {
      list.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getKeyWidget(content, i),
          Text(':', style: TextStyle(color: widget.colorTheme.colon)),
          const SizedBox(width: 3),
          _copyValue(
              context, _getValueWidget(content, widget.colorTheme), content)
        ],
      ));
      list.add(const SizedBox(height: 4));
      if (openFlag[i]) {
        list.add(
            JsonObjectViewerState.getContentWidget(content, widget.colorTheme));
      }
      i++;
    }
    return list;
  }

  Widget getKeyWidget(dynamic content, int index) {
    if (_isExtensible(content)) {
      return InkWell(
          onTap: () {
            setState(() {
              openFlag[index] = !(openFlag[index]);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              openFlag[index]
                  ? const Icon(Icons.keyboard_arrow_down, size: 18)
                  : const Icon(Icons.keyboard_arrow_right, size: 18),
              Text('[$index]',
                  style: TextStyle(color: widget.colorTheme.propertyKey)),
            ],
          ));
    }

    return Row(children: [
      const Icon(Icons.arrow_right,
          color: Color.fromARGB(0, 0, 0, 0), size: 18),
      Text('[$index]', style: TextStyle(color: widget.colorTheme.propertyKey)),
    ]);
  }
}

Widget _getValueWidget(dynamic value, ColorTheme colorTheme) {
  if (value == null) {
    return Text('null', style: TextStyle(color: colorTheme.keyword));
  } else if (value is num) {
    return Text(value.toString(), style: TextStyle(color: colorTheme.keyword));
  } else if (value is String) {
    return Text('"$value"', style: TextStyle(color: colorTheme.string));
  } else if (value is bool) {
    return Text(value.toString(), style: TextStyle(color: colorTheme.keyword));
  } else if (value is List) {
    if (value.isEmpty) {
      return const Text('Array[0]');
    } else {
      return Text('Array<${_getTypeName(value[0])}>[${value.length}]');
    }
  }
  return const Text('Object', style: TextStyle(fontSize: 13));
}

String _getTypeName(dynamic content) {
  if (content is int) {
    return 'int';
  } else if (content is String) {
    return 'String';
  } else if (content is bool) {
    return 'bool';
  } else if (content is double) {
    return 'double';
  } else if (content is List) {
    return 'List';
  }
  return 'Object';
}

/// 复制值
Widget _copyValue(BuildContext context, Widget child, Object? value) {
  return Flexible(
    child: InkWell(
      child: child,
      onTap: () {
        final valueStr = value is String ? value : jsonEncode(value);
        Clipboard.setData(ClipboardData(text: valueStr)).then((res) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: const Text("Copy Success!"),
              action: SnackBarAction(
                  backgroundColor: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  label: 'HandleIt',
                  onPressed: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) {
                      return JsonHandlePage(valueStr);
                    }));
                  }),
            ),
          );
        });
      },
    ),
  );
}

bool _isExtensible(dynamic content) {
  if (content == null) {
    return false;
  } else if (content is int) {
    return false;
  } else if (content is String) {
    return false;
  } else if (content is bool) {
    return false;
  } else if (content is double) {
    return false;
  }
  return true;
}
