import 'drag_button.dart';
import 'package:flutter/material.dart';

class DioLogViewer {
  static OverlayEntry? _overlayEntry;

  /// show log button
  /// [buttonSize] button size,default 70.0
  /// [buttonText] button text,default 'Log'
  /// [buttonColor] button color
  /// [buttonTextColor] button text color
  /// [top] top distance from the top of the screen
  /// [left] left distance from the left of the screen
  static showLogButton(
    BuildContext context, {
    double buttonSize = 70.0,
    String buttonText = 'Log',
    Color? buttonColor,
    Color? buttonTextColor,
    double? top,
    double? left,
  }) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      _overlayEntry = OverlayEntry(builder: (context) {
        return DragButton(
          top: top,
          left: left,
          buttonSize: buttonSize,
          buttonColor: buttonColor,
          buttonText: buttonText,
          buttonTextColor: buttonTextColor,
        );
      });
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  static dismiss() {
    if (_overlayEntry == null) return;
    _overlayEntry!.remove();
    _overlayEntry = null;
  }
}
