import de.bezier.guido.*;

public final static int ROWS = 8;
public final static int COLS = 8;
private Button[][] buttons;
private ArrayList <Button> safeTiles;

public void setup() {
  size(600, 600);
  Interactive.make(this);
  newGrid();
}

public boolean isInGrid(int x, int y) {
 if (x < ROWS && x >= 0 && y < COLS && y >= 0) {
   return true;
 }
 return false;
}


public void draw() {
  background(0);
}

public void populateMines(int total) {
  if (total <= ROWS * COLS) {
    for (int i = 0; i < total; i++) {
      int tileNo = (int)(Math.random()*safeTiles.size());
      safeTiles.get(tileNo).setMine();
      safeTiles.remove(tileNo);
    }
  }
}



public class Button {
  private float x, y, width, height;
  private int row, col;
  private boolean on, isMine;
  public Button(int r, int c) {
    row = r;
    col = c;
    x = 600/ROWS*r;
    y = 600/COLS*c;
    width = 600/ROWS;
    height = 600/COLS;
    on = false;
    Interactive.add(this);
    safeTiles.add(this);
  }
  public void mousePressed() {
    for (int i = row-1; i <= row+1; i++) {
      for (int j = col-1; j <= col+1; j++) {
        if (isInGrid(i,j)) {
          buttons[i][j].toggle();
        }
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
  }
  public boolean isOn() {
    return on;
  }
  public void toggle() {
    on = !on;
  }
  public void setMine() {
    isMine = true;
  }
}
public void keyPressed() {
  if (key == ' ') {
    newGrid();
  }
}

public void newGrid() {
  background(0);    
  safeTiles = new ArrayList <Button>();
  buttons = new Button[ROWS][COLS];  
  for (int i = 0; i < ROWS; i++) {
    for (int j = 0; j < COLS; j++) {
      buttons[i][j] = new Button(i,j);
    }
  }
  populateMines(16);
}
