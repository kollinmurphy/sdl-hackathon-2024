import 'package:flutter/material.dart';

class DieDisplay extends StatelessWidget {
  const DieDisplay({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    if (value == 0) return const SizedBox.shrink();
    return Image(
      alignment: Alignment.center,
      image: AssetImage('assets/DicePack/die$value.png'),
    );
  }
}
