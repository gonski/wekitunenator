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

// ControlP5 will automatically detect this method and will use it to forward any controlEvent triggered by a controller
// (Controller class is Toggle's parent)
void controlEvent(ControlEvent theEvent) {
  // If the event is called FX*, then send OSC to Reaper
  // Could be done also for knobs if we create Knob controllers for them
  try{
    if (theEvent.getName().startsWith("FX")){
      //maybe add: if(TrainingToggle==true)
      sendOSCtoReaper();
    }
  // throws some exceptions at the beginning but then works fine, the catch block is to avoid these exceptions
  } catch(NullPointerException e){} 
}
