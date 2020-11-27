// Copyright (C) 2020 RunwayML Examples
// 
// This file is part of RunwayML Examples.
// 
// Runway-Examples is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Runway-Examples is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAYML
// www.runwayml.com

// PoseNet Demo:
// Receive OSC messages from Runway
// Running PoseNet model
// original example by Anastasis Germanidis, adapted by George Profenza

// edited by TPR 

// import OSC libraries
import oscP5.*;
import netP5.*;
// import Runway library
import com.runwayml.*;
// reference to runway instance
RunwayOSC runway;

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
  size(600,400);
  // change default black stroke
  stroke(9,130,250);
  strokeWeight(3);
  // setup Runway
  runway = new RunwayOSC(this);
}

void draw(){
  background(0);
  // manually draw PoseNet parts
  drawPoseNetParts(data);
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
      println("leftDist ", leftDist);
      float rightDist = pow(pow(rightHand[0] - nose[0],2) + pow(rightHand[1] - nose[1],2),0.5);
      println("rightDist ", rightDist);
      
      circle(nose[0],nose[1],10);
      circle(rightHand[0],rightHand[1],10);
      circle(leftHand[0],leftHand[1],10);
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
