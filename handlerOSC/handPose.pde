/*
 
 thumb /annotations/thumb (4 * [x, y, z])
 index finger /annotations/indexFinger (4 * [x, y, z])
 middle finger /annotations/middleFinger (4 * [x, y, z])
 ring finger /annotations/ringFinger (4 * [x, y, z])
 pinky /annotations/pinky (4 * [x, y, z])
 palm base /annotations/palmBase [x, y, z]
 
 */

void computeOutputs() {
  for (int i=0; i<3; i++) {
    origin[i] = points[0][i];
  }
  for (int i=1; i<21; i++) { //first is origin
    dist[i-1] = pow(pow(origin[0] - points[i][0], 2) + pow(origin[1] - points[i][1], 2)
      + pow(origin[2] - points[i][2], 2), 0.5);
  }
}

void drawPoints() {

  for (int i=0; i<21; i++) {
    circle(width-points[i][0], points[i][1], 5);
    text(i, width-points[i][0], points[i][1]);
  }
}
