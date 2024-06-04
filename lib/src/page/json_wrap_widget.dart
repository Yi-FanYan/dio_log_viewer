import 'package:flutter/material.dart';

import '../json/json_viewer.dart';
import '../json/theme.dart';

class JsonWrapWidget extends StatelessWidget {
  final dynamic value;
  const JsonWrapWidget(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: double.infinity),
      padding: const EdgeInsets.all(12),
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
      child: JsonViewer(value,
          colorTheme: ColorTheme.of(Theme.of(context).brightness)),
    );
  }
}
