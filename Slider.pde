//Created by Liam O'Lionard 9/4/2020

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
  
  // draw(): Draws slider.
  void draw() {
    fill(white);
    noStroke();
    rect(sliderPositionX, sliderPositionY, sliderLength+handleWidth, sliderWidth);   // Draw slider bar
    rect(startPosition, sliderPositionY, handleWidth, handleWidth);      // Draw handles
    rect(endPosition, sliderPositionY, handleWidth, handleWidth);
  }
  
  // move(): Adjusts start and end handles of the slider, using mouse input.
  void move() {
    //Check if within slider range
    if (mouseX >= sliderPositionX - handleWidth && mouseX <= sliderPositionX + sliderLength + handleWidth && mouseY >= sliderPositionY && mouseY <= sliderPositionY + handleWidth)
    {
      if (mouseX >= startPosition - handleWidth && mouseX <= startPosition+handleWidth*2)
        startPosition = constrain(mouseX, sliderPositionX, endPosition-handleWidth);
      else if (mouseX >= endPosition - handleWidth && mouseX <= endPosition+handleWidth*2)
        endPosition = constrain(mouseX, startPosition+handleWidth, sliderPositionX+sliderLength);
    }
  }
  
  // getStartPercentage(): Returns percent value of the start handle along the slider.
  float getStartPercentage() {
    return ((float)startPosition-(float)sliderPositionX)/((float)sliderLength-(float)sliderPositionX);
  }
  
  // getEndPercentage(): Returns percent value of the end handle along the slider.
  float getEndPercentage() {
    return ((float)endPosition-(float)sliderPositionX)/((float)sliderLength-(float)sliderPositionX);
  }
}