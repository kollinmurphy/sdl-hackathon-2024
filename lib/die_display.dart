import 'package:flutter/material.dart';

class DieDisplay extends StatelessWidget {
  const DieDisplay({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    // display asset image based on value
    return Image.asset('DicePack/$value.png');
  }
}
