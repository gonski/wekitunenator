void drawTrainingBtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = height- btnWidth - 20;

  TrainingBtns[0] = cp5.addToggle("startRec")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[1] = cp5.addToggle("stopRec")
    .setValue(false)
    .setPosition(x1, y-btnWidth-20)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[2] = cp5.addToggle("train")
    .setValue(false)
    .setPosition(x1 +(2 + btnWidth), y-btnWidth-20)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[3] = cp5.addToggle("cancelTrain")
    .setValue(false)
    .setPosition(x1+(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[4] = cp5.addToggle("run")
    .setValue(false)
    .setPosition(x1+ 2*(2 + btnWidth) +20, y-btnWidth-20)
    .setSize(btnWidth, btnWidth);
    
  TrainingBtns[5] = cp5.addToggle("st0p")
    .setValue(false)
    .setPosition(x1+ 2*(2 + btnWidth) + 20, y)
    .setSize(btnWidth, btnWidth);
}
