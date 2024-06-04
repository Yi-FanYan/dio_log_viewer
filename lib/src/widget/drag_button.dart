import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../page/log_viewer_list_page.dart';
import 'package:flutter/material.dart';

class DragButton extends StatefulWidget {
  final double? top;
  final double? left;
  final double buttonSize;
  final Color? buttonColor;
  final String buttonText;
  final Color? buttonTextColor;
  const DragButton(
      {super.key,
      this.top,
      this.left,
      this.buttonSize = 70.0,
      this.buttonColor,
      this.buttonText = 'Log',
      this.buttonTextColor});

  @override
  State<DragButton> createState() => _DragButtonState();
}

class _DragButtonState extends State<DragButton> {
  late final width = MediaQuery.of(context).size.width;
  late final height = MediaQuery.of(context).size.height;
  late final topGap = MediaQuery.of(context).padding.top;
  late final bottomGap = MediaQuery.of(context).padding.bottom;

  late final dragButtonWidth = widget.buttonSize;
  final edgeGap = 15.0;

  late double left = widget.left ?? edgeGap;
  late double top = widget.top ?? height * 0.5 - dragButtonWidth;

  bool isUpdatePan = true;

  final duration = const Duration(milliseconds: 300);

  double _buttonOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _buttonOpacity == 0,
      child: Opacity(
        opacity: _buttonOpacity,
        child: Stack(
          children: [
            AnimatedPositioned(
              left: left,
              top: top,
              duration: isUpdatePan ? Duration.zero : duration,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    isUpdatePan = true;
                    left += details.delta.dx;
                    top += details.delta.dy;
                  });
                },
                onPanEnd: (_) {
                  if (left <= 0) {
                    left = edgeGap;
                  }

                  if (left + dragButtonWidth + edgeGap >= width) {
                    left = width - dragButtonWidth - edgeGap;
                  }

                  if (top <= topGap) {
                    top = topGap;
                  }
                  if (top + dragButtonWidth + bottomGap + edgeGap >= height) {
                    top = height - dragButtonWidth - max(bottomGap, edgeGap);
                  }
                  setState(() {
                    isUpdatePan = false;
                  });
                },
                onTap: () async {
                  setState(() {
                    _buttonOpacity = 0;
                  });
                  await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) {
                        return const LogViewerListPage();
                      },
                    ),
                  );
                  setState(() {
                    _buttonOpacity = 1.0;
                  });
                },
                child: Container(
                  width: dragButtonWidth,
                  height: dragButtonWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(dragButtonWidth),
                      color: widget.buttonColor ??
                          Theme.of(context).primaryColor.withOpacity(0.5)),
                  alignment: Alignment.center,
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: widget.buttonTextColor ?? Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
