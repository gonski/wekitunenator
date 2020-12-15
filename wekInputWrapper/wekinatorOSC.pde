void sendInputOscToWekinator() {
  OscMessage msg = new OscMessage("/wek/inputs");

  // only x, y
  msg.add((float)round(origin[0]));
  msg.add((float)round(origin[1]));


  for (int i=0; i<dist.length; i++) {
    msg.add((float)round(dist[i]));
  }

  for (int i=0; i<midiFX.length; i++) {
    float state = FXBtns[i].getState() ? 1 : 0;
    msg.add((float)state);
  }

  osc.send(msg, loc); // total 5 FX  + 20 dist + 2 xy origin = 27
}



void sendTrainingOscToWekinator() {
OscMessage msg = new OscMessage("/wek/");
// to do
}
