void drawTrainingBtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = height- btnWidth - 20;

  TrainingBtns[0] = cp5.addToggle("startRecording")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[1] = cp5.addToggle("stopRecording")
    .setValue(false)
    .setPosition(x1 + 2 + btnWidth, y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[2] = cp5.addToggle("train")
    .setValue(false)
    .setPosition(x1 + 2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[3] = cp5.addToggle("cancelTrain")
    .setValue(false)
    .setPosition(x1+ 3*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[4] = cp5.addToggle("starRunning")
    .setValue(false)
    .setPosition(x1+ 4*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
    
  TrainingBtns[5] = cp5.addToggle("stopRunning")
    .setValue(false)
    .setPosition(x1+ 5*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}
