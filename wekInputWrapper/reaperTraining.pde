int[] bypass= new int[btns.length];

// Get knobs MIDI
void controllerChange(int channel, int number, int value) {
  //println("Got MIDI CC: " + number + " Velocity: " + value);
  for (int i=0; i<knobCCs.length; i++) {
    if (knobCCs[i] == number) {
      knobVal[i]=map(value,0,127,0,1);
      println("Knob " + i + " " + knobVal[i]);
    }
  }
  sendOSCtoReaper();
}

// Convert all toggles to 0 or 1
void boolean2int(){
  for (int i=0; i<btns.length; i++) {
    bypass[i] = btns[i].getState()? 1 : 0;
  }
}

void sendOSCtoReaper(){
  boolean2int();
  
  ////1. Autotune
  OscMessage bypass1 = new OscMessage("/track/1/fx/1/bypass");
  bypass1.add(bypass[0]); 
  osc.send(bypass1, dst);
  if(btns[0].getState()){
    //Presets (scales)
    OscMessage autotunePresets = new OscMessage("/track/1/fx/1/fxparam/2/value");
    autotunePresets.add(map(knobVal[0], 0, 1, 0.027777778, 0.3611111)); 
    osc.send(autotunePresets, dst);
  }
  
  ////2. Glitcher
  OscMessage bypass2 = new OscMessage("/track/1/fx/2/bypass");
  bypass2.add(bypass[1]); 
  osc.send(bypass2, dst);
  if(btns[1].getState()){
    //Dry amount
    OscMessage glitcherDry = new OscMessage("/track/1/fx/2/fxparam/2/value");
    glitcherDry.add(knobVal[1]); 
    osc.send(glitcherDry, dst);
    //Shift (full range)
    OscMessage glitcherShift = new OscMessage("/track/1/fx/2/fxparam/4/value");
    glitcherShift.add(map(knobVal[2], 0, 1, 0.25, 1)); 
    osc.send(glitcherShift, dst);
  }
  
  ////3. Reverse
  OscMessage bypass3 = new OscMessage("/track/1/fx/3/bypass");
  bypass3.add(bypass[2]); 
  osc.send(bypass3, dst);
  if(btns[2].getState()){
    //Wet amount: /track/1/fx/3/fxparam/1/value range:0-1
    OscMessage reverseWet = new OscMessage("/track/1/fx/3/fxparam/1/value");
    reverseWet.add(knobVal[3]); 
    osc.send(reverseWet, dst);
  }
  
  ////4. Delay
  OscMessage bypass4 = new OscMessage("/track/1/fx/4/bypass");
  bypass4.add(bypass[3]); 
  osc.send(bypass4, dst);
  if(btns[3].getState()){
    //Wet amount
    OscMessage delayWet = new OscMessage("/track/1/fx/4/fxparam/1/value");
    delayWet.add(knobVal[4]); 
    osc.send(delayWet, dst);
    println("Message sent:",delayWet, knobVal[4]);
    //Length (musical)
    OscMessage delayLength = new OscMessage("/track/1/fx/4/fxparam/5/value");
    delayLength.add(map(knobVal[5], 0, 1, 0, 0.0390625)); 
    osc.send(delayLength, dst);
    //Feedback
    OscMessage delayFb = new OscMessage("/track/1/fx/4/fxparam/6/value");
    delayFb.add(map(knobVal[6], 0, 1, 0, 0.55791545)); 
    osc.send(delayFb, dst);
  }
  
  ////5. Reverb
  OscMessage bypass5 = new OscMessage("/track/1/fx/5/bypass");
  bypass5.add(bypass[4]); 
  osc.send(bypass5, dst);
  if(btns[4].getState()){
    //Wet amount
    OscMessage reverbWet = new OscMessage("/track/1/fx/5/fxparam/1/value");
    reverbWet.add(knobVal[7]); 
    osc.send(reverbWet, dst);
    //Room size
    OscMessage reverbSize = new OscMessage("/track/1/fx/5/fxparam/3/value");
    reverbSize.add(knobVal[8]); 
    osc.send(reverbSize, dst);
  }
}
