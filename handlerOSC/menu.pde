void drawMidiMenu() {
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

  String[] outputs = MidiBus.availableOutputs();
  for (int i = 0; i < outputs.length; i++) {
    midiOutDropdown.addItem(outputs[i], i);
  }
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
  midi = new MidiBus(this, (int)midiInDropdown.getValue());
  midi.sendNoteOn(0, 44, 127);
}

void drawFXbtns() {

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

void drawTrainingBtns() {

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
void controlEvent(ControlEvent theEvent) {
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
