// OSC -> MIDI
// from https://github.com/msfeldstein/MidiToOSCBridge/blob/master/MidiOSC.pde

public void oscToMidiNote(int note, int value) {
  log("Got OSC Note: " + note + " Velocity: " + value);
  midi.sendNoteOn(0, note, value);
}

public void oscToMidiCC(int control, int value) {
  log("Got OSC CC: " + control + " Value: " + value);
  midi.sendControllerChange(0, control, value);
}


// Menu

void drawMidiOSCMenu() {

  int menuWidth = 100;

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


// Update bttn

public void Update() {
  if (midi != null) {
    midi.clearAll();
  }
  midi = new MidiBus(this, (int)midiInDropdown.getValue(), (int)midiOutDropdown.getValue());
  midi.sendNoteOn(0, 44, 127);
}


//Debug

private void log(String msg) {
  println("Debug: " + msg);
  logArea.setText(msg + "\n" + logArea.getText());
}
