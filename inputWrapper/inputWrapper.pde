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


// This array will hold all the humans detected
JSONObject data;


void setup() {
  // match sketch size to default model camera setup
  size(800, 700);
  // setup Runway
  runway = new RunwayOSC(this);

  text( "Press 'c' to connect to Runway. Press 'c' to disconnect.", 5, 15 );


  // midi to OSC
  MidiBus.list();

  osc = new OscP5(this, 8001);
  loc = new NetAddress("127.0.0.1", 8000);
  osc.plug(this, "oscToMidiNote", "/midi/note");
  osc.plug(this, "oscToMidiCC", "/midi/cc");

  drawMidiOSCMenu();
}

void draw() {
  background(0);
  fill(0, 255, 0);
  // manually draw PoseNet parts
  float[] dist = drawPoseNetParts(data);
  sendOscToWekinator(dist[0], dist[1]);
  text( "press 'c' to connect to Runway. press 'd' to disconnect.", 15, height-15 );
}
