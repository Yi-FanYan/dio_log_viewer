import 'drag_button.dart';
import 'package:flutter/material.dart';

class DioLogViewer {
  static OverlayEntry? _overlayEntry;

  static showLogButton(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      _overlayEntry = OverlayEntry(builder: (context) {
        return const DragButton();
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
