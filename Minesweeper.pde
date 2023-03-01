import de.bezier.guido.*;

public final static int ROWS = 16;
public final static int COLS = 16;
public final static int MINES = 12;
private Button[][] buttons;
private ArrayList <Button> safeTiles;
public int flags = 0;
public void setup() {
  size(600, 600);
  Interactive.make(this);
  background(0); 
  textSize(600/ROWS/2);
  textAlign(CENTER,CENTER);  
  safeTiles = new ArrayList <Button>();
  buttons = new Button[ROWS][COLS];  
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      buttons[i][j] = new Button(i,j);
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
  ////stroke(120,20);
  ////strokeWeight(600/3);
  //text(MINES-flags,600/2,600/2);
  background(0);
}

public class Button {
  private float x, y, width, height;
  private int row, col;
  private boolean on, isMine, isFlagged;
  private int adjMines;
  public Button(int r, int c) {
    row = r;
    col = c;
    x = 600/ROWS*r;
    y = 600/COLS*c;
    width = 600/ROWS;
    height = 600/COLS;
    on = false;
    adjMines = 0;
    Interactive.add(this);
    safeTiles.add(this);
  }
  public void mousePressed() {
    if (mouseButton == LEFT && !isFlagged) {
      toggle(true);
      
      if (adjMines < 1) {
        
        for (int i = row-1; i <= row+1; i++) {
          for (int j = col-1; j <= col+1; j++) {
            if (isInGrid(i,j) && !buttons[i][j].isOn()) {
              buttons[i][j].mousePressed();
            }
          }
        }
        
      }
    } else if (mouseButton == RIGHT) {
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
        fill(255,0,0);
      } else {
        fill(255);           
      }
    } else {
      fill(50);
    }
    rect(x, y, width, height);
    if (on && !isMine && adjMines != 0) {
      fill(0);
      text(adjMines, x+300/ROWS,y+300/COLS); 
    } else if (isFlagged) {
      fill(255);
      text('?', x+300/ROWS, y+300/COLS);
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
            if (isInGrid(ar,ac)) {
              buttons[ar][ac].setAdj(buttons[ar][ac].getAdj()+1);
            }
          }
        }
      }
    }
  }
}
