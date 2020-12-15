// using code from  RunwayML PoseNetFull Example and
// from https://github.com/msfeldstein/MidiToOSCBridge/blob/master/MidiOSC.pde

import oscP5.*;
import netP5.*;
import themidibus.*;
import controlP5.*;

ControlP5 cp5;
MidiBus midi;
DropdownList midiInDropdown, midiOutDropdown;
Textarea logArea;
OscP5 osc;
NetAddress loc;
NetAddress dst;

// FX btns
Toggle[] btns = new Toggle[5];
int[] midiFX = {0, 1, 2, 3, 4};

// Training knobs
float[] knobVal = new float[9];
int[] knobCCs = {75, 76, 92, 95, 10, 2, 12, 13, 7}; // Gon's controller CCs

//handPose
float[][] points = new float[21][3];
float[] origin = new float[3];
float[] dist = new float [20];

// This array will hold all the humans detected

// OSC wekinator ports
int inputPort = 8008;
int outputPort = 8000;

void setup() {
  // match sketch size to default model camera setup
  size(800, 700);

  // midi to OSC
  MidiBus.list();

  osc = new OscP5(this, inputPort); //input
  loc = new NetAddress("127.0.0.1", outputPort); // output
  // OSC Reaper port (destination)
  dst = new NetAddress("127.0.0.1",6449);


  midi = new MidiBus(this, 0, 1);
  cp5 = new ControlP5(this);

  drawMidiOSCMenu();
  drawFXbtns();
}

void draw() {
  background(0);
  fill(0, 255, 0);

  computeOutputs();
  drawPoints();
  sendOscToWekinator();
}
