// Display code to help player see keypress options
class HelpPage {
  public void draw() {
    drawText("Keyboard actions:", 16, 20);
    drawText("1, 2, 3, 4, 5", 16, 80);
    drawText("Freeze or unfreeze a die", 256, 80);
    drawText("a..m, A..M", 16, 116);
    drawText("Select scoring category", 256, 116);
    drawText("RETURN/ENTER", 16, 152);
    drawText("Start game/Input score", 256, 152);
    drawText("SPACE", 16, 188);
    drawText("Roll unfrozen dice", 256, 188);
    drawText("Type '?' or click anywhere", 32, 260);
    drawText("to return", 32, 296);

  }
}

public void toggleHelp() {
  mode = (mode == MODE.HELP ? MODE.GAME : MODE.HELP);
}
