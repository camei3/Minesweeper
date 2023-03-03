import de.bezier.guido.*;

public final static int ROWS = 12;
public final static int COLS = 12;
public final static int MINES = ROWS*COLS/12;
public final static int SCREEN_WIDTH = 600;
public final static int SCREEN_HEIGHT = 600;

private Button[][] buttons;
private ArrayList <Button> safeTiles;

public int flags = 0;
public int gameStatus = 0;

public void setup() {
  size(600, 600); //weird varibles,  note to manually fix final variables (thanks a lot, guido)
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
  stroke(255);
  textSize(600/3);
  text(MINES-flags,600/2,600/2);
}

public class Button {
  private float x, y, width, height;
  private int row, col;
  private boolean on, isMine, isFlagged;
  private int adjMines;
  public Button(int r, int c) {
    row = r;
    col = c;
    y = SCREEN_HEIGHT/ROWS*r;
    x = SCREEN_WIDTH/COLS*c;
    width = SCREEN_WIDTH/COLS;
    height = SCREEN_HEIGHT/ROWS;
    on = false;
    adjMines = 0;
    Interactive.add(this);
    safeTiles.add(this);
  }
  public void mousePressed() {
    if (mouseButton == LEFT && !isFlagged && !on) {
      toggle(true);

      if (adjMines < 1) {

        for (int i = row-1; i <= row+1; i++) {
          for (int j = col-1; j <= col+1; j++) {
            if (isInGrid(i, j) && !buttons[i][j].isOn()) {
              buttons[i][j].mousePressed();
            }
          }
        }
      }
    } else if (mouseButton == RIGHT && !on) {
      if (isFlagged) {
        isFlagged = false;
        flags--;
      } else if (!isFlagged) {
        isFlagged = true;
        flags++;
      }
    }
  }
  public void draw() {
    if (on) {
      if (isMine) {
        fill(200, 0, 0,200);
      } else {
        fill(125,200);
      }
    } else {
      fill(50,200);
    }
    stroke(75,200);
    strokeWeight(1);
    rect(x, y, width, height);
    
    textSize(SCREEN_HEIGHT/ROWS/2);    
    if (on && !isMine && adjMines != 0) {
      fill(0);
      text(adjMines, x+width/2, y+height/2);
    } else if (isFlagged) {
      fill(125);
      text('?', x+width/2, y+height/2);
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
