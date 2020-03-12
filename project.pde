// Load Data
ArrayList[] data;
ArrayList<String> tickers;
ArrayList<Widget> widgets;
PFont font;

void setup(){
    size(500,500);
    String[] dataToLoad = loadStrings("daily_prices1k.csv");
    font = loadFont("ArialMT-32.vlw");
    textFont(font); //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    tickers = new ArrayList<String>();
    data = new ArrayList[0]; //<>//
    loadData(dataToLoad); //<>//
    widgets = createWidgets();
}

void draw(){
  background(backgroundLight);
  drawWidgets();
}

void loadData(String[] dataToLoad){
    int addLocation = 0; //<>//
    for(String line : dataToLoad){ //<>//
        line += ","; // triggers adding dates to datapoint objects
        char[] charLine = line.toCharArray();
        String currentWord = "";
        int count = 0; //<>//
        Datapoint currdp = new Datapoint();
        
        for(char letter : charLine){ 
            if(letter != ','){
                currentWord += letter;
            } else {
                //println(currentWord);
                switch(count){ 
                    case(0):
                        int tickerLoc = tickers.indexOf(currentWord);
                        if(tickerLoc<0){
                            // Create new ticker
                            data = Arrays.copyOf(data, data.length+1);
                            data[data.length-1] = new ArrayList<Datapoint>();
                            addLocation = data.length-1;
                            tickers.add(currentWord);
                        } else {
                            // Exists
                            addLocation = tickerLoc;
                        }
                        break;
                    case(1):
                        currdp.setOpen_price(Float.valueOf(currentWord));
                        break;
                    case(2): //<>//
                        currdp.setClose_price(Float.valueOf(currentWord));
                        break;
                    case(3):
                        currdp.setAdjusted_close(Float.valueOf(currentWord));
                        break;
                    case(4): //<>//
                        currdp.setLow(Float.valueOf(currentWord));
                        break;
                    case(5):
                        currdp.setHigh(Float.valueOf(currentWord));
                        break;
                    case(6) : //<>//
                        currdp.setVolume(Integer.valueOf(currentWord));
                        break;
                    case(7):
                        try{
                        Date date = DATE_FORMAT.parse(currentWord);
                            currdp.setDate(date); //<>//
                        //  println(DATE_FORMAT.format(date));
                            break;  
                        } catch(Exception e){
                            println("Exception occured: ", e);
                        }
                }
                currentWord = "";
                count++;
            }
        }
        data[addLocation].add(currdp);
    }
}

ArrayList<Widget> createWidgets(){
    int startX = 10;
    int startY = 25;
    int wWidth = 100;
    int wHeight = 40;
    int countX = 0;
    int countY = 0;
    ArrayList<Widget> returnContent = new ArrayList<Widget>();
    for(String ticker : tickers){
      if((startY + countY)>= height-(wHeight+10)){
          countY = 0;
          countX += wWidth + 10;
      }
      returnContent.add(new Widget(startX+countX, startY+countY,wWidth, wHeight, ticker, backgroundDark,font, tickers.indexOf(ticker)));
      countY += wHeight + 10;
    }
    return returnContent;
}

void drawWidgets(){
    for(Widget widget : widgets){
        widget.draw();
    }
}

void mouseMoved(){
  int event;
  
  for(Widget widget : widgets){
    event = widget.getEvent(mouseX, mouseY);
    if(event!= EVENT_NULL){
      widget.strokeColour = color(0);
      widget.widgetColor = color(0);
    } else {
      widget.strokeColour = color(255);
      widget.widgetColor = backgroundDark;
    }
  }
}