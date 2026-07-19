import '../utils/player.dart';
import '../utils/game_result.dart';
import '../utils/winner_checker.dart';

class AiService {
  (int row, int col)? getBestMove(List<List<Player>> board) {
    int size = board.length;

    if (size != 3) {
      return _findBestHeuristicMove(board);
    }

    int bestScore = -999999;

    (int, int)? bestMove;

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] == Player.none) {
          board[row][col] = Player.o;

          int score = minimax(board, false);

          board[row][col] = Player.none;

          if (score > bestScore) {
            bestScore = score;

            bestMove = (row, col);
          }
        }
      }
    }

    return bestMove;
  }

  (int row, int col)? _findBestHeuristicMove(List<List<Player>> board) {
    int bestScore = -999999;

    (int, int)? bestMove;

    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board.length; col++) {
        if (board[row][col] == Player.none) {
          board[row][col] = Player.o;

          int score = _evaluatePosition(board, row, col);

          board[row][col] = Player.none;

          if (score > bestScore) {
            bestScore = score;

            bestMove = (row, col);
          }
        }
      }
    }

    return bestMove;
  }

  int minimax(List<List<Player>> board, bool isMaximizing) {
    GameResult result = WinnerChecker.check(board);

    if (result == GameResult.oWin) {
      return 10;
    }

    if (result == GameResult.xWin) {
      return -10;
    }

    if (result == GameResult.draw) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -999999;

      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (board[row][col] == Player.none) {
            board[row][col] = Player.o;

            int score = minimax(board, false);

            board[row][col] = Player.none;

            if (score > bestScore) {
              bestScore = score;
            }
          }
        }
      }

      return bestScore;
    } else {
      int bestScore = 999999;

      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if (board[row][col] == Player.none) {
            board[row][col] = Player.x;

            int score = minimax(board, true);

            board[row][col] = Player.none;

            if (score < bestScore) {
              bestScore = score;
            }
          }
        }
      }

      return bestScore;
    }
  }

  int _evaluatePosition(List<List<Player>> board, int row, int col) {
    int score = 0;

    // AI ได้ช่อง
    score += 10;

    // กลางกระดานสำคัญ
    int center = board.length ~/ 2;

    if (row == center && col == center) {
      score += 20;
    }

    return score;
  }
}
