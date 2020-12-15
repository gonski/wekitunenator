void drawTrainingBtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = height- btnWidth - 20;

  TrainingBtns[0] = cp5.addButton("startRec")
    .setValue(0)
    .setPosition(x1, y-btnWidth-20)
    .setSize(btnWidth, btnWidth)
    .setSwitch(true);

  TrainingBtns[1] = cp5.addButton("stopRec")
    .setValue(0)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth)
    .setSwitch(true);


  TrainingBtns[2] = cp5.addButton("train")
    .setValue(0)
    .setPosition(x1 +(2 + btnWidth), y-btnWidth-20)
    .setSize(btnWidth, btnWidth)
    .setSwitch(true);


  TrainingBtns[3] = cp5.addButton("cancelTrain")
    .setValue(0)
    .setPosition(x1+(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth)
    .setSwitch(true);


  TrainingBtns[4] = cp5.addButton("run")
    .setValue(0)
    .setPosition(x1+ 2*(2 + btnWidth) +20, y-btnWidth-20)
    .setSize(btnWidth, btnWidth)
    .setSwitch(true);


  TrainingBtns[5] = cp5.addButton("st0p")
    .setValue(0)
    .setPosition(x1+ 2*(2 + btnWidth) + 20, y)
    .setSize(btnWidth, btnWidth)
    .setSwitch(true);
}
