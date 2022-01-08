
public class Die {
  private int value;
  private int sides;
  private boolean frozen;

  public Die() {
    this(SIDES);  // default to six sides
  }

  public Die(int sides) {
    this.sides = sides;
    frozen = false;
  }

  public int roll() {
    //value = 3;  // for testing purposes when we need to verify that extra yahtzees work
    if (!frozen) {
      value = (int) (sides * Math.random()) + 1;
    }
    return value;
  }
  
  public void toggle() {
    frozen = !frozen;
  }

  public void unfreeze() {
    frozen = false;
  }
  
  public int getValue() { return value; }
  public int getSides()  { return sides; }

  public String toString() {
    return "" + value;
  }
  
  public void draw(int x, int y, int w, int h) {
    PImage[] p = frozen || (state != STATE.MID_ROUND) ? frozenDiceImages : liveDiceImages[rollNum-1];
    if (frozen && state == STATE.MID_ROUND) {
      noFill();
      strokeWeight(3);
      rect(x-THICK_STROKE,y-THICK_STROKE,w+THICK_STROKE+2,h+THICK_STROKE+3);
      strokeWeight(1);
    } else if (state == STATE.PRE_ROUND) {
    } else if (state == STATE.POST_ROUND) {
    }
    image(p[value-1],x,y,w,h);
  }
}
