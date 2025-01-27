import 'dart:async';
import 'dart:io';
import 'dart:math';

class Ship {
  String name;
  int size;
  List<List<int>> positions;
  bool isSunk;

  Ship(this.name, this.size) : positions = [], isSunk = false;

  void addPosition(int x, int y) {
    positions.add([x, y]);
  }

  bool checkHit(int x, int y) {
    for (var pos in positions) {
      if (pos[0] == x && pos[1] == y) {
        pos.add(1); // Mark as hit
        if (positions.every((pos) => pos.length == 3)) {
          isSunk = true;
        }
        return true;
      }
    }
    return false;
  }

  bool isAlive() {
    return !isSunk;
  }
}

class Player {
  String name;
  List<List<String>> board;
  List<Ship> ships;
  bool isBot;

  Player(this.name, int boardSize, {this.isBot = false})
      : board = List.generate(boardSize, (_) => List.filled(boardSize, ' ')),
        ships = [];

  void placeShip(Ship ship, int x, int y, bool isVertical) {
    for (int i = 0; i < ship.size; i++) {
      if (isVertical) {
        ship.addPosition(x + i, y);
        board[x + i][y] = 'S';
      } else {
        ship.addPosition(x, y + i);
        board[x][y + i] = 'S';
      }
    }
    ships.add(ship);
  }

  bool attack(int x, int y) {
    if (board[x][y] == 'S') {
      board[x][y] = 'X';
      for (var ship in ships) {
        if (ship.checkHit(x, y)) {
          if (ship.isSunk) {
            print("${ship.name} потоплен!");
          } else {
            print("Попадание!");
          }
          return true;
        }
      }
    } else if (board[x][y] == ' ') {
      board[x][y] = 'O';
      print("Промах!");
    }
    return false;
  }

  bool allShipsSunk() {
    return ships.every((ship) => ship.isSunk);
  }

  void printBoard(bool showShips) {
    // Вывод нумерации столбцов
    stdout.write('  ');
    for (int i = 0; i < board.length; i++) {
      stdout.write('$i ');
    }
    print('');

    // Вывод поля с нумерацией строк
    for (int i = 0; i < board.length; i++) {
      stdout.write('$i ');
      for (int j = 0; j < board[i].length; j++) {
        if (!showShips && board[i][j] == 'S') {
          stdout.write('  ');
        } else {
          stdout.write('${board[i][j]} ');
        }
      }
      print('');
    }
  }
}

class BattleshipGame {
  Player player1;
  Player player2;
  int boardSize;
  bool isGameOver;

  BattleshipGame(this.boardSize)
      : player1 = Player("Игрок 1", boardSize),
        player2 = Player("Игрок 2", boardSize),
        isGameOver = false;

  Future<void> startGame() async {
    print("Добро пожаловать в Морской бой!");
    print("Выберите режим игры:");
    print("1. Игра против другого игрока");
    print("2. Игра против бота");
    int mode = int.parse(stdin.readLineSync()!);

    if (mode == 2) {
      player2.isBot = true;
    }

    await placeShips(player1);
    await placeShips(player2);

    while (!isGameOver) {
      await makeMove(player1, player2);
      if (isGameOver) break;
      await makeMove(player2, player1);
    }
  }

  Future<void> placeShips(Player player) async {
    print("${player.name}, разместите свои корабли:");
    for (int i = 0; i < 3; i++) {
      int shipSize = 3 - i;
      print("Разместите корабль размером $shipSize:");
      print("Введите координату X:");
      int x = int.parse(stdin.readLineSync()!);
      print("Введите координату Y:");
      int y = int.parse(stdin.readLineSync()!);
      print("Введите ориентацию (v - вертикально, h - горизонтально):");
      bool isVertical = stdin.readLineSync()!.toLowerCase() == 'v';
      player.placeShip(Ship("Корабль $i", shipSize), x, y, isVertical);

      // Отображение поля после размещения корабля
      print("Ваше поле после размещения корабля:");
      player.printBoard(true);
    }
  }

  Future<void> makeMove(Player attacker, Player defender) async {
    print("${attacker.name}, ваш ход:");
    attacker.printBoard(true);
    print("Поле противника:");
    defender.printBoard(false);

    int x, y;
    if (attacker.isBot) {
      x = Random().nextInt(boardSize);
      y = Random().nextInt(boardSize);
    } else {
      print("Введите координату X для атаки:");
      x = int.parse(stdin.readLineSync()!);
      print("Введите координату Y для атаки:");
      y = int.parse(stdin.readLineSync()!);
    }

    defender.attack(x, y);

    if (defender.allShipsSunk()) {
      print("${attacker.name} победил!");
      isGameOver = true;
    }

    print("Нажмите Enter, чтобы передать ход другому игроку...");
    stdin.readLineSync();
    clearConsole();
  }

  void clearConsole() {
    print("\x1B[2J\x1B[0;0H");
  }
}

// Добавление асинхронных вызовов и изолятов
Future<void> savePlayerData(Player player) async {
  final file = File('${player.name}_data.txt');
  if (await file.exists()) {
    // Если файл существует, обновляем данные
    final lines = await file.readAsLines();
    int gamesPlayed = int.parse(lines[1].split(': ')[1]);
    int wins = int.parse(lines[2].split(': ')[1]);
    int losses = int.parse(lines[3].split(': ')[1]);

    gamesPlayed++;
    if (player.allShipsSunk()) {
      losses++;
    } else {
      wins++;
    }

    await file.writeAsString('Имя: ${player.name}\nИгр сыграно: $gamesPlayed\nПобед: $wins\nПоражений: $losses');
  } else {
    // Если файл не существует, создаем новый
    await file.writeAsString('Имя: ${player.name}\nИгр сыграно: 1\nПобед: 0\nПоражений: 0');
  }
}

// Добавление работы с файлами
Future<void> saveGameData(Player player1, Player player2) async {
  final file = File('current_game_data.txt');
  await file.writeAsString('Игрок1: ${player1.name}\nИгрок2: ${player2.name}\n');
}

// Добавление логирования и обработки ошибок
Future<void> logAction(String action) async {
  final file = File('game_log.txt');
  await file.writeAsString('$action\n', mode: FileMode.append);
}

void handleError(String errorMessage) {
  print(errorMessage);
  logAction(errorMessage);
}

void main() async {
  BattleshipGame game = BattleshipGame(10);
  await game.startGame();

  // Сохранение данных игроков после игры
  await savePlayerData(game.player1);
  await savePlayerData(game.player2);

  // Сохранение данных текущей игры
  await saveGameData(game.player1, game.player2);

  // Логирование действий игроков
  await logAction('Игра завершена');

  // Обработка ошибок
  try {
    // Пример ошибки
    throw Exception('Пример ошибки');
  } catch (e) {
    handleError('Ошибка: $e');
  }
}