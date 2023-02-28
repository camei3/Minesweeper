import de.bezier.guido.*;

public final static int ROWS = 8;
public final static int COLS = 8;
private Button[][] buttons;
private ArrayList <Button> safeTiles;

public void setup() {
  size(600, 600);
  Interactive.make(this);
  newGrid();
  textAlign(CENTER);
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
      Button target = safeTiles.get(tileNo);
      
      for (int r = target.getR()-1; r <= target.getR()+1; r++) {
        for (int c = target.getC()-1; c <= target.getC()+1; c++) {
          if (isInGrid(r,c)) {
            buttons[r][c].addAdj();
          }
        }       
      }
    //public void countAdjMines() {
    //  adjMines = 0;
    //  if (isMine) {
    //    return;
    //  }
    //  for (int i = row-1; i <= row+1; i++) {
    //    for (int j = col-1; j <= col+1; j++) {
    //      if (isInGrid(i,j) && buttons[i][j].hasMine()) {
    //        adjMines++;
    //      }
    //    }
      
    //  }
    //}      
      target.setMine();
      safeTiles.remove(tileNo);
    }
  }
}



public class Button {
  private float x, y, width, height;
  private int row, col;
  private boolean on, isMine;
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
    toggle();  
    
    if (adjMines == 0) {
      
      for (int i = row-1; i <= row+1; i++) {
        for (int j = col-1; j <= col+1; j++) {
          if (isInGrid(i,j) && !buttons[i][j].isOn()) {
            buttons[i][j].mousePressed();
            System.out.println(i + " " + j);
          }
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
    if (on && adjMines != 0) {
      fill(0);
      text(adjMines, x+300/ROWS,y+300/COLS); 
    }
  }
  public boolean isOn() {
    return on;
  }
  public void toggle() {
    on = true;
  }
  public void setMine() {
    isMine = true;
  }
  public void addAdj() {
    adjMines++;
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
  populateMines(4);
}
