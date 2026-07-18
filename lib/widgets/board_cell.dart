import 'package:flutter/material.dart';

import '../utils/player.dart';

class BoardCell extends StatelessWidget {
  final Player player;
  final VoidCallback onTap;

  const BoardCell({
    super.key,
    required this.player,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
          ),
        ),
        child: Center(
          child: Text(
            player.symbol,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}