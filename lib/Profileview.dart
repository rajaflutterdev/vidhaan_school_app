import 'package:flutter/material.dart';

class Profileview2 extends StatefulWidget {
  String img;
  Profileview2(this.img);

  @override
  State<Profileview2> createState() => _Profileview2State();
}

class _Profileview2State extends State<Profileview2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        maxScale: 5.0,
        child: PageView(
          children: [
           Image.network(widget.img.toString()),

          ],
        ),
      ),
    );
  }
}
