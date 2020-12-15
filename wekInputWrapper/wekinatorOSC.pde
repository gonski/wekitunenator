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
    if (TrainingBtns[i].isOn()) {    // to improve
      TrainingBtns[i].setOff();
      println(i, "ison");
      switch(i) {
      case 0:
        msg.setAddrPattern("/wekinator/control/startRecording");
        break;
      case 1:
        msg.setAddrPattern("/wekinator/control/stopRecording");
        break;
      case 2:
        msg.setAddrPattern("/wekinator/control/train");
        break;
      case 3:
        msg.setAddrPattern("/wekinator/control/cancelTrain");
        break;
      case 4:
        msg.setAddrPattern("/wekinator/control/startRunning");
        break;
      case 5:
        msg.setAddrPattern("/wekinator/control/stopRunning");
        break;
      }
    }
    osc.send(msg, loc);
  }
}
