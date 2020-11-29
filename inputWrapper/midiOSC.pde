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


// Menu

void drawMidiOSCMenu() {

  int menuWidth = 100;

  cp5.addTextfield("inputPort")
    .setPosition(20, nextY())
    .setSize(menuWidth, 20)
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
