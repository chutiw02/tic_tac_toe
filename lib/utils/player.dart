enum Player { x, o, none }

extension PlayerExtension on Player {
  String get symbol {
    switch (this) {
      case Player.x:
        return 'X';
      case Player.o:
        return 'O';
      case Player.none:
        return '';
    }
  }

  Player get opposite {
    switch (this) {
      case Player.x:
        return Player.o;
      case Player.o:
        return Player.x;
      case Player.none:
        return Player.none;
    }
  }

  bool get isEmpty => this == Player.none;

  bool get isNotEmpty => this != Player.none;
}
