import de.bezier.guido.*;

public class Button {
  private float myX, myY, myH, myW;
  private boolean amOn;
  public Button(float x, float y, float h, float w) {
    myX = x;
    myY = y;
    myH = h;
    myW = w;
    amOn = false;
    Interactive.add(this);
  }
  public void mousePressed() {
    amOn = !amOn;
  }
  public void draw() {
    if (amOn) {
      fill(255);
    }  else {
      fill(50);
    }
    rect(myX,myY,myW,myH);
  }
}

public final static int ROWS = 8;
public final static int COLS = 8;

public Button[][] buttonArray = new Button[ROWS][COLS];

public void setup() {
  size(600,600);
  Interactive.make(this);
  background(0);
  
  for (int i = 0; i < buttonArray.length; i++) {
    for (int j = 0; j < buttonArray[i].length; j++) {
      buttonArray[i][j] = new Button(width/ROWS*i,height/COLS*j,width/ROWS,height/COLS);
    }
  }
  
}

public void draw() {
}
