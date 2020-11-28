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
