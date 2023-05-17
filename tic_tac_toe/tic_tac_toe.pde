import java.util.ArrayList;
import java.util.List;

int boardSize = 3;
int cellSize;
char[][] board;
char currentPlayer = 'X';
char aiPlayer = 'O';
int difficulty = 1;
boolean isHumanVsHuman = false;
boolean gameOver = false;

void setup() {
  fullScreen();
  cellSize = min(width, height) / boardSize;
  board = new char[boardSize][boardSize];
  clearBoard();
}

void draw() {
  background(255);
  drawBoard();

  char winner = checkWinner();
  boolean isDraw = isDraw();

  if (winner != ' ') {
    displayMessage("Player " + winner + " wins!");
    gameOver = true;
  } else if (isDraw) {
    displayMessage("It's a draw!");
    gameOver = true;
  } else {
    if (currentPlayer == aiPlayer && !gameOver) {
      makeAIMove();
    } else {
      if (isHumanVsHuman) {
        displayMessage("Player " + currentPlayer + "'s turn");
      } else {
        displayMessage("Your turn (" + currentPlayer + ")");
      }
    }
  }

  displayDifficultyLevel();
  displayResetButton();
}

void mouseClicked() {
  if (isHumanVsHuman || (currentPlayer != aiPlayer && !gameOver)) {
    int row = mouseY / cellSize;
    int col = mouseX / cellSize;

    if (row >= 0 && row < boardSize && col >= 0 && col < boardSize && board[row][col] == ' ') {
      board[row][col] = currentPlayer;
      currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
    }
  }

  if (mouseX >= width - 100 && mouseX <= width && mouseY >= height - 50 && mouseY <= height) {
    resetGame();
  }
}

void keyPressed() {
  if (key == '1' || key == '2' || key == '3') {
    difficulty = key - '0';
    resetGame();
  }

  if (key == 'h' || key == 'H') {
    isHumanVsHuman = !isHumanVsHuman;
    resetGame();
  }
}

void drawBoard() {
  stroke(0);
  strokeWeight(2);
  
  for (int i = 1; i < boardSize; i++) {
    line(0, i * cellSize, width, i * cellSize);
    line(i * cellSize, 0, i * cellSize, height);
  }

  textSize(cellSize * 0.75);
  textAlign(CENTER, CENTER);
  
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      float x = (j + 0.5) * cellSize;
      float y = (i + 0.5) * cellSize;
      char mark = board[i][j];
      
      if (mark == 'X') {
        line(x - cellSize / 4, y - cellSize / 4, x + cellSize / 4, y + cellSize / 4);
        line(x - cellSize / 4, y + cellSize / 4, x + cellSize / 4, y - cellSize / 4);
      } else if (mark == 'O') {
        ellipse(x, y, cellSize / 2, cellSize / 2);
      }
    }
  }
}

void clearBoard() {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      board[i][j] = ' ';
    }
  }
}

char checkWinner() {
  for (int i = 0; i < boardSize; i++) {
    if (board[i][0] != ' ' && board[i][0] == board[i][1] && board[i][0] == board[i][2]) {
      return board[i][0];
    }
  }

  for (int i = 0; i < boardSize; i++) {
    if (board[0][i] != ' ' && board[0][i] == board[1][i] && board[0][i] == board[2][i]) {
      return board[0][i];
    }
  }

  if (board[0][0] != ' ' && board[0][0] == board[1][1] && board[0][0] == board[2][2]) {
    return board[0][0];
  }

  if (board[0][2] != ' ' && board[0][2] == board[1][1] && board[0][2] == board[2][0]) {
    return board[0][2];
  }

  return ' ';
}

boolean isDraw() {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      if (board[i][j] == ' ') {
        return false;
      }
    }
  }
  return true;
}

void displayMessage(String message) {
  textSize(32);
  textAlign(CENTER, CENTER);
  fill(0);
  text(message, width / 2, height / 2);
}

void displayResetButton() {
  rectMode(CORNER);
  fill(200);
  rect(width - 100, height - 50, 100, 50);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Reset", width - 50, height - 25);
}

void displayDifficultyLevel() {
  textSize(16);
  textAlign(RIGHT, CENTER);
  fill(0);
  String difficultyText;
  
  switch (difficulty) {
    case 1:
      difficultyText = "Easy";
      break;
    case 2:
      difficultyText = "Medium";
      break;
    case 3:
      difficultyText = "Impossible";
      break;
    default:
      difficultyText = "Unknown";
  }
  
  text("Difficulty: " + difficultyText, width - 20, 20);
}

void resetGame() {
  clearBoard();
  currentPlayer = 'X';
  gameOver = false;
}

void makeAIMove() {
  Move bestMove = minimax(board, 0, aiPlayer);
  
  if (bestMove.row != -1 && bestMove.col != -1) {
    board[bestMove.row][bestMove.col] = aiPlayer;
    currentPlayer = 'X';
  }
}

class Move {
  int row;
  int col;
  int score;
  
  Move(int row, int col, int score) {
    this.row = row;
    this.col = col;
    this.score = score;
  }
}

Move minimax(char[][] currentBoard, int depth, char player) {
  char winner = checkWinner();
  
  if (winner == aiPlayer) {
    return new Move(-1, -1, 10 - depth);
  } else if (winner == currentPlayer) {
    return new Move(-1, -1, depth - 10);
  } else if (isDraw()) {
    return new Move(-1, -1, 0);
  }
  
  Move bestMove = new Move(-1, -1, (player == aiPlayer) ? Integer.MIN_VALUE : Integer.MAX_VALUE);
  
  List<Move> availableMoves = new ArrayList<>();
  
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      if (currentBoard[i][j] == ' ') {
        currentBoard[i][j] = player;
        Move move = minimax(currentBoard, depth + 1, (player == 'X') ? 'O' : 'X');
        currentBoard[i][j] = ' ';
        
        if ((player == aiPlayer && move.score > bestMove.score) ||
            (player == currentPlayer && move.score < bestMove.score)) {
          bestMove.row = i;
          bestMove.col = j;
          bestMove.score = move.score;
        }
        
        availableMoves.add(move);
      }
    }
  }
  
  if (availableMoves.isEmpty()) {
    return new Move(-1, -1, 0);
  }
  
  if (depth == 0) {
    bestMove = availableMoves.get((int) random(availableMoves.size()));
  }
  
  return bestMove;
}
