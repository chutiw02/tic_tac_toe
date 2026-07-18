import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/services/ai_service.dart';
import '../utils/game_result.dart';
import '../providers/game_provider.dart';
import '../widgets/board_widget.dart';
import '../utils/player.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Game")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            _buildStatus(provider),

            const SizedBox(height: 20),

            Expanded(
              child: BoardWidget(
                board: provider.board,

                onCellTap: (row, col) async {
                  bool moved = provider.makeMove(row, col);

                  if (!moved) {
                    return;
                  }
                  // ถ้าเกมจบ ไม่ต้องให้ AI เล่น
                  if (provider.isGameOver) {
                    return;
                  }

                  await Future.delayed(const Duration(microseconds: 2000));

                  final aiMove = AiService().getBestMove(provider.board);

                  if (aiMove != null) {
                    provider.makeAiMove(aiMove.$1, aiMove.$2);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                provider.initializeBoard(provider.boardSize);
              },

              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(GameProvider provider) {
    if (provider.isGameOver) {
      return Text(
        _resultText(provider),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      );
    }

    return Text(
      "Turn : ${provider.currentPlayer.symbol}",
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  String _resultText(GameProvider provider) {
    switch (provider.gameResult) {
      case GameResult.xWin:
        return "X Winner 🎉";

      case GameResult.oWin:
        return "O Winner 🎉";

      case GameResult.draw:
        return "Draw";

      default:
        return "";
    }
  }
}
