void sendOscToWekinator(float leftDist,float rightDist) {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)leftDist);
  msg.add((float)rightDist);
  osc.send(msg, loc);
}
