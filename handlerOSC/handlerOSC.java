import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import themidibus.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class handlerOSC extends PApplet {






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
//int[] knobCCs = {75, 76, 92, 95, 10, 2, 12, 13, 7}; // MIDIcontroller1 CCs
int[] knobCCs = {48,49,50,51,52,53,54,55}; // MIDIcontroller2 CCs


//handPose
float[][] points = new float[21][3];
float[] origin = new float[3];
float[] dist = new float [20];
boolean[] lastTrainingBtnValue = {false, false, false};


public void setup() {
  // match sketch size to default model camera setup
  

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


public void draw() {
  background(0);
  fill(0, 255, 0);

  computeOutputs();
  drawPoints();
  sendInputOscToWekinator();
  sendTrainingOscToWekinator();
}
public void noteOn(int channel, int pitch, int velocity) {

  // FX
  for (int i=0; i<midiFX.length; i++) {
    if (midiFX[i] == pitch) {
      if (FXBtns[i].getState()) {
        FXBtns[i].setState(false);
      } else {
        FXBtns[i].setState(true);
      }
    }
  }


  //Training
  for (int i=0; i<midiTraining.length; i++) {
    if (midiTraining[i] == pitch) {
      if (TrainingBtns[i].getState()) {
        TrainingBtns[i].setState(false);
      } else {
        TrainingBtns[i].setState(true);
      }
    }
  }
}

// Get knobs MIDI
public void controllerChange(int channel, int number, int value) {
  //println("Got MIDI CC: " + number + " Velocity: " + value);
  for (int i=0; i<knobCCs.length; i++) {
    if (knobCCs[i] == number) {
      knobVal[i]=map(value, 0, 127, 0, 1);
      //println("Knob " + i + " " + knobVal[i]);
    }
  }
  sendOscMidi2Reaper();
  sendOutputOscToWekinator();
}
public void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/landmarks")==true) {

    int k = -1;
    for (int i=0; i<3*21; i++) {
      if (i%3 == 0) {
        k++;
      }
      points[k][i%3] = msg.get(i).floatValue();
    }
    // get wekinator outputs and send them to reaper
  } else if (msg.checkAddrPattern("/wek/outputs")==true) {
    sendOscWek2Reaper(msg);
  }
}
/*
 
 thumb /annotations/thumb (4 * [x, y, z])
 index finger /annotations/indexFinger (4 * [x, y, z])
 middle finger /annotations/middleFinger (4 * [x, y, z])
 ring finger /annotations/ringFinger (4 * [x, y, z])
 pinky /annotations/pinky (4 * [x, y, z])
 palm base /annotations/palmBase [x, y, z]
 
 */

public void computeOutputs() {
  for (int i=0; i<3; i++) {
    origin[i] = points[0][i];
  }
  for (int i=1; i<21; i++) { //first is origin
    dist[i-1] = pow(pow(origin[0] - points[i][0], 2) + pow(origin[1] - points[i][1], 2)
      + pow(origin[2] - points[i][2], 2), 0.5f);
  }
}

public void drawPoints() {

  for (int i=0; i<21; i++) {
    circle(width-points[i][0], points[i][1], 5);
    text(i, width-points[i][0], points[i][1]);
  }
}

public void drawMidiMenu() {
  // from https://github.com/msfeldstein/MidiToOSCBridge/blob/master/MidiOSC.pde

  int menuWidth = 100;

  midiInDropdown = cp5.addDropdownList("midiIn")
    .setPosition(20, nextY())
    .setSize(menuWidth, 50);

  String[] inputs = MidiBus.availableInputs();
  for (int i = 0; i < inputs.length; i++) {
    midiInDropdown.addItem(inputs[i], i);
  }
  midiInDropdown.setValue(0);
  midiInDropdown.setOpen(false);
  midiInDropdown.setValue(1);

  cp5.addButton("Update")
    .setValue(0)
    .setPosition(20, nextY())
    .setSize(menuWidth, 20);

  logArea = cp5.addTextarea("Logs")
    .setPosition(20, nextY())
    .setSize(200, 200);
}



int y = 20;
private int nextY() {
  int tempY = y;
  y += 50;
  return tempY;
}


// Update bttn

public void Update() {
  if (midi != null) {
    midi.clearAll();
  }
  midi = new MidiBus(this, (int)midiInDropdown.getValue(),0);
  midi.sendNoteOn(0, 44, 127);
}

public void drawFXbtns() {

  int btnWidth = 50;
  float x1 = width/3;
  int y = 20;

  FXBtns[0] = cp5.addToggle("FX1")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  FXBtns[1] = cp5.addToggle("FX2")
    .setValue(false)
    .setPosition(x1 + 2 + btnWidth, y)
    .setSize(btnWidth, btnWidth);

  FXBtns[2] = cp5.addToggle("FX3")
    .setValue(false)
    .setPosition(x1 + 2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  FXBtns[3] = cp5.addToggle("FX4")
    .setValue(false)
    .setPosition(x1+ 3*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  FXBtns[4] = cp5.addToggle("FX5")
    .setValue(false)
    .setPosition(x1+ 4*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}

public void drawTrainingBtns() {

  int btnWidth = 50;
  float x1 = width/2-btnWidth-20;
  int y = height- btnWidth - 30;

  TrainingBtns[0] = cp5.addToggle("rec")
    .setValue(false)
    .setPosition(x1, y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[1] = cp5.addToggle("train")
    .setValue(false)
    .setPosition(x1+(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);

  TrainingBtns[2] = cp5.addToggle("run")
    .setValue(false)
    .setPosition(x1 +2*(2 + btnWidth), y)
    .setSize(btnWidth, btnWidth);
}


// ControlP5 will automatically detect this method and will use it to forward any controlEvent triggered by a controller
// (Controller class is Toggle's parent)
public void controlEvent(ControlEvent theEvent) {
  // If the event is called FX*, then send OSC to Reaper
  // Could be done also for knobs if we create Knob controllers for them
  try {
    if (theEvent.getName().startsWith("FX")) {
      //maybe add: if(TrainingToggle==true)
      sendOscMidi2Reaper();
      sendOutputOscToWekinator();
    }
    // throws some exceptions at the beginning but then works fine, the catch block is to avoid these exceptions
  }
  catch(NullPointerException e) {
  }
}
public void sendInputOscToWekinator() {
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



public void sendTrainingOscToWekinator() {
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

public void sendOutputOscToWekinator() {
  OscMessage msg = new OscMessage("/wekinator/control/outputs");
  
  for (int i=0; i<knobCCs.length; i++) {
    msg.add((float)knobVal[i]);
  }
  osc.send(msg, wekAddr); // total 5 FX  + 20 dist + 2 xy origin = 27
}



public void sendOscWek2Reaper(OscMessage msgWek) {
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
    autotunePresets.add(map(msgWek.get(0).floatValue(), 0, 1, 0.027777778f, 0.3611111f));
    osc.send(autotunePresets, reaperAddr);
  }

  ////2. Glitcher
  if (FXBtns[1].getState()) {
    //Shift (full range): /track/1/fx/2/fxparam/4/value range:0.25/1
    OscMessage glitcherShift = new OscMessage("/track/1/fx/2/fxparam/4/value");
    glitcherShift.add(map(msgWek.get(1).floatValue(), 0, 1, 0.25f, 1));
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
    delayLength.add(map(msgWek.get(4).floatValue(), 0, 1, 0, 0.0390625f));
    osc.send(delayLength, reaperAddr);
    //Feedback: /track/1/fx/4/fxparam/6/value range:0-0.55791545
    OscMessage delayFb = new OscMessage("/track/1/fx/4/fxparam/6/value");
    delayFb.add(map(msgWek.get(5).floatValue(), 0, 1, 0, 0.55791545f));
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

public void sendOscMidi2Reaper() {
  ////1. Autotune
  OscMessage bypass1 = new OscMessage("/track/1/fx/1/bypass");
  bypass1.add(FXBtns[0].getValue());
  osc.send(bypass1, reaperAddr);
  if (FXBtns[0].getState()) {
    //Presets (scales)
    OscMessage autotunePresets = new OscMessage("/track/1/fx/1/fxparam/2/value");
    autotunePresets.add(map(knobVal[0], 0, 1, 0.027777778f, 0.3611111f));
    osc.send(autotunePresets, reaperAddr);
  }

  ////2. Glitcher
  OscMessage bypass2 = new OscMessage("/track/1/fx/2/bypass");
  bypass2.add(FXBtns[1].getValue());
  osc.send(bypass2, reaperAddr);
  if (FXBtns[1].getState()) {
    //Shift (full range)
    OscMessage glitcherShift = new OscMessage("/track/1/fx/2/fxparam/4/value");
    glitcherShift.add(map(knobVal[1], 0, 1, 0.25f, 1));
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
    delayLength.add(map(knobVal[4], 0, 1, 0, 0.0390625f));
    osc.send(delayLength, reaperAddr);
    //Feedback
    OscMessage delayFb = new OscMessage("/track/1/fx/4/fxparam/6/value");
    delayFb.add(map(knobVal[5], 0, 1, 0, 0.55791545f));
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
  public void settings() {  size(800, 700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "handlerOSC" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
