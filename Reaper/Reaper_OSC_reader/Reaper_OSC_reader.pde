/**
* Sketch to see (in console) FX param values and names from Reaper via OSC
* Sends a message when mouse is pressed to check connection
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
  ellipse(mouseX, mouseY, 10, 10);
  if(mousePressed == true) {
    sendOsc();
  }
  text("Sends mouse x position to OSC when pressed\n", 10, 30);
  text("x=" + map(mouseX, 0, width, 0, 1), 10, 80);
}

void sendOsc() {
  OscMessage msg = new OscMessage("/track/1/fx/1/fxparam/8/value"); //autotune amount
  float  value = map(mouseX, 0, width, 0, 1);
  msg.add(value); 
  oscP5.send(msg, dest);
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage msg) {
 String head = msg.addrPattern();
 println(head);
 switch(head){
   case "/track/1/fx/1/fxparam/8/value":
     println("Value:", msg.get(0).floatValue());
     break;
   case "/fxparam/last_touched/name":
     println(msg.get(0).stringValue());
     break;
   case "/fxparam/last_touched/value":
     println("Value:", msg.get(0).floatValue());
     break;
 }
}
