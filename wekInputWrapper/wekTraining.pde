void drawTrainingBtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = height- btnWidth - 20;

  TrainingBtns[0] = cp5.addToggle("rec")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[1] = cp5.addToggle("train")
    .setValue(false)
    .setPosition(x1+(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[2] = cp5.addToggle("run")
    .setValue(false)
    .setPosition(x1 +2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}
