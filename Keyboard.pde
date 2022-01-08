// NOTE: Characters are NOT Strings.  Characters (char data type) are
// in single quotes, only one character can go between the single quotes,
// and chars have corresponding Unicode values.  They are primitive data.
//
// Strings, of course, go in double-quotes and are objects that have methods.
//
// Comparing Strings should be done with either compareTo(String other) or
// equals(String other), depending on what you are trying to accomplish.
// == for Strings compares memory locations; it isn't what you want.
//
// Comparing chars is done with == as they are primitives and you want to
// test if two Unicode values are the same.
//
// In keyPressed(), below, the "key" keyword is type char, so == is used.

void keyPressed() {
  if (key == '?') {
    toggleHelp();
  }
  // Do not accept non-H kepresses while in HELP mode
  if (mode == MODE.HELP) return;  
  
  if (key == ' ') {  // SPACE
    roll();
  //} else if (key == 'n' || key == 'N') {  // Uncomment to always start a fresh game
  //  setup();
  //} else if (key == 'q' || key == 'Q') {  // Uncomment to always allow quit
  //  exit();
  } else if (between(key, 'a', 'm') || between(key, 'A', 'M')) {
    if (state == STATE.POST_ROUND) {
      int attemptedScore = key - 'a' + 1;
      if (scores[attemptedScore] == -1) {
        selectedScore = attemptedScore;
      }
    }
  } else if (between(key, '1', '5')) {
    dice[key-'1'].toggle();
  } else if (key == RETURN || key == ENTER) {
    if (state == STATE.POST_ROUND && selectedScore != -1) {
      saveScore();
      if (allScored()) {
        state = STATE.GAME_OVER;
        println("Game Over");
      } else {
        rollNum = 0;
        state = STATE.PRE_ROUND;
      }
    } else if (state == STATE.GAME_OVER) {
      initGame();
    }
  }
}

// Score choice has been selected and confirmed; update appropriate score
// and prepare for next round
void saveScore() {
  // In the event that a Yahtzee has already been achieved, subsequent
  // Yahtzees receive a 100 point bonus and the player must select
  // some other category to score the dice.  Note that if the player
  // has zeroed out the Yahtzee entry, no bonus is .
  if ((scores[9] == 50) && isYahtzee(dice)) scores[0] += 100;
  if (between(selectedScore,1,6)) {  // ones through sixes
    scores[selectedScore] = sumPips(dice, selectedScore);
  } else if (selectedScore == 7) {   // three of a kind
    scores[selectedScore] = isTrips(dice) ? chance(dice) : 0;
  } else if (selectedScore == 8) {   // four of a kind
    scores[selectedScore] = isQuads(dice) ? chance(dice) : 0;
  } else if (selectedScore == 9) {   // five of a kind
    scores[selectedScore] = isYahtzee(dice) ? 50 : 0;
  } else if (selectedScore == 10) {  // full house
    scores[selectedScore] = isFullHouse(dice) ? 25 : 0;
  } else if (selectedScore == 11) {  // small straight
    scores[selectedScore] = isSmallStraight(dice) ? 30 : 0;
  } else if (selectedScore == 12) {  // large straight
    scores[selectedScore] = isLargeStraight(dice) ? 40 : 0;
  } else if (selectedScore == 13) {  // chance
    scores[selectedScore] = chance(dice);
  }
  selectedScore = -1;  // deselect score row after saved
}

void roll() {
  if (state == STATE.POST_ROUND) return;
  if (state == STATE.GAME_OVER) {
    //System.out.println("Game over");
    return;
  }
  if (state == STATE.PRE_ROUND) {
    unfreezeDice();
    state = STATE.MID_ROUND;
  }
  rollDice();
  rollNum++;
  if (between(rollNum,1,2)) state = STATE.MID_ROUND;
  if (rollNum == 3) state = STATE.POST_ROUND;
}

public void rollDice() {
  for (int i = 0; i < dice.length; i++) {
    dice[i].roll();
  }
}

public void unfreezeDice() {
  for (int i = 0; i < DICE; i++) {
    dice[i].unfreeze();
  }
}
