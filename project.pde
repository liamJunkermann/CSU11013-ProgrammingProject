// Load Data //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
ArrayList[] data; // data is basically an array to store more datapoint arraylists. 
// Where all the stock data for each ticker is stored in the same index as the stored ticker symbol in the ticker symbol arraylist.
ArrayList<String> tickers;
ArrayList<Widget> widgets;
// PFont font;
int screenCount;
ArrayList<Screen> screens;
ArrayList<TextPanel> textPanels;
Table stockInfo;
ArrayList<String> top100changeTickers;
ArrayList<Float> top100changePercent;
Screen homeScreen;

void setup() {
  size(1000, 500);
  String[] dataToLoad = loadStrings("daily_prices10k.csv");
  stockInfo = loadTable("stocks.csv", "header");
  font = loadFont("ArialMT-32.vlw");
  textFont(font);
  textAlign(LEFT, BOTTOM);   //Centers text on widget
  currentEvent = -1;
  tickers = new ArrayList<String>();
  data = new ArrayList[0];
  screens = new ArrayList<Screen>();
  textPanels = new ArrayList<TextPanel>();
  screenCount = -1;
  loadData(dataToLoad);
  sortData();
  graphSetup();
  widgets = createWidgets();
  homeScreen = new Screen(-1);
  top100changeTickers = new ArrayList<String>();
  top100changePercent = new ArrayList<Float>();
  calculateBiggestChange();
}

void draw() {
  if (screenCount == -1) {
    homeScreen.draw();
    printTopNumbers(20, 700, 50);  //test, feel free to move or change values, still have to make interactive on screen and change time period
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

    for (char letter : charLine) { // this loop iterates through each array until it finds a comma. Once comma is found it checks which "column" the string data is and then store that data in a new datapoint object. Once all the data is loaded (eg. the entire row is handled), it gets added to an arraylist with the rest of the datapoints for the ticker.
      if (letter != ',') {
        currentWord += letter;
      } else {
        //println(currentWord);
        switch(count) {
          case(0):// This case handles where to store the datapoint object. If its a new ticker a new location is made, otherwise we find the right location to store at.
          int tickerLoc = tickers.indexOf(currentWord);
          if (tickerLoc<0) { 
            // Create new ticker
            data = Arrays.copyOf(data, data.length+1);
            data[data.length-1] = new ArrayList<Datapoint>();
            addLocation = data.length-1;
            tickers.add(currentWord);
            screens.add(new Screen(addLocation));
            screens.get(addLocation).setTicker(tickers.get(addLocation));
            // Create Text data which can be passed to screen (or we can adapt these functions for screens?)
            // This only happens on the first occurence of a ticker
            TableRow infoRow = stockInfo.findRow(currentWord, "ticker");
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
  }
  println("Data Loaded");
}

void sortData() {
  for (ArrayList<Datapoint> tickerDps : data) {
    int n = tickerDps.size(); 
    for (int i = 0; i < n-1; i++) {
      for (int j = 0; j < n-i-1; j++) {
        if (int(easyFormat.format(tickerDps.get(j).date)) > int(easyFormat.format(tickerDps.get(j+1).date))) {
          // swap arr[j+1] and arr[
          Datapoint temp = tickerDps.get(j);
          tickerDps.set(j, tickerDps.get(j+1));
          tickerDps.set(j+1, temp);
        }
      }
    }
  }
  println("data sorted");
}


void graphSetup() {
  for (Screen screen : screens) {
    screen.graphSetup();
  }
}
ArrayList<Widget> createWidgets() {
  int X = 0;
  int startY = 0;
  int wWidth = 120;
  int wHeight = 50;
  int countY = 0;
  ArrayList<Widget> returnContent = new ArrayList<Widget>();
  for (String ticker : tickers) {
    returnContent.add(new Widget(X, startY+countY, wWidth, wHeight, ticker, backgroundDark, font, tickers.indexOf(ticker)));
    countY += wHeight;
  }
  return returnContent;
}



void drawWidgets() {
  for (Widget widget : widgets) {
    widget.draw();
  }
}


void mouseMoved() {
  int event;

  for (Widget widget : widgets) {

    // SIDEBAR SCROLLING

    if (mouseX <= widget.width)
      widget.y = (widget.height * widgets.indexOf(widget)) - mouseY * 2 + 20;
    /* 'mouseY * 2' is an arbitrary distance that thankfully gets us to the bottom of the list,
     but a more precise calculation using the size of the widgets ArrayList would be preferred. */

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
    if (screens.get(screenCount).graph.dataSelector.getEvent(mouseX, mouseY) != EVENT_NULL) {
      screens.get(screenCount).graph.dataSelector.strokeColour = color(0);
      screens.get(screenCount).graph.dataSelector.widgetColor = color(0);
    } else {
      screens.get(screenCount).graph.dataSelector.strokeColour = color(255);
      screens.get(screenCount).graph.dataSelector.widgetColor = backgroundDark;
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
    } else if (screens.get(screenCount).graph.dataSelector.getEvent(mouseX, mouseY) == -2) {
      screens.get(screenCount).graph.showDetail *= -1;
    }
  }
}

void calculateBiggestChange() {
  float startPrice;
  float endPrice;
  float percentChange;
  ArrayList<Datapoint> stockData = new ArrayList<Datapoint>();
  for (int i = 0; i < data.length; i++) {
    stockData = data[i];
    startPrice = stockData.get(0).open_price;
    endPrice = stockData.get(stockData.size() -1).adjusted_close;
    percentChange = (endPrice - startPrice)/100;
    if (top100changePercent.size() < 100) {
      top100changePercent.add(percentChange);
      top100changeTickers.add(tickers.get(i));
    }
    if ((abs(top100changePercent.get(top100changePercent.size()-1))< percentChange) && top100changePercent.size() >= 100) {
      top100changePercent.set(top100changePercent.size()-1, percentChange);
      top100changeTickers.set(top100changeTickers.size()-1, tickers.get(i));
    }
  }
}

void printTopNumbers(int numberOfStocks, int x, int y) {
  text("Top " +numberOfStocks + " Biggest Overall Changes", x, y-20);
  for (int i =0; i < numberOfStocks; i++) {
    text(top100changeTickers.get(i)+ ": " + top100changePercent.get(i) + "%", x, y);
    y+= 20;
  }
}
