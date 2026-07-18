import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/player.dart';
import '../providers/game_provider.dart';
import '../widgets/board_widget.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Current Player : ${provider.currentPlayer.symbol}",
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BoardWidget(
                board: provider.board,
                onCellTap: provider.makeMove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}