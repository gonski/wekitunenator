

void drawFXbtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = 20;


  btns[0] = cp5.addButton("FX1")
    .setValue(0)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  btns[1] = cp5.addButton("FX2")
    .setValue(0)
    .setPosition(x1 + 2 + btnWidth, y)
    .setSize(btnWidth, btnWidth);

  btns[2] = cp5.addButton("FX3")
    .setValue(0)
    .setPosition(x1 + 2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  btns[3] = cp5.addButton("FX4")
    .setValue(0)
    .setPosition(x1+ 3*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  btns[4] = cp5.addButton("FX5")
    .setValue(0)
    .setPosition(x1+ 4*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}
