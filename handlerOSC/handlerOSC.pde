import oscP5.*;
import netP5.*;
import themidibus.*;
import controlP5.*;

ControlP5 cp5;
MidiBus midi;
DropdownList midiInDropdown, midiOutDropdown;
Textarea logArea;

OscP5 osc;
NetAddress wekAddr;
NetAddress reaperAddr;

// FX btns
Toggle[] FXBtns = new Toggle[5];
int[] midiFX = {0, 1, 2, 3, 4}; // pitch idx

//wek training btns
Toggle[] TrainingBtns = new Toggle[6];
int[] midiTraining = {5, 6, 7}; // pitch idx


// Training knobs
float[] knobVal = new float[9];
int[] knobCCs = {75, 76, 92, 95, 10, 2, 12, 13, 7}; // Gon's controller CCs

//handPose
float[][] points = new float[21][3];
float[] origin = new float[3];
float[] dist = new float [20];
boolean[] lastTrainingBtnValue = {false, false, false};


void setup() {
  // match sketch size to default model camera setup
  size(800, 700);

  // midi to OSC
  MidiBus.list();

  //input ports
  osc = new OscP5(this, 8008); //messages HandPose-OSC and wek/outputs

  //output ports
  wekAddr = new NetAddress("127.0.0.1", 8000); // wekinator
  reaperAddr = new NetAddress("127.0.0.1", 6449);   // reaper


  midi = new MidiBus(this, 0, 1);
  cp5 = new ControlP5(this);

  // autorun Handpose
  // launch("local full path to HandPose-OSC.app");


  drawMidiMenu();
  drawFXbtns();
  drawTrainingBtns();
}


void draw() {
  background(0);
  fill(0, 255, 0);

  computeOutputs();
  drawPoints();
  sendInputOscToWekinator();
  sendTrainingOscToWekinator();
}
