
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

float[] drawPoseNetParts(JSONObject data) {
  // Only if there are any humans detected
  if (data != null) {
    JSONArray humans = data.getJSONArray("poses");
    //for (int h = 0; h < humans.size(); h++) {  //assume 1 human
      JSONArray keypoints = humans.getJSONArray(0);

      float[] nose = new float[2]; // in order to compute hand-head distance
      nose[0] = width - keypoints.getJSONArray(ModelUtils.POSE_NOSE_INDEX).getFloat(0) * width; // in order to invert image
      nose[1] = keypoints.getJSONArray(ModelUtils.POSE_NOSE_INDEX).getFloat(1) * height;

      float[] leftHand = new float[2];
      leftHand[0] = width - keypoints.getJSONArray(ModelUtils.POSE_LEFT_WRIST_INDEX).getFloat(0) * width;
      leftHand[1] = keypoints.getJSONArray(ModelUtils.POSE_LEFT_WRIST_INDEX).getFloat(1) * height;

      float[] rightHand = new float[2];
      rightHand[0] = width - keypoints.getJSONArray(ModelUtils.POSE_RIGHT_WRIST_INDEX).getFloat(0) * width;
      rightHand[1] = keypoints.getJSONArray(ModelUtils.POSE_RIGHT_WRIST_INDEX).getFloat(1) * height;

      float leftDist = pow(pow(leftHand[0] - nose[0], 2) + pow(leftHand[1] - nose[1], 2), 0.5);
      float rightDist = pow(pow(rightHand[0] - nose[0], 2) + pow(rightHand[1] - nose[1], 2), 0.5);
      
      float[] dist = new float[2];
      dist[0] = leftDist;
      dist[1] = rightDist;
      
      circle(nose[0], nose[1], 10);
      text( "nose", nose[0], nose[1] );
      circle(rightHand[0], rightHand[1], 10);
      text( "right hand", rightHand[0], rightHand[1] );
      circle(leftHand[0], leftHand[1], 10);
      text( "left hand", leftHand[0], leftHand[1] );

      text( "left hand to nose distance:  " + round(leftDist) + " px", 15, height-30 );
      text( "right hand to nose distance: " + round(rightDist) + " px", 15, height-45 );
    //}
     return dist;
  }
  return null;
}
