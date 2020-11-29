// using code from  RunwayML PoseNetFull Example and
// from https://github.com/msfeldstein/MidiToOSCBridge/blob/master/MidiOSC.pde

import oscP5.*;
import netP5.*;
import com.runwayml.*;
import themidibus.*;
import controlP5.*;

RunwayOSC runway;
ControlP5 cp5;
MidiBus midi;
DropdownList midiInDropdown, midiOutDropdown;
Textarea logArea;
OscP5 osc;
NetAddress loc;
Button[] btns = new Button[5];



// This array will hold all the humans detected
JSONObject data;


void setup() {
  // match sketch size to default model camera setup
  size(800, 700);
  // setup Runway
  runway = new RunwayOSC(this);

  // midi to OSC
  MidiBus.list();

  osc = new OscP5(this, 8001);
  loc = new NetAddress("127.0.0.1", 8000);
  osc.plug(this, "oscToMidiNote", "/midi/note");
  osc.plug(this, "oscToMidiCC", "/midi/cc");


  midi = new MidiBus(this, 0, 1);
  cp5 = new ControlP5(this);
  drawMidiOSCMenu();
  drawFXbtns();
}

void draw() {
  background(0);
  fill(0, 255, 0);
  //println(btns[0].isOn());

  // get hand to nose distances
  float[] dist = drawPoseNetParts(data);

  //get midiFX status



  if (dist!=null) {
    sendOscToWekinator(dist[0], dist[1]);
  }
  text( "press 'c' to connect to Runway. press 'd' to disconnect.", 15, height-15 );
}
