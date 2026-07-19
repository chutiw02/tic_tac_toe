import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game_model.dart';
import '../models/move_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveGame({
    required int boardSize,
    required String winner,
    required List<MoveModel> moves,
  }) async {
    final gameRef = await _firestore.collection('game').add({
      'boardSize': boardSize,
      'winner': winner,
      'totalMoves': moves.length,
      'createdAt': Timestamp.now(),
    });

    final batch = _firestore.batch();

    for (final move in moves) {
      final moveRef = gameRef.collection('moves').doc();

      batch.set(moveRef, move.toMap());
    }
    await batch.commit();
  }

  Stream<List<GameModel>> getGames() {
    return _firestore
        .collection('games')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(GameModel.fromFirestore).toList());
  }

  Future<List<MoveModel>> getMoves(String gameId) async {
    final snapshot = await _firestore
        .collection('games')
        .doc(gameId)
        .collection('moves')
        .orderBy('moveNumber')
        .get();
    return snapshot.docs.map((doc) => MoveModel.fromMap(doc.data())).toList();
  }
}
