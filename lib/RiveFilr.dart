import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class Rivefile extends StatefulWidget {
  const Rivefile({Key? key}) : super(key: key);

  @override
  State<Rivefile> createState() => _RivefileState();
}

class _RivefileState extends State<Rivefile> {
  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset("assets/otp.riv");
  }
}
