import de.bezier.guido.*;
//should try splitting into separate for easy reading
public final static int ROWS = 24;
public final static int COLS = 24;
public final static int MINES = ROWS*COLS/12;
public final static int SCREEN_WIDTH = 800;
public final static int SCREEN_HEIGHT = 800;

private Button[][] buttons;
private ArrayList <Button> safeTiles;

public int flags = 0;
public int gameStatus = 0; //0 is game, 1 is win, -1 is lose
public int lives = 3;
public int opacity = 200;
public int remainingTiles = ROWS*COLS-MINES;
public void setup() {
  size(800, 800); //weird varibles,  note to manually fix final variables (thanks a lot, guido)
  Interactive.make(this);
  background(0); 
  textAlign(CENTER, CENTER);  
  safeTiles = new ArrayList <Button>();
  buttons = new Button[ROWS][COLS];  
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      buttons[i][j] = new Button(i, j);
    }
  }
  newGrid(MINES);
}

public boolean isInGrid(int x, int y) {
  if (x < ROWS && x >= 0 && y < COLS && y >= 0) {
    return true;
  }
  return false;
}


public void draw() {
  background(0);
  
  if (gameStatus == 0) {
    fill(255);
    textSize(SCREEN_HEIGHT/3);
    text(MINES-flags,SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
    fill(255,0,0);
    textSize(SCREEN_HEIGHT/10);
    
    //lives text
    String livesString = "";
    for (int i = 0; i < lives; i++) {
      livesString += '\u2665';
    }
    text(livesString,SCREEN_WIDTH/2,SCREEN_HEIGHT/5);  
    
  } else if (gameStatus == 1) {
    fill(255,255,0);
    textSize(SCREEN_HEIGHT/5);
    text("WIN",SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
    
    fill(255);
    textSize(SCREEN_HEIGHT/10); 
    text("SPACE to Play Again",SCREEN_WIDTH/2,SCREEN_HEIGHT*3/4);     
  } else if (gameStatus == -1) {
    fill(255,0,0);
    textSize(SCREEN_HEIGHT/5);
    text("LOSE",SCREEN_WIDTH/2,SCREEN_HEIGHT/2);
    
    fill(255);
    textSize(SCREEN_HEIGHT/15); 
    text("SPACE to Play Again",SCREEN_WIDTH/2,SCREEN_HEIGHT*3/4);         
  }
}

public class Button {
  private float x, y, width, height;
  private int row, col;
  private boolean on, isMine, isFlagged;
  private int adjMines;
  public Button(int r, int c) {
    row = r;
    col = c;
    y = 1.0*SCREEN_HEIGHT/ROWS*r;
    x = 1.0*SCREEN_WIDTH/COLS*c;
    width = 1.0*SCREEN_WIDTH/COLS;
    height = 1.0*SCREEN_HEIGHT/ROWS;
    on = false;
    adjMines = 0;
    Interactive.add(this);
    safeTiles.add(this);
  }
  public void mousePressed() {
    if (gameStatus == -1 || gameStatus == 1) {
      return;
    }
    
    if (mouseButton == LEFT && !isFlagged && !on) { //revealing only nonflagged off
      toggle(true); //reveal!
      remainingTiles--;
      if (isMine) { //hit a mine
        remainingTiles++;
        isFlagged = true;
        flags++;
        lives--;
        if (lives < 1) { //lose case
          for (int r = 0; r < ROWS; r++) {
            for (int c = 0; c < COLS; c++) {
              Button current = buttons[r][c];
              if (current.hasMine() && !current.isOn()) {
                current.toggle(true);
              }
            }
          }
          gameStatus = -1;
        }
        
      } else if (adjMines < 1) { //hit a blank

        for (int i = row-1; i <= row+1; i++) {
          for (int j = col-1; j <= col+1; j++) {
            if (isInGrid(i, j) && !buttons[i][j].isOn()) {
              buttons[i][j].mousePressed();
            }
          }
        }
      }
      
    } else if (mouseButton == RIGHT && !on) { //flagging only off
      if (isFlagged) {
        isFlagged = false;
        flags--;
      } else if (!isFlagged) {
        isFlagged = true;
        flags++;
      }
    }
    
    if (remainingTiles == 0) {
      gameStatus = 1;
    }
  }
  public void draw() {
    if (on) {
      if (isMine) {
        fill(255, 0, 0,opacity);
      } else {
        fill(150,opacity);
      }
    } else {
      fill(50,opacity);
    }
    stroke(75,opacity);
    
    rect(x, y, width, height);
    
    textSize(SCREEN_HEIGHT/ROWS/2);   
    if (on && !isMine && adjMines != 0) { //text for adj mines
      fill(0);
      text(adjMines, x+width/2, y+height/2);
    } else if (isFlagged) { //text for mines themselves 
      if (on) {
        fill(0);
        text('!',x+width/2,y+height/2);
      } else {
        fill(150);
        text('?', x+width/2, y+height/2);
      }
    }
    
  }
  public boolean isOn() {
    return on;
  }
  public void toggle(boolean status) {
    on = status;
  }
  public void setMine(boolean status) {
    isMine = status;
  }
  public void setAdj(int newAmount) {
    adjMines = newAmount;
  }  
  public void setFlag(boolean status) {
    isFlagged = status;
  }
  public int getAdj() {
    return adjMines;
  }
  public boolean hasMine() {
    return isMine;
  }
  public int getR() {
    return row;
  }
  public int getC() {
    return col;
  }
  public boolean hasFlag() {
    return isFlagged;
  }
}
public void keyPressed() {
  if (key == ' ') {
    newGrid(MINES);
  }
}

public void newGrid(int total) {
  flags = 0;
  lives = 3;
  remainingTiles = ROWS*COLS-MINES;
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      Button target = buttons[i][j];
      target.toggle(false);
      target.setMine(false);
      target.setFlag(false);
      target.setAdj(0);
      if (!safeTiles.contains(target)) {
        safeTiles.add(target);
      }
    }
  }

  if (total <= ROWS * COLS) {
    for (int i = 0; i < total; i++) {
      int tileNo = (int)(Math.random()*safeTiles.size());
      Button target = safeTiles.get(tileNo);

      target.setMine(true); 

      safeTiles.remove(tileNo);
    }
  }

  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      if (buttons[r][c].hasMine()) {
        for (int ar = r-1; ar <= r+1; ar++) {
          for (int ac = c-1; ac <= c+1; ac++) {
            if (isInGrid(ar, ac)) {
              buttons[ar][ac].setAdj(buttons[ar][ac].getAdj()+1);
            }
          }
        }
      }
    }
  }
  gameStatus = 0;
}
