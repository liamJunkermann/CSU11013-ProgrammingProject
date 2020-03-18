class Widget {
  int x, y, width, height;
  String label; int event;
  color widgetColor, labelColor, strokeColour;
  PFont widgetFont;
  int coloured = 15;
  Widget(int x,int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event){
    this.x=x; this.y=y; this.width = width; this.height= height;
    this.label=label; this.event=event;
    this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor= textColor;
    strokeColour = color(255);
  }
  void draw(){
    stroke(strokeColour);
    fill(widgetColor);
    rect(x,y,width,height);
    fill(labelColor);
    textSize(20);
    
    text(label, (x+width/2)-(textWidth(label)/2), y+height-12);
  }
  int getEvent(int mX, int mY){
     //<>//
    if(mX>x && mX < x+width && mY >y && mY <y+height){
        return event;
      } else {
        return EVENT_NULL;
      }
  }
}
