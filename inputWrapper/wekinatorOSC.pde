void sendOscToWekinator(float leftDist,float rightDist) {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)leftDist);
  msg.add((float)rightDist);
  
  for (int i=0; i<midiFX.length;i++){
    float state = btns[i].getState() ? 1 : 0;
    msg.add((float)state);
  }
  
  osc.send(msg, loc);
}
