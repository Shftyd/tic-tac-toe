// Global Variables
float line1X, line1Y;
float line2X, line2Y;
float line3X, line3Y;
float line4X, line4Y;

// Tic-Tac-Toe Variables
int boardSize = 3;
int[][] board;
int currentPlayer;
int winner;
int cellSize;

boolean easyMode = false; // Set easy mode to false by default

void setup() {
  fullScreen();
  line1X = 0;
  line1Y = displayHeight * 1 / 3;
  
  line2X = 0;
  line2Y = displayHeight * 2 / 3;
  
  line3X = displayWidth * 1 / 3;
  line3Y = 0;
  
  line4X = displayWidth * 2 / 3;
  line4Y = 0;
  
  cellSize = min(displayWidth, displayHeight) / boardSize;
  
  board = new int[boardSize][boardSize];
  currentPlayer = 1;
  
  noLoop(); // Pause the drawing until the game starts
}

void draw() {
  background(255);
  drawBoard();
  
  if (winner != 0) {
    drawResult();
  }
}

void keyPressed() {
  if (winner != 0) {
    // Restart the game if a key is pressed after the game is over
    resetGame();
    redraw();
    aiKeyPressed();
  }
}

void mousePressed() {
  if (winner != 0) {
    return; // Ignore mouse clicks after the game is over
  }
  
  int row = int(mouseY / line1Y);
  int col = int(mouseX / line3X);
  
  if (isValidMove(row, col)) {
    board[row][col] = currentPlayer;
    currentPlayer *= -1; // Switch to the other player
    
    winner = checkWinner();
    
    redraw();
aiMousePressed();
  }
}

void resetGame() {
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      board[i][j] = 0;
    }
  }
  
  currentPlayer = 1;
  winner = 0;
}

void drawBoard() {
  stroke(0);
  strokeWeight(3);
  
  // Draw horizontal lines
  line(0, line1Y, displayWidth, line1Y);
  line(0, line2Y, displayWidth, line2Y);
  
  // Draw vertical lines
  line(line3X, 0, line3X, displayHeight);
  line(line4X, 0, line4X, displayHeight);
  
  // Draw X and O symbols
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      float x = line3X * j + line3X / 2;
      float y = line1Y * i + line1Y / 2;
      float symbolSize = min(line1Y, line3X) * 0.8;
      
      if (board[i][j] == 1) {
        drawX(x, y, symbolSize);
      } else if (board[i][j] == -1) {
        drawO(x, y, symbolSize);
      }
    }
  }
}

void drawX(float x, float y, float size) {
  float offset = size / 2;
  line(x - offset, y - offset, x + offset, y + offset);
  line(x + offset, y - offset, x - offset, y + offset);
}

void drawO(float x, float y, float size) {
  noFill(); // Remove the fill color
  stroke(0); // Set the stroke color to black
  strokeWeight(3); // Set the stroke weight to 3
  
  ellipse(x, y, size, size);
}


int checkWinner() {
  // Check rows
  for (int i = 0; i < boardSize; i++) {
    if (board[i][0] != 0 && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
      return board[i][0];
    }
  }
  
  // Check columns
  for (int j = 0; j < boardSize; j++) {
    if (board[0][j] != 0 && board[0][j] == board[1][j] && board[1][j] == board[2][j]) {
      return board[0][j];
    }
  }
  
  // Check diagonals
  if (board[0][0] != 0 && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    return board[0][0];
  }
  if (board[0][2] != 0 && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
    return board[0][2];
  }
  
  // Check for a draw
  boolean isDraw = true;
  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      if (board[i][j] == 0) {
        isDraw = false;
        break;
      }
    }
    if (!isDraw) {
      break;
    }
  }
  if (isDraw) {
    return 2; // Draw
  }
  
  // No winner yet
  return 0;
}

void drawResult() {
  textSize(48);
  textAlign(CENTER, CENTER);

  if (winner == 2) {
    fill(0);
    text("It's a draw!", displayWidth / 2, displayHeight / 2);
  } else {
    String result = (winner == 1) ? "Player X wins!" : "Player O wins!";
    fill(0);
    text(result, displayWidth / 2, displayHeight / 2);
  }
}

boolean isValidMove(int row, int col) {
  if (row >= 0 && row < boardSize && col >= 0 && col < boardSize && board[row][col] == 0) {
    return true;
  }
  return false;
}

void makeAIMove() {
  if (easyMode) {
    // Find an empty cell randomly and make a move
    boolean madeMove = false;
    while (!madeMove) {
      int row = int(random(boardSize));
      int col = int(random(boardSize));
      if (isValidMove(row, col)) {
        board[row][col] = currentPlayer;
        currentPlayer *= -1;
        madeMove = true;
      }
    }
  } else if (mediumMode) {
    // ...
  } else if (impossibleMode) {
    int[] bestMove = findBestMove();
    if (bestMove != null) {
      int row = bestMove[0];
      int col = bestMove[1];
      board[row][col] = currentPlayer;
      currentPlayer *= -1;
    }
  } else {
    // No mode specified, make a random move
    makeRandomMove();
  }
}

void makeRandomMove() {
  // Find an empty cell randomly and make a move
  boolean madeMove = false;
  while (!madeMove) {
    int row = int(random(boardSize));
    int col = int(random(boardSize));
    if (isValidMove(row, col)) {
      board[row][col] = currentPlayer;
      currentPlayer *= -1;
      madeMove = true;
    }
  }
}

int evaluate() {
  // Evaluate the current state of the board
  int winner = checkWinner();
  if (winner == 1) {
    return 1; // AI wins
  } else if (winner == -1) {
    return -1; // Human wins
  } else {
    return 0; // Draw
  }
}

int[] findBestMove() {
  int bestScore = Integer.MIN_VALUE;
  int[] bestMove = null;

  for (int i = 0; i < boardSize; i++) {
    for (int j = 0; j < boardSize; j++) {
      if (isValidMove(i, j)) {
        board[i][j] = currentPlayer;
        int score = minimax(0, false);
        board[i][j] = 0; // Undo the move

        if (score > bestScore) {
          bestScore = score;
          bestMove = new int[]{i, j};
        }
      }
    }
  }

  return bestMove;
}

int minimax(int depth, boolean isMaximizing) {
  int score = evaluate();

  if (score == 1 || score == -1 || score == 0) {
    return score;
  }

  if (isMaximizing) {
    int bestScore = Integer.MIN_VALUE;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (isValidMove(i, j)) {
          board[i][j] = currentPlayer;
          int currentScore = minimax(depth + 1, false);
          board[i][j] = 0; // Undo the move
          bestScore = max(bestScore, currentScore);
        }
      }
    }
    return bestScore;
  } else {
    int bestScore = Integer.MAX_VALUE;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (isValidMove(i, j)) {
          board[i][j] = currentPlayer;
          int currentScore = minimax(depth + 1, true);
          board[i][j] = 0; // Undo the move
          bestScore = min(bestScore, currentScore);
        }
      }
    }
    return bestScore;
  }
}
