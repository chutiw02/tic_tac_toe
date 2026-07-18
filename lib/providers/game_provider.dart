import 'package:flutter/material.dart';
import '../models/move_model.dart';
import '../utils/player.dart';
import '../utils/winner_checker.dart';
import '../utils/game_result.dart';

class GameProvider extends ChangeNotifier {
  int _boardSize = 3;

  List<List<Player>> _board = [];

  Player _currentPlayer = Player.x;

  GameResult _gameResult = GameResult.playing;

  final List<MoveModel> _moves = [];

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

    Player get winner {
      switch (_gameResult) {
        case GameResult.xWin:
          return Player.x;

        case GameResult.oWin:
          return Player.o;

        default:
          return Player.none;
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

    if (_gameResult == GameResult.playing) {
      _currentPlayer = _currentPlayer.opposite;
    }
  }

  bool makeMove(int row, int col) {

    if (!_isValidMove(row, col)) {
      return false;
    }

    _placeMove(row, col);

    _updateGameState();

    notifyListeners();

    return true;
  }
}