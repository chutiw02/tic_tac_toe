import 'package:flutter/material.dart';

import '../models/move_model.dart';
import '../utils/player.dart';
import '../utils/winner_checker.dart';
import '../utils/game_result.dart';
import '../services/firestore_service.dart';

class GameProvider extends ChangeNotifier {
  int _boardSize = 3;

  List<List<Player>> _board = [];

  Player _currentPlayer = Player.x;

  GameResult _gameResult = GameResult.playing;

  final List<MoveModel> _moves = [];

  bool _gameSaved = false;

  GameProvider() {
    initializeBoard();
  }

  //======================
  // Getter
  //======================

  int get boardSize => _boardSize;

  List<List<Player>> get board =>
      _board.map((row) => List<Player>.from(row)).toList();

  Player get currentPlayer => _currentPlayer;

  GameResult get gameResult => _gameResult;

  bool get isGameOver => _gameResult != GameResult.playing;

  String get winnerName {
    switch (_gameResult) {
      case GameResult.xWin:
        return "X";

      case GameResult.oWin:
        return "O";

      case GameResult.draw:
        return "Draw";

      default:
        return "";
    }
  }

  List<MoveModel> get moves => List.unmodifiable(_moves);

  //======================
  // Create Board
  //======================

  void initializeBoard([int size = 3]) {
    if (size < 3) {
      throw ArgumentError('Board size must be at least 3');
    }
    _boardSize = size;

    _board = List.generate(
      size,
      (_) => List.generate(size, (_) => Player.none),
    );

    _currentPlayer = Player.x;
    _gameResult = GameResult.playing;
    _moves.clear();
    _gameSaved = false;

    notifyListeners();
  }

  bool _isValidMove(int row, int col) {
    if (isGameOver) return false;

    if (row < 0 || row >= _boardSize) return false;

    if (col < 0 || col >= _boardSize) return false;

    return _board[row][col] == Player.none;
  }

  void _placeMove(int row, int col) {
    _board[row][col] = _currentPlayer;

    _addMoveHistory(row, col);
  }

  void _addMoveHistory(int row, int col) {
    _moves.add(
      MoveModel(
        player: _currentPlayer,
        row: row,
        col: col,
        moveNumber: _moves.length + 1,
      ),
    );
  }

  void _updateGameState() {
    _gameResult = WinnerChecker.check(_board);

    debugPrint("Result = $_gameResult");
    debugPrint("Winner = $winnerName");

    if (_gameResult == GameResult.playing) {
      _currentPlayer = _currentPlayer.opposite;
    } else {
      debugPrint("CALL SAVE");

      _saveGame().catchError((e) {
        debugPrint(e.toString());
      });
    }
  }

  void _executeMove(int row, int col) {
    _placeMove(row, col);

    _updateGameState();
  }

  bool makeMove(int row, int col) {
    if (!_isValidMove(row, col)) {
      return false;
    }

    _executeMove(row, col);

    notifyListeners();

    return true;
  }

  bool makeAiMove(int row, int col) {
    if (!_isValidMove(row, col)) {
      return false;
    }

    _executeMove(row, col);

    notifyListeners();

    return true;
  }

  Future<void> _saveGame() async {
    if (_gameSaved) return;

    try {
      await FirestoreService.instance.saveGame(
        boardSize: _boardSize,
        winner: winnerName,
        moves: _moves,
      );

      _gameSaved = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
