/**
* Simple script to receive wekinator outputs and send them to Reaper
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
  // Two approaches possible: 
  // 1. directly modify specific param values (as many wek ouputs as param values)
  // 2. modify selecting effect number, param number and then value (3 wek outputs)
  // Right now implemented: approach 1
  
  //// Select fx
  //Integer fxNum = msgWek.get(0).intValue();
  //OscMessage msgFx = new OscMessage("/fx/number/str"); 
  //msgFx.add(fxNum); 
  //oscP5.send(msgFx, dest);
  
  //// Select param
  //Integer paramNum = msgWek.get(1).intValue();
  
  // Modify 2 effects
  OscMessage msg1 = new OscMessage("/track/1/fx/1/fxparam/8/value"); //autotune amount
  msg1.add(msgWek.get(0).floatValue()); 
  oscP5.send(msg1, dest);
  
  OscMessage msg2 = new OscMessage("/track/1/fx/2/fxparam/1/value"); //reverb amount (Wet)
  msg2.add(msgWek.get(1).floatValue()); 
  oscP5.send(msg2, dest);
  
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage msgWek) {
 println("Message received:",msgWek);
 sendOsc(msgWek);
}
