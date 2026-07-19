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
    int size = board.length;

    // 1. ถ้าชนะได้ ให้ลงทันที
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] != Player.none) continue;

        board[row][col] = Player.o;

        if (WinnerChecker.check(board) == GameResult.oWin) {
          board[row][col] = Player.none;
          return (row, col);
        }

        board[row][col] = Player.none;
      }
    }

    // 2. ถ้า X กำลังจะชนะ ให้บล็อก
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] != Player.none) continue;

        board[row][col] = Player.x;

        if (WinnerChecker.check(board) == GameResult.xWin) {
          board[row][col] = Player.none;
          return (row, col);
        }

        board[row][col] = Player.none;
      }
    }

    // 3. ประเมินคะแนนทุกช่อง
    int bestScore = -999999;
    (int, int)? bestMove;

    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (board[row][col] != Player.none) continue;

        board[row][col] = Player.o;

        int score = _evaluatePosition(board, row, col);

        board[row][col] = Player.none;

        if (score > bestScore) {
          bestScore = score;
          bestMove = (row, col);
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
    int size = board.length;

    // คะแนนจากแถว
    for (int c = 0; c < size; c++) {
      if (board[row][c] == Player.o) score += 8;
      if (board[row][c] == Player.x) score += 4;
    }

    // คะแนนจากคอลัมน์
    for (int r = 0; r < size; r++) {
      if (board[r][col] == Player.o) score += 8;
      if (board[r][col] == Player.x) score += 4;
    }

    // แนวทแยงหลัก
    if (row == col) {
      for (int i = 0; i < size; i++) {
        if (board[i][i] == Player.o) score += 8;
        if (board[i][i] == Player.x) score += 4;
      }
    }

    // แนวทแยงรอง
    if (row + col == size - 1) {
      for (int i = 0; i < size; i++) {
        if (board[i][size - 1 - i] == Player.o) score += 8;
        if (board[i][size - 1 - i] == Player.x) score += 4;
      }
    }

    // โบนัสตรงกลาง
    int center = size ~/ 2;

    score += (size - (row - center).abs()) * 2;
    score += (size - (col - center).abs()) * 2;

    return score;
  }
}
