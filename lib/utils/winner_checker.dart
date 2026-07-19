import 'game_result.dart';
import 'player.dart';

class WinnerChecker {
  static GameResult check(List<List<Player>> board) {
    final size = board.length;

    // Row
    for (int row = 0; row < size; row++) {
      final first = board[row][0];

      if (first.isEmpty) continue;

      bool win = true;

      for (int col = 1; col < size; col++) {
        if (board[row][col] != first) {
          win = false;
          break;
        }
      }

      if (win) {
        return first == Player.x ? GameResult.xWin : GameResult.oWin;
      }
    }

    // Column
    for (int col = 0; col < size; col++) {
      final first = board[0][col];

      if (first.isEmpty) continue;

      bool win = true;

      for (int row = 1; row < size; row++) {
        if (board[row][col] != first) {
          win = false;
          break;
        }
      }

      if (win) {
        return first == Player.x ? GameResult.xWin : GameResult.oWin;
      }
    }

    // Main Diagonal
    final diagonal = board[0][0];

    if (diagonal.isNotEmpty) {
      bool win = true;

      for (int i = 1; i < size; i++) {
        if (board[i][i] != diagonal) {
          win = false;
          break;
        }
      }

      if (win) {
        return diagonal == Player.x ? GameResult.xWin : GameResult.oWin;
      }
    }

    // Anti Diagonal
    final anti = board[0][size - 1];

    if (anti.isNotEmpty) {
      bool win = true;

      for (int i = 1; i < size; i++) {
        if (board[i][size - i - 1] != anti) {
          win = false;
          break;
        }
      }

      if (win) {
        return anti == Player.x ? GameResult.xWin : GameResult.oWin;
      }
    }

    // Draw
    bool full = true;

    for (final row in board) {
      if (row.contains(Player.none)) {
        full = false;
        break;
      }
    }

    if (full) {
      return GameResult.draw;
    }

    return GameResult.playing;
  }
}
