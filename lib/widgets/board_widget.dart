import 'package:flutter/material.dart';

import '../utils/player.dart';
import 'board_cell.dart';

class BoardWidget extends StatelessWidget {
  final List<List<Player>> board;

  final void Function(int row, int col) onCellTap;

  const BoardWidget({
    super.key,
    required this.board,
    required this.onCellTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = board.length;

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: size * size,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size,
        ),
        itemBuilder: (context, index) {
          final row = index ~/ size;

          final col = index % size;

          return BoardCell(
            player: board[row][col],
            onTap: () {
              onCellTap(row, col);
            },
          );
        },
      ),
    );
  }
}