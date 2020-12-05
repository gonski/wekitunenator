/**
* Sketch to receive wekinator outputs and send them to Reaper
**/
/**
FX PARAMETERS COMPLETE LIST
1. Autotune 
Bypass: /track/1/fx/1/bypass 0/1
Presets (scales): /track/1/fx/1/fxparam/2/value range:0.027777778-0.3611111 (chromatic + 12 major scales)

2. Glitcher 
Bypass: /track/1/fx/2/bypass 0/1
Dry amount: /track/1/fx/2/fxparam/2/value range:0-1
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

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

PFont f;

void setup() {
  f = createFont("Courier", 16);
  textFont(f);

  size(640, 480, P2D);
  noStroke();
  smooth();
  
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  dest = new NetAddress("127.0.0.1",6449);
  
}

void draw() {
  background(0);
  fill(255);
  text("Receives OSC from wekinator\nSends them to port 6449 (Reaper)", 10, 30);
}

void sendOsc(OscMessage msgWek) {
  // Directly modify specific param values (as many wek ouputs as param values)
  
  ////1. Autotune
  //Bypass: /track/1/fx/1/bypass 0/1
  OscMessage bypass1 = new OscMessage("/track/1/fx/1/bypass");
  bypass1.add(msgWek.get(0).floatValue()); 
  oscP5.send(bypass1, dest);
  if(msgWek.get(0).floatValue()==1){
    //Presets (scales): /track/1/fx/1/fxparam/2/value range:0.027777778-0.3611111 (chromatic + 12 major scales)
    OscMessage autotunePresets = new OscMessage("/track/1/fx/1/fxparam/2/value");
    autotunePresets.add(map(msgWek.get(1).floatValue(), 0, 1, 0.027777778, 0.3611111)); 
    oscP5.send(autotunePresets, dest);
  }
  
  ////2. Glitcher
  //Bypass: /track/1/fx/2/bypass 0/1
  OscMessage bypass2 = new OscMessage("/track/1/fx/2/bypass");
  bypass2.add(msgWek.get(2).floatValue()); 
  oscP5.send(bypass2, dest);
  if(msgWek.get(2).floatValue()==1){
    //Dry amount: /track/1/fx/2/fxparam/2/value range:0-1
    OscMessage glitcherDry = new OscMessage("/track/1/fx/1/fxparam/2/value");
    glitcherDry.add(msgWek.get(3).floatValue()); 
    oscP5.send(glitcherDry, dest);
    //Shift (full range): /track/1/fx/2/fxparam/4/value range:0.25/1
    OscMessage glitcherShift = new OscMessage("/track/1/fx/2/fxparam/4/value");
    glitcherShift.add(map(msgWek.get(4).floatValue(), 0, 1, 0.25, 1)); 
    oscP5.send(glitcherDry, dest);
  }
  
  //3. Reverse
  //Bypass: /track/1/fx/3/bypass 0/1
  OscMessage bypass3 = new OscMessage("/track/1/fx/3/bypass");
  bypass3.add(msgWek.get(5).floatValue()); 
  oscP5.send(bypass3, dest);
  if(msgWek.get(5).floatValue()==1){
    //Wet amount: /track/1/fx/3/fxparam/1/value range:0-1
    OscMessage reverseWet = new OscMessage("/track/1/fx/3/fxparam/1/value");
    reverseWet.add(msgWek.get(6).floatValue()); 
    oscP5.send(reverseWet, dest);
  }
  
  //4. Delay
  //Bypass: /track/1/fx/4/bypass 0/1
  OscMessage bypass4 = new OscMessage("/track/1/fx/4/bypass");
  bypass4.add(msgWek.get(7).floatValue()); 
  oscP5.send(bypass4, dest);
  if(msgWek.get(7).floatValue()==1){
    //Wet amount: /track/1/fx/4/fxparam/1/value range:0-1
    OscMessage delayWet = new OscMessage("//track/1/fx/4/fxparam/1/value");
    delayWet.add(msgWek.get(8).floatValue()); 
    oscP5.send(delayWet, dest);
    //Length (musical): /track/1/fx/4/fxparam/5/value range:0-0.0390625
    OscMessage delayLength = new OscMessage("//track/1/fx/4/fxparam/5/value");
    delayLength.add(map(msgWek.get(9).floatValue(), 0, 1, 0, 0.0390625)); 
    oscP5.send(delayLength, dest);
    //Feedback: /track/1/fx/4/fxparam/6/value range:0-0.55791545
    OscMessage delayFb = new OscMessage("//track/1/fx/4/fxparam/6/value");
    delayFb.add(map(msgWek.get(10).floatValue(), 0, 1, 0, 0.55791545)); 
    oscP5.send(delayFb, dest);
  }
  
  //5. Reverb
  //Bypass: /track/1/fx/5/bypass 0/1
  OscMessage bypass5 = new OscMessage("/track/1/fx/5/bypass");
  bypass5.add(msgWek.get(11).floatValue()); 
  oscP5.send(bypass5, dest);
  if(msgWek.get(11).floatValue()==1){
    //Wet amount: /track/1/fx/5/fxparam/1/value range:0-1
    OscMessage reverbWet = new OscMessage("/track/1/fx/5/fxparam/1/value");
    reverbWet.add(msgWek.get(12).floatValue()); 
    oscP5.send(reverbWet, dest);
    //Room size: /track/1/fx/5/fxparam/3/value range:0-1
    OscMessage reverbSize = new OscMessage("/track/1/fx/5/fxparam/3/value");
    reverbSize.add(msgWek.get(13).floatValue()); 
    oscP5.send(reverbSize, dest);
  }
  
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage msgWek) {
 println("Message received:",msgWek);
 sendOsc(msgWek);
}
