void drawFXbtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = 20;

  FXBtns[0] = cp5.addToggle("FX1")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  FXBtns[1] = cp5.addToggle("FX2")
    .setValue(false)
    .setPosition(x1 + 2 + btnWidth, y)
    .setSize(btnWidth, btnWidth);

  FXBtns[2] = cp5.addToggle("FX3")
    .setValue(false)
    .setPosition(x1 + 2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  FXBtns[3] = cp5.addToggle("FX4")
    .setValue(false)
    .setPosition(x1+ 3*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  FXBtns[4] = cp5.addToggle("FX5")
    .setValue(false)
    .setPosition(x1+ 4*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}
