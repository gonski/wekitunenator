void noteOn(int channel, int pitch, int velocity) {

  // FX
  for (int i=0; i<midiFX.length; i++) {
    if (midiFX[i] == pitch) {
      if (FXBtns[i].getState()) {
        FXBtns[i].setState(false);
      } else {
        FXBtns[i].setState(true);
      }
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

// Get knobs MIDI
void controllerChange(int channel, int number, int value) {
  //println("Got MIDI CC: " + number + " Velocity: " + value);
  for (int i=0; i<knobCCs.length; i++) {
    if (knobCCs[i] == number) {
      knobVal[i]=map(value, 0, 127, 0, 1);
      println("Knob " + i + " " + knobVal[i]);
    }
  }
  sendOscMidi2Reaper();
}
