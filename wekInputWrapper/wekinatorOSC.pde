void sendInputOscToWekinator() {
  OscMessage msg = new OscMessage("/wek/inputs");

  // only x, y
  msg.add((float)round(origin[0]));
  msg.add((float)round(origin[1]));


  for (int i=0; i<dist.length; i++) {
    msg.add((float)round(dist[i]));
  }

  for (int i=0; i<midiFX.length; i++) {
    float state = FXBtns[i].getState() ? 1 : 0; // send in order
    msg.add((float)state);
  }

  osc.send(msg, loc); // total 5 FX  + 20 dist + 2 xy origin = 27
}



void sendTrainingOscToWekinator() {
  OscMessage msg = new OscMessage("/");
  for (int i=0; i<midiTraining.length; i++) {
    if (lastTrainingBtnValue[i] != TrainingBtns[i].getState()) {
      println("sending message",i, TrainingBtns[i].getState());
      if (TrainingBtns[i].getState()) {    // to improve
        switch(i) {
        case 0:
          msg.setAddrPattern("/wekinator/control/startRecording");
          break;
        case 1:
          msg.setAddrPattern("/wekinator/control/train");
          break;
        case 2:
          msg.setAddrPattern("/wekinator/control/startRunning");
          break;
        }
      } else {
        switch(i) {
        case 0:
          msg.setAddrPattern("/wekinator/control/stopRecording");
          break;
        case 1:
          msg.setAddrPattern("/wekinator/control/cancelTrain");
          break;
        case 2:
          msg.setAddrPattern("/wekinator/control/stopRunning");
          break;
        }
      }
    }

    lastTrainingBtnValue[i]= TrainingBtns[i].getState();
    osc.send(msg, loc);
  }
}
