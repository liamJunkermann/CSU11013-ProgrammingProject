// Load Data //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
ArrayList[] data; // data is basically an array to store more datapoint arraylists. 
                  // Where all the stock data for each ticker is stored in the same index as the stored ticker symbol in the ticker symbol arraylist.
ArrayList<String> tickers;
ArrayList<Widget> widgets;
PFont font;
int screenCount;
ArrayList<Screen> screens;
ArrayList<TextPanel> textPanels;
Table stockInfo;

void setup() {
  size(500, 500);
  String[] dataToLoad = loadStrings("daily_prices1k.csv");
  stockInfo = loadTable("stocks.csv","header");
  font = loadFont("ArialMT-32.vlw");
  textFont(font); //<>// //<>// //<>// //<>//
  tickers = new ArrayList<String>();
  data = new ArrayList[0];
  screens = new ArrayList<Screen>();
  textPanels = new ArrayList<TextPanel>();
  screenCount = -1;
  loadData(dataToLoad);
  widgets = createWidgets();
  setScreenTicker();
}

void draw() {
  if (screenCount == -1) {
    background(backgroundLight);
    drawWidgets();
  } else {
    screens.get(screenCount).draw();
  }
}

void loadData(String[] dataToLoad) {
  int addLocation = 0;
  for (String line : dataToLoad) {
    line += ","; // triggers adding dates to datapoint objects
    char[] charLine = line.toCharArray();
    String currentWord = "";
    int count = 0;
    Datapoint currdp = new Datapoint();

    for (char letter : charLine) { 
      if (letter != ',') {
        currentWord += letter;
      } else {
        //println(currentWord);
        switch(count) { 
          case(0):
          int tickerLoc = tickers.indexOf(currentWord);
          if (tickerLoc<0) {
            // Create new ticker
            data = Arrays.copyOf(data, data.length+1);
            data[data.length-1] = new ArrayList<Datapoint>();
            addLocation = data.length-1;
            tickers.add(currentWord);
            // Create Text data which can be passed to screen (or we can adapt these functions for screens?)
            // This only happens on the first occurence of a ticker
            TableRow infoRow = stockInfo.findRow(currentWord, "ticker"); //<>//
            textPanels.add(new TextPanel(infoRow.getString("ticker"), infoRow.getString("exchange"), infoRow.getString("name"), infoRow.getString("sector"), infoRow.getString("industry"), font));
            // End of text panel update
          } else {
            // Exists
            addLocation = tickerLoc;
          }
          break;
          case(1):
          currdp.setOpen_price(Float.valueOf(currentWord));
          break;
          case(2):
          currdp.setClose_price(Float.valueOf(currentWord));
          break;
          case(3):
          currdp.setAdjusted_close(Float.valueOf(currentWord));
          break;
          case(4):
          currdp.setLow(Float.valueOf(currentWord));
          break;
          case(5):
          currdp.setHigh(Float.valueOf(currentWord));
          break;
          case(6) :
          currdp.setVolume(Integer.valueOf(currentWord));
          break;
          case(7):
          try {
            Date date = DATE_FORMAT.parse(currentWord);
            currdp.setDate(date);
            //  println(DATE_FORMAT.format(date));
            break;
          } 
          catch(Exception e) {
            println("Exception occured: ", e);
          }
        }
        currentWord = "";
        count++;
      }
    }
    data[addLocation].add(currdp);
    init_screens(currdp);
  }
}

ArrayList<Widget> createWidgets() {
  int startX = 10;
  int startY = 25;
  int wWidth = 100;
  int wHeight = 40;
  int countX = 0;
  int countY = 0;
  ArrayList<Widget> returnContent = new ArrayList<Widget>();
  for (String ticker : tickers) {
    if ((startY + countY)>= height-(wHeight+10)) {
      countY = 0;
      countX += wWidth + 10;
    }
    returnContent.add(new Widget(startX+countX, startY+countY, wWidth, wHeight, ticker, backgroundDark, font, tickers.indexOf(ticker)));
    countY += wHeight + 10;
  }
  return returnContent;
}

void drawWidgets() {
  for (Widget widget : widgets) {
    widget.draw();
  }
}

void init_screens(Datapoint stock) {
  screens.add(new Screen (stock));
}
void setScreenTicker() {
  for (int i =0; i < tickers.size(); i ++) {
    screens.get(i).setTicker(tickers.get(i));
  }
}


void mouseMoved() {
  int event;

  for (Widget widget : widgets) {
    event = widget.getEvent(mouseX, mouseY);
    if (event!= EVENT_NULL) {
      widget.strokeColour = color(0);
      widget.widgetColor = color(0);
    } else {
      widget.strokeColour = color(255);
      widget.widgetColor = backgroundDark;
    }
  }
  if (screenCount != EVENT_NULL) {
    if (screens.get(screenCount).backButton.getEvent(mouseX, mouseY) != EVENT_NULL) {
      screens.get(screenCount).backButton.strokeColour = color(0);
      screens.get(screenCount).backButton.widgetColor = color(0);
    } else {
      screens.get(screenCount).backButton.strokeColour = color(255);
      screens.get(screenCount).backButton.widgetColor = backgroundDark;
    }
  }
}

void mousePressed() {
  int event;
  for (Widget widget : widgets) {
    event = widget.getEvent(mouseX, mouseY);
    if (event != EVENT_NULL) {
      screenCount = event;
    }
  }
  if (screenCount!= EVENT_NULL) {
    if (screens.get(screenCount).backButton.getEvent(mouseX, mouseY) == 1) {
      screenCount = EVENT_NULL;
    }
  }
}
