class Scoreboard {
  // Indices:
  // 0: YAHTZEE Bonuses
  // 1: Ones
  // 2: Twos
  // 3: Threes
  // 4: Fours
  // 5: Fives
  // 6: Sixes
  // 7: Trips
  // 8: Quads
  // 9: YAHTZEE
  // 10: Full House
  // 11: Small Straight
  // 12: Large Straight
  // 13: Chance
                  
  public Scoreboard() {
    initScores();
  }
  
  private void initScores() {
    for (int i = 0; i < scores.length; i++) {
      scores[i] = -1;
    }
    scores[0] = 0;  // YAHTZEE BONUS
  }
  
  public void draw() {
    strokeWeight(THICK_STROKE);
    if (selectedScore > -1) {
      highlightScore(selectedScore);
    }
    rect(SCOREBOARD_LEFT_OFFSET, SCOREBOARD_TOP_OFFSET, SCOREBOARD_WIDTH, SCOREBOARD_HEIGHT);
    rect(SCOREBOARD_RIGHT_OFFSET, SCOREBOARD_TOP_OFFSET, SCOREBOARD_WIDTH, SCOREBOARD_HEIGHT);    

    for (int i = 2; i < 11; i++) {
      line(SCOREBOARD_LEFT_OFFSET, 
           SCOREBOARD_TOP_OFFSET + i*LINE_HEIGHT,
           SCOREBOARD_LEFT_OFFSET + SCOREBOARD_WIDTH, 
           SCOREBOARD_TOP_OFFSET + i*LINE_HEIGHT); 
      line(SCOREBOARD_LEFT_OFFSET + SCOREBOARD_WIDTH + SCOREBOARD_SPACER, 
           SCOREBOARD_TOP_OFFSET + i*LINE_HEIGHT,
           SCOREBOARD_LEFT_OFFSET + SCOREBOARD_WIDTH + SCOREBOARD_SPACER + SCOREBOARD_WIDTH, 
           SCOREBOARD_TOP_OFFSET + i*LINE_HEIGHT); 
    }
    
    // Vertical lines that separate score descriptors from the actual scores
    line(SCOREBOARD_LEFT_VERTICAL_LINE, SCOREBOARD_TOP_OFFSET, 
         SCOREBOARD_LEFT_VERTICAL_LINE, SCOREBOARD_TOP_OFFSET + SCOREBOARD_HEIGHT);
    line(SCOREBOARD_RIGHT_VERTICAL_LINE, SCOREBOARD_TOP_OFFSET, 
         SCOREBOARD_RIGHT_VERTICAL_LINE, SCOREBOARD_TOP_OFFSET + SCOREBOARD_HEIGHT);
    
    //textAlign(LEFT, TOP);

    String[] left = { "Total up", "which dice?", "Ones (A)", "Twos (B)", "Threes (C)", "Fours (D)", "Fives (E)", "Sixes (F)", 
                      "Sum", "63pt Bonus", "Left Half", "Total" };
    String[] right = { "What", "combination?", "Trips (G)", "Quads (H)", "YAHTZEE (I)", "Full House (J)", "Sm. Straight (K)", 
                       "Lg. Straight (L)", "Chance (M)", "YAHTZEE BONUS", "Right Half", "Total" };

    // Draw left scoreboard
    for (int i = 0; i < left.length; i++) {
      if (between(i,2,7)) fill(BLUE);
      else if (i > 9) fill(BROWN);
      else fill(BLACK);
      String txt = "";
      drawText(left[i], 
               SCOREBOARD_LEFT_OFFSET, 
               SCOREBOARD_TOP_OFFSET + TEXT_TOP_OFFSET + i*LINE_HEIGHT);
      if (between(i,2,7)) {
        txt = "" + (scores[i-1] != -1 ? scores[i-1] : "");
      } else if (i == 8) { // sum of left scores
        txt = "" + sumLeft();
      } else if (i == 9) { // bonus if sum >= 63
        txt = "" + getBonus();
      } else if (i == 11) { // left scores plus bonus
        txt = "" + (sumLeft() + getBonus());
      }
      
      int offset = SCORE_OFFSET - (txt.length()-1) * (TEXT_SIZE/2 + 1);
      
      drawText(txt, 
         SCOREBOARD_LEFT_VERTICAL_LINE + offset, 
         SCOREBOARD_TOP_OFFSET + TEXT_TOP_OFFSET + i*LINE_HEIGHT);
    }
    
    // Draw right scoreboard
    for (int i = 0; i < right.length; i++) {
      if (between(i,2,8)) fill(BLUE);
      else if (i > 9) fill(BROWN);
      else fill(BLACK);
      drawText(right[i], 
               SCOREBOARD_RIGHT_OFFSET, 
               SCOREBOARD_TOP_OFFSET + TEXT_TOP_OFFSET + i*LINE_HEIGHT);
      String txt = "";
      int score = 0;
      if (between(i,2,8)) {
        score = scores[i+5];
        txt = "" + (score != -1 ? score : "");
      } else if (i == 9) { // YAHTZEE bonus
        txt = "" + scores[0];
      } else if (i == 11) { // sum of left scores
        txt = "" + sumRight();
      }

      int offset = SCORE_OFFSET - (txt.length()-1) * (TEXT_SIZE/2 + 1);
      
      drawText(txt, 
         SCOREBOARD_RIGHT_VERTICAL_LINE + offset, 
         SCOREBOARD_TOP_OFFSET + TEXT_TOP_OFFSET + i*LINE_HEIGHT);
    }
    
    // Draw total score inside box
    if (state == STATE.GAME_OVER) {
      fill(ORANGE);
    } else {
      noFill();
    }
    rect(TOTAL_LEFT_OFFSET, TOTAL_TOP_OFFSET, SCOREBOARD_WIDTH, LINE_HEIGHT*3/2);
    fill(BROWN);
    drawText("TOTAL", TOTAL_LEFT_OFFSET, TOTAL_TOP_OFFSET + LINE_HEIGHT/4);
    
    String txt = "" + (sumLeft() + sumRight() + getBonus());
    int offset = SCORE_OFFSET - (txt.length()-1) * (TEXT_SIZE/2 + 1);
    drawText(txt, 
      SCOREBOARD_RIGHT_VERTICAL_LINE + offset, 
      TOTAL_TOP_OFFSET + TEXT_TOP_OFFSET + LINE_HEIGHT/4);

    strokeWeight(1);
  }
  
  public int sumLeft() {
    int sum = 0;
    for (int i = 1; i <= 6; i++) {
      if (scores[i] != -1) {
        sum += scores[i];
      }
    }
    return sum;
  }
  
  public int sumRight() {
    int sum = 0;
    for (int i = 7; i <= 13; i++) {
      sum += scores[i] == -1 ? 0 : scores[i];
    }
    return sum + scores[0];  // include the Yahtzee bonus
  }
    
  public int getBonus() {
    int sum = 0;
    for (int i = 1; i <= 6; i++) {
      if (scores[i] != -1) {
        sum += scores[i];
      }
    }
    return sum >= 63 ? 35 : 0;
  }
  
  public int total() {
    return getBonus() + sumLeft() + sumRight();
  }
  
  // Select a box that could be scored if RETURN is pressed
  void highlightScore(int choice) {
    // No score to highlight
    if (choice == -1) return;
    
    // Wouldn't it be nice if cond existed in Java?
    fill(YELLOW);
    stroke(YELLOW);
    if (between(choice, 1, 6)) {  // left scoreboard
      rect(SCOREBOARD_LEFT_OFFSET, SCOREBOARD_TOP_OFFSET + (choice+1)*(LINE_HEIGHT),
           SCOREBOARD_WIDTH, LINE_HEIGHT);
    } else if (between(choice, 7, 13)) {
      rect(SCOREBOARD_RIGHT_OFFSET, SCOREBOARD_TOP_OFFSET + (choice-5)*(LINE_HEIGHT),
           SCOREBOARD_WIDTH, LINE_HEIGHT);
    }      
    noFill();
    stroke(BLACK);
  }

}
