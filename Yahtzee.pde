final color BROWN = #662200;
final color BLACK = #000000;
final color WHITE = #FFFFFF;
final color ORANGE = #FF8800;
final color BLUE = #0000FF;
final color RED = #FF0000;
final color YELLOW = #EEEE00;
final color GRAY = #DDDDDD;

final int DICE = 5;
final int SIDES = 6;
// Round 4 is used to indicate that the player must choose a score for the dice
final int ROUNDS = 3;   
Die[] dice = new Die[DICE];
final int THICK_STROKE = 3;
final int THING_STROKE = 1;

final int DICE_SIDE_LENGTH = 64;
final int DICE_SPACER = 30;
final int DICE_BOX_LEFT_OFFSET = 10;
final int DICE_BOX_TOP_OFFSET = 20;
final int DICE_BOX_HEIGHT = DICE_SIDE_LENGTH + DICE_SPACER + 32;
final int DICE_BOX_WIDTH = 512;
// From left of window to first die (and first button, which will align vertically)
final int DICE_LEFT_OFFSET = 40;
// From top of window to top of grid
final int DICE_TOP_OFFSET = 68; 

final int ROLL_SCORE_LEFT_OFFSET = DICE_BOX_LEFT_OFFSET + DICE_BOX_WIDTH + DICE_SPACER;
final int ROLL_SCORE_TOP_OFFSET = DICE_BOX_TOP_OFFSET;
final int HELP_BOX_LEFT_OFFSET = ROLL_SCORE_LEFT_OFFSET;
final int HELP_BOX_TOP_OFFSET = ROLL_SCORE_TOP_OFFSET + 64;

final int SCOREBOARD_WIDTH = 324;
final int SCOREBOARD_HEIGHT = 432;
final int SCOREBOARD_SPACER = 16;
final int SCORE_LINES = 12;
final int LINE_HEIGHT = SCOREBOARD_HEIGHT / SCORE_LINES;
final int SCOREBOARD_LEFT_OFFSET = 10; // + DICE*(DICE_SIDE_LENGTH + DICE_SPACER) + 32;
final int SCOREBOARD_RIGHT_OFFSET = SCOREBOARD_LEFT_OFFSET + SCOREBOARD_WIDTH + SCOREBOARD_SPACER;
final int SCOREBOARD_TOP_OFFSET = DICE_TOP_OFFSET + DICE_SIDE_LENGTH + DICE_SPACER;
final int SCOREBOARD_DISTANCE_FROM_RIGHT = 64;
final int SCOREBOARD_LEFT_VERTICAL_LINE = SCOREBOARD_LEFT_OFFSET + SCOREBOARD_WIDTH - SCOREBOARD_DISTANCE_FROM_RIGHT;
final int SCOREBOARD_RIGHT_VERTICAL_LINE = SCOREBOARD_RIGHT_OFFSET + SCOREBOARD_WIDTH - SCOREBOARD_DISTANCE_FROM_RIGHT;
// Distance from vertical line to actual score
final int SCORE_OFFSET = 26;

final int TOTAL_LEFT_OFFSET = SCOREBOARD_RIGHT_OFFSET;
final int TOTAL_TOP_OFFSET = 610;

// When it is time to select a score for the dice, this will be used to determine
// which score is to be changed
int selectedScore;

final int BUTTON_WIDTH = 100;
final int NEW_GAME_BUTTON_WIDTH = 200;
final int BUTTON_HEIGHT = 40;
final int BUTTON_LEFT_OFFSET = SCOREBOARD_LEFT_OFFSET;
final int BUTTON_SPACER = 24;
final int BUTTON_TOP_OFFSET = SCOREBOARD_TOP_OFFSET + SCOREBOARD_HEIGHT + 24;

final int SPRITE_SHEET_OFFSET = 0;
final int SPRITE_SHEET_WIDTH = 384;
final int SPRITE_SHEET_HEIGHT = 448;
PImage[][] liveDiceImages = new PImage[ROUNDS][SIDES];
PImage[] frozenDiceImages = new PImage[SIDES];

//PImage yahtzeeScoresheet;
Scoreboard scoreboard;
HelpPage helpPage;

PFont font;
int TEXT_LEFT_OFFSET = 10;
int TEXT_TOP_OFFSET = -3;
int TEXT_SIZE = 28;

int rollNum = 0;  // rollNum 0 means no roll yet for the upcoming round

int yahtzeeBonus = 0;

int TEST_TICKS = 100; // DiceValue.testSuite() will be called once per TEST_TICKS
int tick = 0;

PImage spriteSheet;
// state:
//   PRE_GAME    -> No dice
//   ACTIVE_GAME -> Step one iteration
//   POST_GAME   -> Play continuous iterations
enum STATE { PRE_ROUND, MID_ROUND, POST_ROUND, GAME_OVER };
STATE state;

enum MODE { GAME, HELP };
MODE mode;

enum SCORES { YAHTZEE_BONUS, ONES, TWOS, THREES, FOURS, FIVES, SIXES, 
              TRIPS, QUADS, YAHTZEE, 
              FULL_HOUSE, SMALL_STRAIGHT, LARGE_STRAIGHT, CHANCE;
                
              static final int COUNT = SCORES.values().length; };
static int[] scores = new int[SCORES.COUNT];

void setup() {
  // The one obnoxious line of code.  It turns out that numeric literals have
  // to be entered into the first two arguments of the size() procedure.
  // The size cannot be determined by defined constants.
  size(684, 684);

  // Set up the help page
  initHelpPage();
  // Set up the font for button display
  initFont();
  // Initialize the dice
  initDice();
  // Initialize the dice images
  initliveDiceImages();
  // Initialize the scoreboard
  initScoreboard();
  // Initialize game information
  initGame();
}

// draw() is effectively inside an infinite loop.
void draw() {
  background(WHITE);
  stroke(BLACK);
  
  if (mode == MODE.HELP) {
    helpPage.draw();
  } else {
    // Create the scoreboard
    scoreboard.draw();
    // Draw buttons
    drawButtons();
    // Draw dice
    drawDice();
    
    tick = (tick + 1) % TEST_TICKS;
    if (tick == 0) {
      testSuite();
    }
  }
}

// DICE SETUP AND DISPLAY CODE
void initDice() {
  for (int i = 0; i < DICE; i++) {
    dice[i] = new Die(SIDES);
  }
}

void initliveDiceImages() {
  // Reproduced with permission (see: https://forum.thegamecreators.com/thread/208087)
  spriteSheet = loadImage("agk_spritesheet_dice1.png");

  for (int side = 0; side < SIDES; side++) {
    for (int roll = 0; roll < ROUNDS; roll++) {
      liveDiceImages[roll][side] = 
          spriteSheet.get(side*DICE_SIDE_LENGTH,
                          ((4*roll+1) % 7)*DICE_SIDE_LENGTH,
                          DICE_SIDE_LENGTH,
                          DICE_SIDE_LENGTH);
    }
    frozenDiceImages[side] = spriteSheet.get(side*DICE_SIDE_LENGTH,0,
                                   DICE_SIDE_LENGTH,DICE_SIDE_LENGTH);
  }
}

void drawDice() {
  // Dice box
  fill(WHITE);
  strokeWeight(THICK_STROKE);
  rect(DICE_BOX_LEFT_OFFSET, DICE_BOX_TOP_OFFSET, 
       DICE_BOX_WIDTH, DICE_BOX_HEIGHT);
       
  fill(BLACK);
  for (int i = 0; i < DICE; i++) {
    drawText((i+1) + "", DICE_LEFT_OFFSET+i*(DICE_SIDE_LENGTH+DICE_SPACER)+10, DICE_TOP_OFFSET-36);
    dice[i].draw(DICE_LEFT_OFFSET+i*(DICE_SIDE_LENGTH+DICE_SPACER),
                 DICE_TOP_OFFSET,
                 DICE_SIDE_LENGTH,
                 DICE_SIDE_LENGTH);
  }
  noFill();
}  

void drawButtons() {
  // Determine text to display in roll/score box
  String str = "Roll";
  if (state == STATE.POST_ROUND) str = "Score";
  if (state == STATE.GAME_OVER) str = "Finis!";

  // New Game and Quit rectangles in gray
  fill(GRAY);
  
  // New Game button
  rect(BUTTON_LEFT_OFFSET, BUTTON_TOP_OFFSET, 
       NEW_GAME_BUTTON_WIDTH, BUTTON_HEIGHT);
  
  rect(BUTTON_LEFT_OFFSET+(NEW_GAME_BUTTON_WIDTH+BUTTON_SPACER), BUTTON_TOP_OFFSET, 
       BUTTON_WIDTH, BUTTON_HEIGHT);

  // Draw Roll/Score button in gray
  rect(ROLL_SCORE_LEFT_OFFSET, 
       DICE_BOX_TOP_OFFSET,
       BUTTON_WIDTH, 
       BUTTON_HEIGHT);

  // Set text color on the buttons to blue
  fill(BLUE);

  final int ROLL_LEFT = DICE_BOX_LEFT_OFFSET + DICE_BOX_WIDTH + DICE_SPACER + 12;
  final int SCORE_LEFT = DICE_BOX_LEFT_OFFSET + DICE_BOX_WIDTH + DICE_SPACER - 2;
  final int GAME_OVER_LEFT = DICE_BOX_LEFT_OFFSET + DICE_BOX_WIDTH + DICE_SPACER + 4;
  if (str.equals("Roll")) {
    drawText(str, 
             ROLL_LEFT,
             DICE_BOX_TOP_OFFSET);
  } else if (str.equals("Score")) { 
    drawText(str, 
             SCORE_LEFT,
             DICE_BOX_TOP_OFFSET);
  } else { // Game over
    fill(BLACK);
    rect(ROLL_SCORE_LEFT_OFFSET, 
      DICE_BOX_TOP_OFFSET,
      BUTTON_WIDTH, 
      BUTTON_HEIGHT);
    fill(RED);
    drawText(str, 
             GAME_OVER_LEFT,
             DICE_BOX_TOP_OFFSET);    
  }
  
  // Draw Help button in gray
  fill(GRAY);
  rect(HELP_BOX_LEFT_OFFSET, 
       HELP_BOX_TOP_OFFSET,
       BUTTON_WIDTH, 
       BUTTON_HEIGHT);

  fill(RED);
  textSize(16);
  drawText("? for help", HELP_BOX_LEFT_OFFSET-3, HELP_BOX_TOP_OFFSET+4);
  textSize(TEXT_SIZE);
  
  fill(BLUE);
  // Draw Start/Stop, Step, Clear text onto the gray buttons
  final int NEW_GAME_LEFT = BUTTON_LEFT_OFFSET + 10;
  drawText("New Game", NEW_GAME_LEFT, BUTTON_TOP_OFFSET); 
  final int QUIT_LEFT = BUTTON_LEFT_OFFSET + (NEW_GAME_BUTTON_WIDTH + BUTTON_SPACER) + 6;
  drawText("Quit", QUIT_LEFT, BUTTON_TOP_OFFSET); 
  
  noFill();
}

// SCOREBOARD SETUP CODE
void initScoreboard() {  
  scoreboard = new Scoreboard();
}

// GAME SETUP CODE
void initGame() {
  scoreboard.initScores();  // Zero out the scoreboard
  selectedScore = -1;       // Clear any highlight
  state = STATE.MID_ROUND;  // Start the game having done the first roll
  rollNum = 1;              // First roll is shown
  for (Die d : dice) {
    d.unfreeze();
    d.roll();
  }
}

// CREATE HELP PAGE
void initHelpPage() {
  helpPage = new HelpPage();
}

// FONT SETUP CODE
void initFont() {
  textSize(TEXT_SIZE);
  font = createFont("ComicSansMS-Bold", TEXT_SIZE);
  textFont(font);
  textAlign(LEFT, CENTER);
}

// TODO: drawText
// ARGS: text, left, adjust, top
// More or less a method used to give an initial, useful approximation of where
// text should be situated for display. The argument to left will be a bit kludgy
// as the font may not be fixed size. (The one being used by default, Comic Sans,
// is not fixed size.)
void drawText(String text, int left, int top) {
  text(text, left + TEXT_SIZE/2, top + TEXT_SIZE/2);
}
