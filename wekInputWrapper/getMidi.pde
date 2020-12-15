void noteOn(int channel, int pitch, int velocity) {

  // FX
  for (int i=0; i<midiFX.length; i++) {
    if (midiFX[i] == pitch) {
      if (FXBtns[i].getState()) {
        FXBtns[i].setState(false);
      } else {
        FXBtns[i].setState(true);
      }
      println("FX " + i + " " + FXBtns[i].getState());
    }
  }




  //Training
  for (int i=0; i<midiTraining.length; i++) {
    if (midiTraining[i] == pitch) {
      if (TrainingBtns[i].getState()) {
        TrainingBtns[i].setState(false);
      } else {
        TrainingBtns[i].setState(true);
      }
    }
  }
}
