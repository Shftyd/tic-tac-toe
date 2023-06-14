//global variables
float lineX, lineY, lineWidth, lineHeight;
//
void setup() {
  fullScreen();
  //population
  lineX = displayWidth * 1/3;
  lineY = displayHeight * 1/3;
  lineWidth = displayWidth * 1/50;
  lineHeight = displayHeight * 1/3;
}
//
void draw() {
  line(lineX, lineY, lineWidth, lineHeight);
}
//
void keyPressed() {
}
//
void mousePressed() {
}
//
//End tic tac toe
