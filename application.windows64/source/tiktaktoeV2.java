import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class tiktaktoeV2 extends PApplet {

Board board;

public void setup(){
  
  background(0);
  rectMode(CENTER);
  startGame();
  
}

public void startGame(){
  board = new Board();
  //flip a coin on who starts
  if(random(1) >= 0.5f){
    AIMove();
  }
  
}

public void draw(){
  background(0);
  drawBoard();
  boolean moved = waitForPlayerMove();
  board.update();
  if(moved && !board.gameOver){
    AIMove();
    moved = false;
  }
}

public void keyPressed(){
  if(board.gameOver){
    startGame();
  }
}

public void drawBoard(){
  noStroke();
  fill(255);
  //top
  rect(400, 300, 600, 10);
  //bottom
  rect(400, 500, 600, 10);
  //left
  rect(300, 400, 10, 600);
  //right
  rect(500, 400, 10, 600);
  
}

public boolean waitForPlayerMove(){
  if(mousePressed && mouseX >= 100 && mouseX <= 700 && mouseY >= 100 && mouseY <= 700){
     float row = -1;
     float col = -1;
     //select the chosen square
     col = (mouseX - 100)/200.0f;
     row = (mouseY - 100)/200.0f;
     //If move is successfully made return true (check that player made a valid move)
     if(board.makeMove(floor(row), floor(col), Board.x)){
       return true;
     }
    }
    return false;
  
}

public void AIMove(){
  Gamestate gamestate = new Gamestate(board, Board.o, null);
  int[] bestMove = gamestate.getBestMove();
  board.makeMove(bestMove[0], bestMove[1], Board.o);
  
}
class Board{
 char boardState[][] = new char[3][3];
 final static char x = 'x';
 final static char o = 'o';
 final static char empty = '/';
 char win = empty;
 int availableMoves;
 boolean gameOver;
 
 
 Board(){
  clearBoard();
 }
 
 //add's the player's character to the given row and columb
 public boolean makeMove(int row, int col, char value){
   if(isValidMove(row, col)){
    boardState[row][col] = value;
    checkForWin();
    availableMoves--;
    return true;
   }
   return false;
 }
 
 public void clearBoard(){
   win = empty;
  for(int col = 0; col < 3; col++){
    for(int row = 0; row < 3; row++){
      boardState[row][col] = empty;
    }
  }
  availableMoves = 9;
 }
 
 public void printBoard(){
  println(" -------");
  println("  " + boardState[0][0] + " " + boardState[0][1] + " " + boardState[0][2]);
  println("  " + boardState[1][0] + " " + boardState[1][1] + " " + boardState[1][2]);
  println("  " + boardState[2][0] + " " + boardState[2][1] + " " + boardState[2][2]);
  println(" -------");
   
 }
 
 //check for win, loss or tie then display the board
 public void update(){
   
   if(win == x){
     text("Player x wins!!!", 300, 30);
     gameOver = true;
   }
   else if(win == o){
     text("Player o wins!!!", 300, 30);
     gameOver = true;
   }
   else if(availableMoves <= 0){
     text("TIE!!!", 360, 30);
     gameOver = true;
   }
   if(gameOver){
     text("Press Any Key To Restart", 210, 80);
   }
  show();
 }
 
 public void show(){
   for(int col = 0; col < 3; col++){
    for(int row = 0; row < 3; row++){
      if(boardState[row][col] == x){
       noStroke();
       fill(255);
       pushMatrix();
       translate(200 + col*200, 200 + row*200);
       //Rotate right 45 degrees and draw a straight rect
       rotate(PI/4);
       rect(0, 0, 10, 150);
       //Rotate left 90 degrees (to -45 degrees) and draw a straight rect
       rotate(-PI/2);
       rect(0, 0, 10, 150);
       popMatrix();
       
      }
      else if(boardState[row][col] == o){
       fill(0);
       strokeWeight(13);
       stroke(255);
       ellipse(200 + col*200, 200 + row*200, 130, 130);
      }
    }
   }
   
   stroke(255);
   textSize(30);
   
 }


 public boolean checkForWin(){
   char winner = empty;
   //Check all possible horrizontal and vertical lines
   for(int i = 0; i < 3; i++){
     if(boardState[0][i] == boardState[1][i] && boardState[1][i] == boardState[2][i] && boardState[0][i] != empty){
       winner = boardState[0][i];
     }
     else if(boardState[i][0] == boardState[i][1] && boardState[i][1] == boardState[i][2] && boardState[i][0] != empty){
       winner = boardState[i][0]; 
     }
   }
   //Check diagonals
   if(boardState[0][0] == boardState[1][1] && boardState[1][1] == boardState[2][2] && boardState[0][0] != empty){
     winner = boardState[0][0];
   }
   else if(boardState[2][0] == boardState[1][1] && boardState[1][1] == boardState[0][2] && boardState[2][0] != empty){
     winner = boardState[2][0];
   }
   win = winner;
   if(win != empty){
     return true;
   }else{
     return false;
   }
 }
 
 //Check if board is full
 public boolean isFull(){
   if(availableMoves <= 0){
     return true;
    }else{
      return false; 
    }
 }
 
 //Checks if the position is already taken
 public boolean isValidMove(int row, int col){
   if(row >= 0 && row <= 2 && col >= 0 && col <= 2 && gameOver == false){
    if(boardState[row][col] == empty){
      return true;
    }
   }
   return false;
 }
 
  public Board copyBoard(){
   Board b = new Board();
   b.boardState = new char[3][3];
   for(int row = 0; row < 3; row++){
     for(int col = 0; col < 3; col++){
       b.boardState[row][col] = this.boardState[row][col];
     }
   }
   b.availableMoves = this.availableMoves;
   return b;
   
 }
  
}
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
  public boolean checkForWin(Board b, char player){
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
  
  public boolean checkForCounter(Board b, char player){
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
  public int[] getBestMove(){
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
  public char getOpponent(char player){
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
  public Integer getScoreFromChildren(char player){
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
  public boolean isWin(Board board, int row, int col, char player){
    Board b = board.copyBoard();
    b.makeMove(row, col, player);
    return b.checkForWin();
  }
  
  
  //getter's aren't necessary because the parent can access the child's private variables
  //This is just for clarity
  public Integer getScore(){
    return score;
  }
  
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "tiktaktoeV2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
