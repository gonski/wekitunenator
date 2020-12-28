void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/landmarks")==true) {

    int k = -1;
    for (int i=0; i<3*21; i++) {
      if (i%3 == 0) {
        k++;
      }
      points[k][i%3] = msg.get(i).floatValue();
    }
    // get wekinator outputs and send them to reaper
  } else if (msg.checkAddrPattern("/wek/outputs")==true) {
    sendOscWek2Reaper(msg);
  }
}
