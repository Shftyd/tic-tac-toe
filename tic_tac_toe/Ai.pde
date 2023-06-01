void aiMousePressed() {
  if (winner != 0) {
    return; // Ignore mouse clicks after the game is over
  }

  if (!easyMode || currentPlayer == 1) {
    // Human player's turn or not in easy mode
    int row = int(mouseY / line1Y);
    int col = int(mouseX / line3X);

    if (isValidMove(row, col)) {
      board[row][col] = currentPlayer;
      currentPlayer *= -1; // Switch to the other player

      winner = checkWinner();

      redraw();
    }
  }

  if (currentPlayer == -1 && !easyMode && !mediumMode && !impossibleMode && winner == 0) {
    // AI's turn and not in easy, medium, or impossible mode
    makeAIMove();
    winner = checkWinner();
    redraw();
  }
}

void aiKeyPressed() {
  if (winner != 0) {
    // Restart the game if a key is pressed after the game is over
    resetGame();
    redraw();
  } else if (key == 'e' || key == 'E') {
    // Toggle easy mode
    easyMode = !easyMode;
    if (easyMode) {
      println("Easy mode activated");
      mediumMode = false; // Deactivate medium mode
      println("Medium mode deactivated");
      impossibleMode = false; // Deactivate impossible mode
      println("Impossible mode deactivated");
    } else {
      println("Easy mode deactivated");
    }
  } else if (key == 'm' || key == 'M') {
    // Toggle medium mode
    mediumMode = !mediumMode;
    if (mediumMode) {
      println("Medium mode activated");
      easyMode = false; // Deactivate easy mode
      println("Easy mode deactivated");
      impossibleMode = false; // Deactivate impossible mode
      println("Impossible mode deactivated");
    } else {
      println("Medium mode deactivated");
    }
  } else if (key == 'i' || key == 'I') {
    // Toggle impossible mode
    impossibleMode = !impossibleMode;
    if (impossibleMode) {
      println("Impossible mode activated");
      easyMode = false; // Deactivate easy mode
      println("Easy mode deactivated");
      mediumMode = false; // Deactivate medium mode
      println("Medium mode deactivated");
    } else {
      println("Impossible mode deactivated");
    }
  }
}
