import 'package:flutter/cupertino.dart';

import '../page/log_viewer_list_page.dart';
import 'package:flutter/material.dart';


class DragButton extends StatefulWidget {
  const DragButton({super.key});

  @override
  State<DragButton> createState() => _DragButtonState();
}

class _DragButtonState extends State<DragButton> {

  late final width = MediaQuery.of(context).size.width;
  late final height = MediaQuery.of(context).size.height;
  final dragButtonWidth = 70.0;
  double left = 15;
  late double topGap = MediaQuery.of(context).padding.top;
  late double top = topGap;
  late double bottomGap = MediaQuery.of(context).padding.bottom;

  bool isFullScreen = false;
  bool isUpdatePan = true;

  final duration = const Duration(milliseconds: 300);

  Widget defaultWidget = const Text('Log',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),);

  double _buttonOpacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _buttonOpacity,
      child: Stack(
        children: [
          AnimatedPositioned(
            left: isFullScreen?0:left,
            top: isFullScreen?0:top,
            duration: isUpdatePan?Duration.zero:duration,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  isUpdatePan = true;
                  left += details.delta.dx;
                  top += details.delta.dy;
                });
              },
              onPanEnd: (_){
                if(left <= 0){
                  left = 15;
                }

                if(left+75 >=  width){
                  left = width - 75;
                }

                if(top <= topGap){
                  top = MediaQuery.of(context).padding.top;
                }
                if(top+dragButtonWidth >= height - bottomGap){
                  top = height - bottomGap - 75;
                }
                setState(() {
                  isUpdatePan = false;
                });
              },
              onTap: () async {
                setState(() {
                  _buttonOpacity = 0;
                });
                await Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                  return const LogViewerListPage();
                }));
                setState(() {
                  _buttonOpacity = 1.0;
                });
              },
              child: Container(
                width: dragButtonWidth,
                height: dragButtonWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isFullScreen?0:dragButtonWidth),
                    color: isFullScreen?Colors.white:Theme.of(context).primaryColor.withOpacity(0.5)
                ),
                alignment: Alignment.center,
                child:defaultWidget,
              ),
            ),
          )
        ],
      ),
    );
  }
}
