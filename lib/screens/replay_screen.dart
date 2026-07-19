import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../models/move_model.dart';
import '../services/firestore_service.dart';
import '../utils/player.dart';

class ReplayScreen extends StatefulWidget {
  final GameModel game;

  const ReplayScreen({super.key, required this.game});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  late List<List<Player>> board;

  List<MoveModel> moves = [];

  int currentMove = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    _initializeBoard();

    _loadMoves();
  }

  void _initializeBoard() {
    board = List.generate(
      widget.game.boardSize,
      (_) => List.generate(widget.game.boardSize, (_) => Player.none),
    );
  }

  Future<void> _loadMoves() async {
    moves = await FirestoreService.instance.getMoves(widget.game.id);

    _startReplay();
  }

  void _startReplay() {
    timer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (currentMove >= moves.length) {
        timer.cancel();

        return;
      }

      final move = moves[currentMove];

      setState(() {
        board[move.row][move.col] = move.player;

        currentMove++;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Replay")),

      body: Center(
        child: AspectRatio(
          aspectRatio: 1,

          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.game.boardSize,
            ),

            itemCount: widget.game.boardSize * widget.game.boardSize,

            itemBuilder: (context, index) {
              final row = index ~/ widget.game.boardSize;

              final col = index % widget.game.boardSize;

              return Container(
                margin: const EdgeInsets.all(2),

                decoration: BoxDecoration(border: Border.all()),

                child: Center(
                  child: Text(
                    board[row][col].symbol,

                    style: const TextStyle(
                      fontSize: 32,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
