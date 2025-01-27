import 'dart:io';
import 'dart:math';

void main() {
  while (true) {
    print('Выберите режим игры:');
    print('1. Игра друг против друга');
    print('2. Игра против робота');
    int mode = int.parse(stdin.readLineSync()!);

    if (mode == 1 || mode == 2) {
      playGame(mode);
    } else {
      print('Неверный выбор режима.');
    }

    print('Хотите сыграть еще раз? (1 - да/2 - нет)');
    String answer = stdin.readLineSync()!.toLowerCase();
    if (answer != '1') {
      break;
    }
  }
}

void playGame(int mode) {
  int size = getBoardSize();
  List<List<String>> board = List.generate(size, (_) => List.filled(size, ' '));
  String currentPlayer = chooseFirstPlayer();
  bool gameOver = false;

  while (!gameOver) {
    printBoard(board);
    print('Ход игрока $currentPlayer');

    int row, col;
    if (mode == 2 && currentPlayer == 'O') {
      // Ход робота
      var move = getRobotMove(board);
      row = move['row']!;
      col = move['col']!;
    } else {
      // Ход игрока
      var move = getPlayerMove(board);
      row = move['row']!;
      col = move['col']!;
    }

    board[row][col] = currentPlayer;

    if (checkWin(board, currentPlayer)) {
      printBoard(board);
      print('Игрок $currentPlayer победил!');
      gameOver = true;
    } else if (checkDraw(board)) {
      printBoard(board);
      print('Ничья!');
      gameOver = true;
    } else {
      currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
    }
  }
}
 
int getBoardSize() {
  print('Введите размер игрового поля (например, 3 для 3x3):');
  return int.parse(stdin.readLineSync()!);
}

String chooseFirstPlayer() {
  Random random = Random();
  return random.nextBool() ? 'X' : 'O';
}

void printBoard(List<List<String>> board) {
  for (var row in board) {
    print(row.join(' | '));
    print('---------');
  }
}

Map<String, int> getPlayerMove(List<List<String>> board) {
  while (true) {
    print('Введите строку и столбец (например, 1 2):');
    List<String> input = stdin.readLineSync()!.split(' ');
    int row = int.parse(input[0]) - 1;
    int col = int.parse(input[1]) - 1;

    if (row >= 0 && row < board.length && col >= 0 && col < board.length && board[row][col] == ' ') {
      return {'row': row, 'col': col};
    } else {
      print('Неверный ход, попробуйте снова.');
    }
  }
}

Map<String, int> getRobotMove(List<List<String>> board) {
  Random random = Random();
  while (true) {
    int row = random.nextInt(board.length);
    int col = random.nextInt(board.length);
    if (board[row][col] == ' ') {
      return {'row': row, 'col': col};
    }
  }
}

bool checkWin(List<List<String>> board, String player) {
  int size = board.length;

  // Проверка строк и столбцов
  for (int i = 0; i < size; i++) {
    bool rowWin = true;
    bool colWin = true;
    for (int j = 0; j < size; j++) {
      if (board[i][j] != player) rowWin = false;
      if (board[j][i] != player) colWin = false;
    }
    if (rowWin || colWin) return true;
  }

  // Проверка диагоналей
  bool mainDiagonalWin = true;
  bool antiDiagonalWin = true;
  for (int i = 0; i < size; i++) {
    if (board[i][i] != player) mainDiagonalWin = false;
    if (board[i][size - i - 1] != player) antiDiagonalWin = false;
  }
  if (mainDiagonalWin || antiDiagonalWin) return true;

  return false;
}

bool checkDraw(List<List<String>> board) {
  for (var row in board) {
    if (row.contains(' ')) return false;
  }
  return true;
}