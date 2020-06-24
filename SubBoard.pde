class SubBoard{
  int score = 0;
  int moveCount = 1;
  Board board;
  int[] lastMove;
  ArrayList<SubBoard> children = new ArrayList<SubBoard>();
  SubBoard parent;
  char player;
  int[] winningMove = {-1, -1};
  
  SubBoard(Board b, SubBoard parent, char player, int[] nextMove){
    this.parent = parent;
    this.player = player;
    this.board = b;
    //Make move passed by parent
    if(nextMove != null){
      lastMove = nextMove;
      b.makeMove(nextMove[0], nextMove[1], (char)(nextMove[2]));
    }
    //check if there is a winning move for the player
    //I assume that if there is a winning move either player will do it
    boolean moved = checkForWin(b, player);
    /*
    If the player didn't win Check if there is a counter Move
    I assume that if there is no winning move then the player will always do a counter
    move if it exists
    */
    if(!moved){
      moved = checkForCounter(b, player);
    }
    //If there is no winning or counter move then create a subBoard for every available move
    if(!moved){
    if(b != null){
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
            if (b.isValidMove(row, col)) {
                  int[] move = {row, col, (int)player};
                  moved = true;
                  children.add(new SubBoard(b.copyBoard(), this, getOpponent(player), move));
                  //We need to set the score after the subBoaard is created becasue
                  //The score is determined by the childrens scores
                  score = getScore();
              }
            }
        }
      }
    }
    //if moved is still false then the board is full and no one won therefore the score is 0
    if(!moved){
      score = 0;
    }
    //this prints each of the possible moves to display if the best one was chosen
    if(parent != null){
      if(parent.parent == null){
        println("Score: " + score);
        b.printBoard();
        
      }
    }
  }
  
  //Checks if a wining move exists
  boolean checkForWin(Board b, char player){
    for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if(isWin(b, row, col, player)){
            if(player == Board.o){
              score = 1;
              winningMove[0] = row;
              winningMove[1] = col;
              return true;
            }else if(player == Board.x){
              score = -1;
              return true;
            }
          }
        }
    }
    return false;
  }
  
  boolean checkForCounter(Board b, char player){
    char opponent = getOpponent(player);
    int[] counterMove = {-1, -1, -1};
    for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          if(isWin(b, row, col, opponent)){
            counterMove[0] = row;
            counterMove[1] = col;
            counterMove[2] = player;
          }
        }
    }
    if(counterMove[0] != -1){
      //Create another SubBoard with the counterMove.
      children.add(new SubBoard(b.copyBoard(), this, getOpponent(player), counterMove));
      //When there is a counter move there will only be one child
      //Therefore score will be equal to the childs score.
      score = getScore();
      return true;
    }else{
    return false;
    }
  }
  
  //checks every child's score are return's the move that created the one with the highest score.
  int[] getBestMove(){
    if(winningMove[0] != -1){
      return winningMove;
    }else{
      int[] bestMove = {0};
      Integer bestScore = null;
      
      for(SubBoard child : children){
         if(bestScore == null || child.score > bestScore){
           bestMove = child.lastMove;
           bestScore = child.score;
         }else if(child.score == bestScore){
           float rand = random(1);
           //Adding a bit of randomness so the games aren't too repetetive
           //many moves may lead to a tie or win.
           if(rand >= 0.75){
           bestMove = child.lastMove;
           }
         }
      }
      return bestMove;
    }
  }
  
  void printBestMove(){
    int[] bestMove = getBestMove();
    println("(" + bestMove[0] + ", " + bestMove[1] + ", " + (char)bestMove[2] + ") ");
    
  }
  
  
  //returns the opposing player character
  char getOpponent(char player){
    if(player == Board.o)
      return Board.x;
    else if(player == Board.x)
      return Board.o;
    else
      return Board.empty;
  }
  
  /*
  If it is x's turn it will return the lowest score
  If it is o's turn it will return the highest score
  The result will always be -1, 0 or 1 as each move should lead to a win, loss or tie
  */
  Integer getScore(){
    if(player == Board.o){
      Integer highest = null;
      for(SubBoard child : children){
        if(highest == null || child.score > highest){
          highest = child.score;
        }
      }
      return highest;
    } else if(player == Board.x){
      Integer lowest = null;
      for(SubBoard child : children){
        if(lowest == null || child.score < lowest){
          lowest = child.score;
        }
      }
      return lowest;
    }else{
      return null;
    }
  }
  
  //Creates a copy of the board then makes the given move and checks if the game was won.
  boolean isWin(Board board, int row, int col, char player){
    Board b = board.copyBoard();
    b.makeMove(row, col, player);
    return b.checkForWin();
  }
}
