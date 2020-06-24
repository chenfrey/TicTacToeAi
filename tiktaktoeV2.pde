Board board;

void setup(){
  size(800, 800);
  background(0);
  rectMode(CENTER);
  startGame();
  
}

void startGame(){
  board = new Board();
  if(random(1) >= 0.5){
    AIMove();
  }
  
}

void draw(){
  background(0);
  drawBoard();
  boolean moved = waitForMove();
  board.update();
  if(moved && !board.gameOver){
    AIMove();
    moved = false;
  }
}

void keyPressed(){
  if(board.gameOver){
    startGame();
  }
}

void drawBoard(){
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

boolean waitForMove(){
  if(mousePressed && mouseX >= 100 && mouseX <= 700 && mouseY >= 100 && mouseY <= 700){
     float row = -1;
     float col = -1;
     //select the chosen square
     col = (mouseX - 100)/200.0;
     row = (mouseY - 100)/200.0;
     //If move is successfully made return true
     if(board.makeMove(floor(row), floor(col), Board.x)){
       return true;
     }
    }
    return false;
  
}

void AIMove(){
  SubBoard subBoard = new SubBoard(board, null, Board.o, null);
  int[] bestMove = subBoard.getBestMove();
  board.makeMove(bestMove[0], bestMove[1], Board.o);
  
}
