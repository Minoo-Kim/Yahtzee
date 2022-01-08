//// GENERAL NOTES
//// The purpose of using mousePressed() and mouseReleased() instead of
//// mouseClicked() is to adhere to the idea that confirmation of a clicked
//// button should include a release over the button as well. This is fairly
//// standard in the behavior of SUBMIT buttons in web browsers.
////
//// The strategy for handling button events is to gather information about
//// where a mouse was pressed and released and only if the two align is a
//// button action actually taken.

// When a non-button is clicked, use -1 to indicate none selected
int mousex = -1;
int mousey = -1;
// clickedRow and clickedCol are an integrity check to make sure that
// the user truly intends to toggle a particular cell.  The cell where
// the mouse was pressed needs to be the same as the cell where the
// mouse was released in order for a toggle to happen.
int clickedDie = -1;
// Grid constants for figuring out which cell has been clicked
int DICE_X_MIN = DICE_LEFT_OFFSET;
int DICE_Y_MIN = DICE_TOP_OFFSET;
int DICE_X_MAX = DICE_LEFT_OFFSET + DICE*(DICE_SIDE_LENGTH + DICE_SPACER);
int DICE_Y_MAX = DICE_TOP_OFFSET + DICE_SIDE_LENGTH;

// buttonPressed, buttonReleased:
//   -1 -> None
//    0 -> Roll
//    1 -> New Game
//    2 -> Quit
//    3 -> Help
//    4 -> Left scoreboard
//    5 -> Right scoreboard


int chosenObject;  // Used for debugging

// mousePressed() is used to capture a click event; (mouseX,mouseY) captures the
// location of the click
void mousePressed() {
  if (mode == MODE.HELP) {
    toggleHelp();
    return;
  }
  
  chosenObject = -1;
  // Was one of the dice clicked?
  if (between(mouseX, DICE_X_MIN, DICE_X_MAX) && between(mouseY, DICE_Y_MIN, DICE_Y_MAX)) {
    // Identify cell to toggle
    clickedDie = getDie(mouseX);
    if (clickedDie != -1) {
      dice[clickedDie].toggle();
    }
    rect(DICE_BOX_LEFT_OFFSET + DICE_BOX_WIDTH + DICE_SPACER, 
         DICE_BOX_TOP_OFFSET,
         BUTTON_WIDTH, 
         BUTTON_HEIGHT);
         
  // Was Roll button clicked?
  } else if (between(mouseX, ROLL_SCORE_LEFT_OFFSET, 
                             ROLL_SCORE_LEFT_OFFSET + BUTTON_WIDTH) &&
             between(mouseY, ROLL_SCORE_TOP_OFFSET, ROLL_SCORE_TOP_OFFSET + BUTTON_HEIGHT)) {
    roll();
    chosenObject = 0;  
               
  // Was New Game button clicked?
  } else if (between(mouseX, BUTTON_LEFT_OFFSET, BUTTON_LEFT_OFFSET + 2 * BUTTON_WIDTH) &&
             between(mouseY, BUTTON_TOP_OFFSET, BUTTON_TOP_OFFSET+BUTTON_HEIGHT)) {
    chosenObject = 1; 
    setup();

  // Was Quit button clicked?
  } else if (between(mouseX, BUTTON_LEFT_OFFSET + 2 * BUTTON_WIDTH + BUTTON_SPACER,
                             BUTTON_LEFT_OFFSET + 3 * BUTTON_WIDTH + BUTTON_SPACER) &&
             between(mouseY, BUTTON_TOP_OFFSET, BUTTON_TOP_OFFSET+BUTTON_HEIGHT)) {
    chosenObject = 2; 
    exit();
  
  } else if (between(mouseX, HELP_BOX_LEFT_OFFSET, HELP_BOX_LEFT_OFFSET + BUTTON_WIDTH) &&
             between(mouseY, HELP_BOX_TOP_OFFSET, HELP_BOX_TOP_OFFSET + BUTTON_HEIGHT)) {
  toggleHelp();
  chosenObject = 3;  

  // Was left scoreboard clicked?
  } else if (between(mouseX, SCOREBOARD_LEFT_OFFSET, SCOREBOARD_LEFT_OFFSET + SCOREBOARD_WIDTH) &&
             between(mouseY, SCOREBOARD_TOP_OFFSET + 2 * LINE_HEIGHT, SCOREBOARD_TOP_OFFSET + 8 * LINE_HEIGHT)) { 
    if (state == STATE.POST_ROUND) {
      int attemptedScore = ((mouseY - SCOREBOARD_TOP_OFFSET) / LINE_HEIGHT) - 1;  // lines 0 and 1 are text
      chosenObject = 4;
      System.out.println("Attempted score = " + attemptedScore);
      if (scores[attemptedScore] == -1) {
        selectedScore = attemptedScore;
      }
    }
    
  // Was right scoreboard clicked?
  } else if (between(mouseX, SCOREBOARD_RIGHT_OFFSET, SCOREBOARD_RIGHT_OFFSET + SCOREBOARD_WIDTH) &&
             between(mouseY, SCOREBOARD_TOP_OFFSET + 2 * LINE_HEIGHT, SCOREBOARD_TOP_OFFSET + 9 * LINE_HEIGHT)) { 
    if (state == STATE.POST_ROUND) {
      int attemptedScore = ((mouseY - SCOREBOARD_TOP_OFFSET) / LINE_HEIGHT) + 5;  // lines 0 and 1 are text
      chosenObject = 5;
      System.out.println("Attempted score = " + attemptedScore);
      if (scores[attemptedScore] == -1) {
        selectedScore = attemptedScore;
      }
    }
  }

  //println("Pressed: (" + mouseX + ", " + mouseY + "), " + chosenObject);
}

public int getDie(int x) {
  for (int i = 0; i < DICE; i++) {
    if (between(x, 
                DICE_LEFT_OFFSET + i*(DICE_SIDE_LENGTH+DICE_SPACER), 
                DICE_LEFT_OFFSET + i*(DICE_SIDE_LENGTH+DICE_SPACER)+DICE_SIDE_LENGTH)) {
                  return i;
                }
  }
  return -1;
}
