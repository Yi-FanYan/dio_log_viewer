import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .5,
      height: 15.0,
      color: Theme.of(context).primaryColor.withOpacity(0.5),
    );
  }
}
