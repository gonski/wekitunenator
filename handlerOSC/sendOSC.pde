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

  osc.send(msg, wekAddr); // total 5 FX  + 20 dist + 2 xy origin = 27
}



void sendTrainingOscToWekinator() {
  OscMessage msg = new OscMessage("/");
  for (int i=0; i<midiTraining.length; i++) {
    if (lastTrainingBtnValue[i] != TrainingBtns[i].getState()) {
      if (TrainingBtns[i].getState()) {
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
    osc.send(msg, wekAddr);
  }
}

void sendOutputOscToWekinator() {
  OscMessage msg = new OscMessage("/wekinator/control/outputs");
  
  for (int i=0; i<knobCCs.length; i++) {
    msg.add((float)knobVal[i]);
  }
  osc.send(msg, wekAddr); // total 5 FX  + 20 dist + 2 xy origin = 27
}



void sendOscWek2Reaper(OscMessage msgWek) {
  /**
   FX PARAMETERS COMPLETE LIST
   1. Autotune
   Bypass: /track/1/fx/1/bypass 0/1
   Presets (scales): /track/1/fx/1/fxparam/2/value range:0.027777778-0.3611111 (chromatic + 12 major scales)
   
   2. Glitcher
   Bypass: /track/1/fx/2/bypass 0/1
   Shift (full range): /track/1/fx/2/fxparam/4/value range:0.25/1
   
   3. Reverse
   Bypass: /track/1/fx/3/bypass 0/1
   Wet amount: /track/1/fx/3/fxparam/1/value range:0-1
   
   4. Delay
   Bypass: /track/1/fx/4/bypass 0/1
   Wet amount: /track/1/fx/4/fxparam/1/value range:0-1
   Length (musical): /track/1/fx/4/fxparam/5/value range:0-0.0390625
   Feedback: /track/1/fx/4/fxparam/6/value range:0-0.55791545
   
   5. Reverb
   Bypass: /track/1/fx/5/bypass 0/1
   Wet amount: /track/1/fx/5/fxparam/1/value range:0-1
   Room size: /track/1/fx/5/fxparam/3/value range:0-1
   **/
  // Directly modify specific param values (as many wek ouputs as param values)

  ////1. Autotune
  if (FXBtns[0].getState()) {
    //Presets (scales): /track/1/fx/1/fxparam/2/value range:0.027777778-0.3611111 (chromatic + 12 major scales)
    OscMessage autotunePresets = new OscMessage("/track/1/fx/1/fxparam/2/value");
    autotunePresets.add(map(msgWek.get(0).floatValue(), 0, 1, 0.027777778, 0.3611111));
    osc.send(autotunePresets, reaperAddr);
  }

  ////2. Glitcher
  if (FXBtns[1].getState()) {
    //Shift (full range): /track/1/fx/2/fxparam/4/value range:0.25/1
    OscMessage glitcherShift = new OscMessage("/track/1/fx/2/fxparam/4/value");
    glitcherShift.add(map(msgWek.get(1).floatValue(), 0, 1, 0.25, 1));
    osc.send(glitcherShift, reaperAddr);
  }

  //3. Reverse
  if (FXBtns[2].getState()) {
    //Wet amount: /track/1/fx/3/fxparam/1/value range:0-1
    OscMessage reverseWet = new OscMessage("/track/1/fx/3/fxparam/1/value");
    reverseWet.add(msgWek.get(2).floatValue());
    osc.send(reverseWet, reaperAddr);
  }

  //4. Delay
  if (FXBtns[3].getState()) {
    //Wet amount: /track/1/fx/4/fxparam/1/value range:0-1
    OscMessage delayWet = new OscMessage("/track/1/fx/4/fxparam/1/value");
    delayWet.add(msgWek.get(3).floatValue());
    osc.send(delayWet, reaperAddr);
    //Length (musical): /track/1/fx/4/fxparam/5/value range:0-0.0390625
    OscMessage delayLength = new OscMessage("/track/1/fx/4/fxparam/5/value");
    delayLength.add(map(msgWek.get(4).floatValue(), 0, 1, 0, 0.0390625));
    osc.send(delayLength, reaperAddr);
    //Feedback: /track/1/fx/4/fxparam/6/value range:0-0.55791545
    OscMessage delayFb = new OscMessage("/track/1/fx/4/fxparam/6/value");
    delayFb.add(map(msgWek.get(5).floatValue(), 0, 1, 0, 0.55791545));
    osc.send(delayFb, reaperAddr);
  }

  //5. Reverb
  if (FXBtns[4].getState()) {
    //Wet amount: /track/1/fx/5/fxparam/1/value range:0-1
    OscMessage reverbWet = new OscMessage("/track/1/fx/5/fxparam/1/value");
    reverbWet.add(msgWek.get(6).floatValue());
    osc.send(reverbWet, reaperAddr);
    //Room size: /track/1/fx/5/fxparam/3/value range:0-1
    OscMessage reverbSize = new OscMessage("/track/1/fx/5/fxparam/3/value");
    reverbSize.add(msgWek.get(7).floatValue());
    osc.send(reverbSize, reaperAddr);
  }
}

void sendOscMidi2Reaper() {
  ////1. Autotune
  OscMessage bypass1 = new OscMessage("/track/1/fx/1/bypass");
  bypass1.add(FXBtns[0].getValue());
  osc.send(bypass1, reaperAddr);
  if (FXBtns[0].getState()) {
    //Presets (scales)
    OscMessage autotunePresets = new OscMessage("/track/1/fx/1/fxparam/2/value");
    autotunePresets.add(map(knobVal[0], 0, 1, 0.027777778, 0.3611111));
    osc.send(autotunePresets, reaperAddr);
  }

  ////2. Glitcher
  OscMessage bypass2 = new OscMessage("/track/1/fx/2/bypass");
  bypass2.add(FXBtns[1].getValue());
  osc.send(bypass2, reaperAddr);
  if (FXBtns[1].getState()) {
    //Shift (full range)
    OscMessage glitcherShift = new OscMessage("/track/1/fx/2/fxparam/4/value");
    glitcherShift.add(map(knobVal[1], 0, 1, 0.25, 1));
    osc.send(glitcherShift, reaperAddr);
  }

  ////3. Reverse
  OscMessage bypass3 = new OscMessage("/track/1/fx/3/bypass");
  bypass3.add(FXBtns[2].getValue());
  osc.send(bypass3, reaperAddr);
  if (FXBtns[2].getState()) {
    //Wet amount: /track/1/fx/3/fxparam/1/value range:0-1
    OscMessage reverseWet = new OscMessage("/track/1/fx/3/fxparam/1/value");
    reverseWet.add(knobVal[2]);
    osc.send(reverseWet, reaperAddr);
  }

  ////4. Delay
  OscMessage bypass4 = new OscMessage("/track/1/fx/4/bypass");
  bypass4.add(FXBtns[3].getValue());
  osc.send(bypass4, reaperAddr);
  if (FXBtns[3].getState()) {
    //Wet amount
    OscMessage delayWet = new OscMessage("/track/1/fx/4/fxparam/1/value");
    delayWet.add(knobVal[3]);
    osc.send(delayWet, reaperAddr);
    //Length (musical)
    OscMessage delayLength = new OscMessage("/track/1/fx/4/fxparam/5/value");
    delayLength.add(map(knobVal[4], 0, 1, 0, 0.0390625));
    osc.send(delayLength, reaperAddr);
    //Feedback
    OscMessage delayFb = new OscMessage("/track/1/fx/4/fxparam/6/value");
    delayFb.add(map(knobVal[5], 0, 1, 0, 0.55791545));
    osc.send(delayFb, reaperAddr);
  }

  ////5. Reverb
  OscMessage bypass5 = new OscMessage("/track/1/fx/5/bypass");
  bypass5.add(FXBtns[4].getValue());
  osc.send(bypass5, reaperAddr);
  if (FXBtns[4].getState()) {
    //Wet amount
    OscMessage reverbWet = new OscMessage("/track/1/fx/5/fxparam/1/value");
    reverbWet.add(knobVal[6]);
    osc.send(reverbWet, reaperAddr);
    //Room size
    OscMessage reverbSize = new OscMessage("/track/1/fx/5/fxparam/3/value");
    reverbSize.add(knobVal[7]);
    osc.send(reverbSize, reaperAddr);
  }
}
