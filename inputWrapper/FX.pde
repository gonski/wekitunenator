void drawFXbtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = 20;

  btns[0] = cp5.addToggle("FX1")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  btns[1] = cp5.addToggle("FX2")
    .setValue(false)
    .setPosition(x1 + 2 + btnWidth, y)
    .setSize(btnWidth, btnWidth);

  btns[2] = cp5.addToggle("FX3")
    .setValue(false)
    .setPosition(x1 + 2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  btns[3] = cp5.addToggle("FX4")
    .setValue(false)
    .setPosition(x1+ 3*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  btns[4] = cp5.addToggle("FX5")
    .setValue(false)
    .setPosition(x1+ 4*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}

void noteOn(int channel, int pitch, int velocity) {

  for (int i=0; i<midiFX.length; i++) {
    if (midiFX[i] == pitch) {
      if (btns[i].getState()) {
        btns[i].setState(false);
      } else {
        btns[i].setState(true);
      }
      println("FXbtn " + btns[i].getState(), btns[i].getMode());
    }
  }
}
