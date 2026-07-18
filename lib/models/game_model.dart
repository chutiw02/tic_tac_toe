import 'package:cloud_firestore/cloud_firestore.dart';

class GameModel {
  final String id;
  final int boardSize;
  final String winner;
  final int totalMoves;
  final DateTime createdAt;

  const GameModel({
    required this.id,
    required this.boardSize,
    required this.winner,
    required this.totalMoves,
    required this.createdAt,
  });

  factory GameModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return GameModel(
      id: doc.id,

      boardSize: (data['boardSize'] as int?) ?? 3,

      winner: (data['winner'] as String?) ?? 'Draw',

      totalMoves: (data['totalMoves'] as int?) ?? 0,

      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
