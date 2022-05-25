import 'package:flutter/material.dart';
class timeout extends StatefulWidget {
  const timeout({Key? key}) : super(key: key);

  @override
  State<timeout> createState() => _timeoutState();
}

class _timeoutState extends State<timeout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: showDialog(context: context, builder: builder),
      ),
    );
  }
}
