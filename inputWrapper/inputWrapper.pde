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

// Pose names
/*
  {ModelUtils.POSE_NOSE_INDEX, ModelUtils.POSE_LEFT_EYE_INDEX},
  {ModelUtils.POSE_LEFT_EYE_INDEX, ModelUtils.POSE_LEFT_EAR_INDEX},
  {ModelUtils.POSE_NOSE_INDEX,ModelUtils.POSE_RIGHT_EYE_INDEX},
  {ModelUtils.POSE_RIGHT_EYE_INDEX,ModelUtils.POSE_RIGHT_EAR_INDEX},
  {ModelUtils.POSE_RIGHT_SHOULDER_INDEX,ModelUtils.POSE_RIGHT_ELBOW_INDEX},
  {ModelUtils.POSE_RIGHT_ELBOW_INDEX,ModelUtils.POSE_RIGHT_WRIST_INDEX},
  {ModelUtils.POSE_LEFT_SHOULDER_INDEX,ModelUtils.POSE_LEFT_ELBOW_INDEX},
  {ModelUtils.POSE_LEFT_ELBOW_INDEX,ModelUtils.POSE_LEFT_WRIST_INDEX}, 
  {ModelUtils.POSE_RIGHT_HIP_INDEX,ModelUtils.POSE_RIGHT_KNEE_INDEX},
  {ModelUtils.POSE_RIGHT_KNEE_INDEX,ModelUtils.POSE_RIGHT_ANKLE_INDEX},
  {ModelUtils.POSE_LEFT_HIP_INDEX,ModelUtils.POSE_LEFT_KNEE_INDEX},
  {ModelUtils.POSE_LEFT_KNEE_INDEX,ModelUtils.POSE_LEFT_ANKLE_INDEX}
*/

void setup(){
  // match sketch size to default model camera setup
  size(800,700);
  // setup Runway
  runway = new RunwayOSC(this);

text( "Press 'c' to connect to Runway. Press 'c' to disconnect.", 5, 15 );
  
  
  // midi to OSC
  MidiBus.list();
  
  osc = new OscP5(this, 8001);
  loc = new NetAddress("127.0.0.1", 8000);
  osc.plug(this, "oscToMidiNote", "/midi/note");
  osc.plug(this, "oscToMidiCC", "/midi/cc");
  
  int menuWidth = 100;
  
  midi = new MidiBus(this, 0, 1);
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("inputPort")
    .setPosition(20, nextY())
    .setSize(menuWidth,20)
    .setValue("8000")
    .setAutoClear(false);
    
  cp5.addTextfield("outputPort")
    .setPosition(20, nextY())
    .setSize(menuWidth, 20)
    .setValue("8001")
    .setAutoClear(false);
    
  midiInDropdown = cp5.addDropdownList("midiIn")
    .setPosition(20, nextY())
    .setSize(menuWidth, 50);
    
    
  midiOutDropdown = cp5.addDropdownList("midiOut")
    .setPosition(20, nextY())
    .setSize(menuWidth, 50);
    
  String[] inputs = MidiBus.availableInputs();
  for (int i = 0; i < inputs.length; i++) {
    midiInDropdown.addItem(inputs[i], i);
  }
  midiInDropdown.setValue(0);
  midiInDropdown.setOpen(false);
  
  String[] outputs = MidiBus.availableOutputs();
  for (int i = 0; i < outputs.length; i++) {
    midiOutDropdown.addItem(outputs[i], i);
  }
  midiInDropdown.setValue(1);
  midiOutDropdown.setOpen(false);
  
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

void draw(){
  background(0);
  fill(0,255,0);
  // manually draw PoseNet parts
  drawPoseNetParts(data);
  text( "Press 'c' to connect to Runway. Press 'd' to disconnect.", 5, height-15 );

}

void drawPoseNetParts(JSONObject data){
  // Only if there are any humans detected
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      
      float[] nose = new float[2]; // in order to compute hand-head distance
      nose[0] = width - keypoints.getJSONArray(ModelUtils.POSE_NOSE_INDEX).getFloat(0) * width; // in order to invert image
      nose[1] = keypoints.getJSONArray(ModelUtils.POSE_NOSE_INDEX).getFloat(1) * height;
      
      float[] leftHand = new float[2];
      leftHand[0] = width - keypoints.getJSONArray(ModelUtils.POSE_LEFT_WRIST_INDEX).getFloat(0) * width;
      leftHand[1] = keypoints.getJSONArray(ModelUtils.POSE_LEFT_WRIST_INDEX).getFloat(1) * height;
      
      float[] rightHand = new float[2];
      rightHand[0] = width - keypoints.getJSONArray(ModelUtils.POSE_RIGHT_WRIST_INDEX).getFloat(0) * width;
      rightHand[1] = keypoints.getJSONArray(ModelUtils.POSE_RIGHT_WRIST_INDEX).getFloat(1) * height;
      
      float leftDist = pow(pow(leftHand[0] - nose[0],2) + pow(leftHand[1] - nose[1],2),0.5);
      float rightDist = pow(pow(rightHand[0] - nose[0],2) + pow(rightHand[1] - nose[1],2),0.5);
      
      circle(nose[0],nose[1],10);
      text( "nose", nose[0],nose[1] );
      circle(rightHand[0],rightHand[1],10);
      text( "right hand", rightHand[0],rightHand[1] );
      circle(leftHand[0],leftHand[1],10);
      text( "left hand", leftHand[0],leftHand[1] );
      
      text( "leftDist " + round(leftDist), 5, height-30 );
      text( "rightDist " + round(rightDist), 5,height-45 );


    }
  }
}

// this is called when new Runway data is available
void runwayDataEvent(JSONObject runwayData){
  // point the sketch data to the Runway incoming data 
  data = runwayData;
  
}

// this is called each time Processing connects to Runway
// Runway sends information about the current model
public void runwayInfoEvent(JSONObject info){
  println(info);
}
// if anything goes wrong
public void runwayErrorEvent(String message){
  println(message);
}

// Note: if the RunwayModel was stopped and resumed while Processing is running
// it's best to reconnect to it via OSC
void keyPressed(){
  switch(key) {
    case('c'):
      /* connect to Runway */
      runway.connect();
      break;
    case('d'):
      /* disconnect from Runway */
      runway.disconnect();
      break;
  }
}



public void Update() {
  if (midi != null) {
    midi.clearAll();
  }
  midi = new MidiBus(this, (int)midiInDropdown.getValue(), (int)midiOutDropdown.getValue());
  midi.sendNoteOn(0, 44, 127);
}

// OSC -> MIDI

public void oscToMidiNote(int note, int value) {
  log("Got OSC Note: " + note + " Velocity: " + value); 
  midi.sendNoteOn(0, note, value);
}

public void oscToMidiCC(int control, int value) {
  log("Got OSC CC: " + control + " Value: " + value);
   midi.sendControllerChange(0, control, value);
}

// MIDI -> OSC

void noteOn(int channel, int pitch, int velocity) {
  log("Got MIDI Note On: " + pitch + " Velocity: " + velocity);
  OscMessage msg = new OscMessage("/midi/note");
  msg.add(pitch);
  msg.add(velocity);
  osc.send(msg, loc);
}

void noteOff(int channel, int pitch, int velocity) {
  log("Got MIDI Note Off: " + pitch + " Velocity: " + velocity);
  OscMessage msg = new OscMessage("/midi/note");
  msg.add(pitch);
  msg.add(velocity);
  osc.send(msg, loc);
}

void controllerChange(int channel, int number, int value) {
  log("Got MIDI CC: " + number + " Velocity: " + value);
  OscMessage msg = new OscMessage("/midi/note");
  msg.add(number);
  msg.add(value);
  osc.send(msg, loc);
}

private void log(String msg) {
  println("Debug: " + msg);
  logArea.setText(msg + "\n" + logArea.getText());
}