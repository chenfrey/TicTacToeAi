//Note: The NPC assumes it is playing a flawless character therefor it does not weight moves that could lead to a mistake any higher than moves that lead to a tie.
//This is something that could be improved in the future
class Gamestate{
  private int score = 0;
  //a move contains [row, col, player]
  int[] lastMove;
  ArrayList<Gamestate> children = new ArrayList<Gamestate>();
  int[] winningMove = {-1, -1};
  
  Gamestate(Board b, char player, int[] nextMove){
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
    //If there is no winning or counter move then create a Gamestate for every available move
    if(!moved){
    if(b != null){
      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
            if (b.isValidMove(row, col)) {
                  int[] move = {row, col, (int)player};
                  moved = true;
                  children.add(new Gamestate(b.copyBoard(), getOpponent(player), move));
                  //We need to set the score after the subBoaard is created becasue
                  //The score is determined by the childrens scores
                  score = getScoreFromChildren(player);
              }
            }
        }
      }
    }
    //if moved is still false then the board is full and no one won therefore the score is 0
    if(!moved){
      score = 0;
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
      //Create another Gamestate with the counterMove.
      children.add(new Gamestate(b.copyBoard(), getOpponent(player), counterMove));
      //When there is a counter move there will only be one child
      //Therefore score will be equal to the childs score.
      score = children.get(0).getScore();
      return true;
    }else{
    return false;
    }
  }
  
  //checks every child's score are return's the move that created the one with the highest score.
  int[] getBestMove(){
    //using an int set to 0 rather than an Integer because an Integer cannot be cast to a char
    if(winningMove[0] != -1){
      return winningMove;
    }
    else{
     int[] bestMove = {0};
     Integer bestScore = null;
     
     for(Gamestate child : children){
        if(bestScore == null || child.getScore() > bestScore){
          bestMove = child.lastMove;
          bestScore = child.getScore();
        }else if(child.getScore() == bestScore){
          bestMove = child.lastMove;        
       }
     }
     return bestMove;
   }
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
  The result will always be -1, 0 or 1 as each move should lead to a loss, tie or win
  */
  Integer getScoreFromChildren(char player){
    if(player == Board.o){
      Integer highest = null;
      for(Gamestate child : children){
        if(highest == null || child.getScore() > highest){
          highest = child.getScore();
        }
      }
      return highest;
    } else if(player == Board.x){
      Integer lowest = null;
      for(Gamestate child : children){
        if(lowest == null || child.getScore() < lowest){
          lowest = child.getScore();
        }
      }
      return lowest;
    }else{
      return null;
    }
  }
  
  //Creates a copy of the board then makes the given move and checks if the player has won.
  boolean isWin(Board board, int row, int col, char player){
    Board b = board.copyBoard();
    b.makeMove(row, col, player);
    return b.checkForWin();
  }
  
  
  //getter's aren't necessary because the parent can access the child's private variables
  //This is just for clarity
  Integer getScore(){
    return score;
  }
  
}
