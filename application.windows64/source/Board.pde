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
 boolean makeMove(int row, int col, char value){
   if(isValidMove(row, col)){
    boardState[row][col] = value;
    checkForWin();
    availableMoves--;
    return true;
   }
   return false;
 }
 
 void clearBoard(){
   win = empty;
  for(int col = 0; col < 3; col++){
    for(int row = 0; row < 3; row++){
      boardState[row][col] = empty;
    }
  }
  availableMoves = 9;
 }
 
 void printBoard(){
  println(" -------");
  println("  " + boardState[0][0] + " " + boardState[0][1] + " " + boardState[0][2]);
  println("  " + boardState[1][0] + " " + boardState[1][1] + " " + boardState[1][2]);
  println("  " + boardState[2][0] + " " + boardState[2][1] + " " + boardState[2][2]);
  println(" -------");
   
 }
 
 //check for win, loss or tie then display the board
 void update(){
   
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
 
 void show(){
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


 boolean checkForWin(){
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
 boolean isFull(){
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
 
  Board copyBoard(){
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
