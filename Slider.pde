public class Slider {
  int sliderLength;
  int sliderPositionX;
  int sliderPositionY;
  int startPosition;
  int endPosition;
  int sliderWidth = 6;
  int handleWidth = 15;
  
  Slider(int positionX, int positionY, int length) {
     sliderPositionX = positionX;
     sliderPositionY = positionY;
     sliderLength = length-handleWidth;
     startPosition = sliderPositionX;
     endPosition = sliderPositionX + sliderLength;
  }
  
  void draw() {
    fill(white);
    noStroke();
    rect(sliderPositionX, sliderPositionY, sliderLength, sliderWidth);   // Draw slider bar
    rect(startPosition, sliderPositionY, handleWidth, handleWidth);      // Draw handles
    rect(endPosition, sliderPositionY, handleWidth, handleWidth);
  }
  
  void move() {
    //Check if within slider range
    if (mouseX <= sliderPositionX && mouseX >= sliderPositionX + sliderLength && mouseY >= sliderPositionY && mouseY <= sliderPositionY + handleWidth)
    {
      //TODO: change slider handle positions when clicked with the mouse;
      //startPosition = constrain(mouseX, sliderPositionX, endPosition-handleWidth);
      //endPosition = constrain(mouseX, startPosition+handleWidth, sliderPositionX+sliderLength);
    }
  }
  
  // Use these functions to calculate what percentage ranges of an arrayList to access.
  
  float getStartPercentage() {
    return (startPosition-sliderPositionX)/(sliderLength-sliderPositionX);
  }
  
  
  float getEndPercentage() {
    return (endPosition-sliderPositionX)/(sliderLength-sliderPositionX);
  }
}