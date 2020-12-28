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
  OscMessage msg = new OscMessage("/track/1/fx/1/fxparam/2/value"); // see FX PARAMS LIST
  float  value = map(mouseX, 0, width, 0.027777778, 0.3611111);
  msg.add(value); 
  oscP5.send(msg, dest);
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage msg) {
 String head = msg.addrPattern();
 println(head);
 String[] parts = head.split("/");
 switch(parts[parts.length-1]){
   case "value":
     println("Value:", msg.get(0).floatValue());
     break;
   case "bypass":
     println("Value:", msg.get(0).floatValue());
     break;
   case "name":
     println(msg.get(0).stringValue());
     break;
   //case "str":
   //  println(msg.get(0).stringValue());
   //  break;
 }
}

/**
FX PARAMETERS LIST
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
