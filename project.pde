// Load Data //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
ArrayList<String> sectorTickers;
ArrayList<Float> sectorPercents;
ArrayList<String> sectors;
ArrayList<String> dateTickers;
ArrayList<Float> datePercents;
ArrayList<String> datesList;
Screen homeScreen;
Screen dateFilterScreen;
String sectorQuery;
int minDate;
int maxDate;

void setup() {
  size(1000, 500);
  background(backgroundLight);
  font = loadFont("ArialMT-32.vlw");
  textFont(font);
  textAlign(LEFT, BOTTOM);   //Centers text on widget
  fill(textColor);
  text("Loading...", width/2-(textWidth("Loading...")/2), height/2);
  sectors = new ArrayList<String>();
  datesList = new ArrayList<String>();
  sectorQuery = "ALL";
  String[] dataToLoad = loadStrings("daily_prices10k.csv");
  stockInfo = loadTable("stocks.csv", "header");
  currentEvent = -1;
  tickers = new ArrayList<String>();
  data = new ArrayList[0];
  screens = new ArrayList<Screen>();
  textPanels = new ArrayList<TextPanel>();
  screenCount = -1;
  loadData(dataToLoad, false);
  sortData();
  graphSetup();
  widgets = createWidgets();
  homeScreen = new Screen(-1);
  dateFilterScreen = new Screen(-2);
  top100changeTickers = new ArrayList<String>();
  top100changePercent = new ArrayList<Float>();
  sectorTickers = new ArrayList<String>();
  sectorPercents =  new ArrayList<Float>();
  dateTickers = new ArrayList<String>();
  datePercents =  new ArrayList<Float>();
  calculateBiggestChange(sectorQuery);
  sortList(top100changePercent, top100changeTickers);
  sortDates();
  minDate =0;
  maxDate = datesList.size()-1;
  calculateChangeDates(minDate, maxDate);
}

void draw() {
  if (screenCount == -1) {
    homeScreen.draw();
  } else if (screenCount == -2) {
    dateFilterScreen.draw();
  } else {
    screens.get(screenCount).draw();
  }
}

void loadData(String[] dataToLoad, boolean header) {
  if (header) {
    // skip line 1
    dataToLoad[0] = "";
  }
  int addLocation = 0;
  for (String line : dataToLoad) {
    if (line.length()>0) {

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
              String sector1 = infoRow.getString("sector");
              sectors.add(sector1);
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
              String year = yearFormat.format(date).toString();
              datesList.add(year);
              currdp.setYear(year);
              println(year);
              // println(DATE_FORMAT.format(date));
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

void sortDates() {
  Set<String> set = new HashSet<String>(datesList);
  datesList.clear();
  datesList.addAll(set);

  if (datesList!=null) {
    for (int index=0; index < datesList.size() -1; index++) {
      int minimumIndex = index;
      for (int index2 = index + 1; index2 < datesList.size(); index2++) {
        if (parseInt(datesList.get(index2)) < parseInt(datesList.get(minimumIndex))) {
          minimumIndex = index2;
          String temp = datesList.get(index);
          datesList.set(index, datesList.get(minimumIndex));
          datesList.set(minimumIndex, temp);
        }
      }
    }
    println("dates sorted");
  }
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
      widget.y = (widget.height * widgets.indexOf(widget)) - mouseY * 3 + 100;
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

  if (screenCount != EVENT_NULL && screenCount != -2) {
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


void mouseDragged() {
  if (screenCount != EVENT_NULL&& screenCount != -2) {
    screens.get(screenCount).slider.move();
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
  if (screenCount == EVENT_NULL) {
    if (homeScreen.dateFilter.getEvent(mouseX, mouseY) == -11) {
      println("pressed");
      screenCount = -2;
    }
  }

  for (int i =0; i < homeScreen.filterButtons.size(); i++) {
    if (homeScreen.filterButtons.get(i).getEvent(mouseX, mouseY) != EVENT_NULL) {
      calculateBiggestChange(homeScreen.filterButtons.get(i).label);
      sectorQuery = homeScreen.filterButtons.get(i).label;
    }
  }

  if (screenCount!= EVENT_NULL && screenCount != -2) {
    screens.get(screenCount).slider.move();
    if (screens.get(screenCount).backButton.getEvent(mouseX, mouseY) == 1) {
      screenCount = EVENT_NULL;
    } else if (screens.get(screenCount).graph.dataSelector.getEvent(mouseX, mouseY) == -2) {
      screens.get(screenCount).graph.showDetail *= -1;
    }
  }
  if (screenCount == -2) {
    if (dateFilterScreen.backButton.getEvent(mouseX, mouseY) == 1) {
      screenCount = EVENT_NULL;
    }
    for (int i =0; i < dateFilterScreen.yearButtons.size(); i++) {
      if (dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) < -1 && dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) > -6) {
        minDate = findIndex(dateFilterScreen.yearButtons.get(i).label);
        calculateChangeDates(minDate, maxDate);
      } else if (dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) < -6 && dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) > -10) {
        maxDate = findIndex(dateFilterScreen.yearButtons.get(i).label);
        calculateChangeDates(minDate, maxDate);
      } else if (dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) == -10) {
        if (minDate > 0) {
          minDate --;
          calculateChangeDates(minDate, maxDate);
        }
      } else if (dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) == -11) {
        if (minDate < datesList.size() && minDate < maxDate) {
          minDate ++;
          calculateChangeDates(minDate, maxDate);
        }
      } else if (dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) == -12) {
        if (maxDate > 0 && maxDate > minDate) {
          maxDate--;
          calculateChangeDates(minDate, maxDate);
        }
      } else if (dateFilterScreen.yearButtons.get(i).getEvent(mouseX, mouseY) == -13) {
        if (maxDate < datesList.size()) {
          maxDate ++;
          calculateChangeDates(minDate, maxDate);
        }
      }
    }
  }
}


void calculateBiggestChange(String sector) {
  sectorTickers = new ArrayList<String>();
  sectorPercents =  new ArrayList<Float>();
  float startPrice;
  float endPrice;
  float percentChange;
  ArrayList<Datapoint> stockData = new ArrayList<Datapoint>();

  for (int i = 0; i < data.length; i++) {
    stockData = data[i];
    startPrice = stockData.get(0).open_price;
    endPrice = stockData.get(stockData.size() -1).adjusted_close;
    percentChange = (endPrice - startPrice)/100;
    if (sector.equals("ALL")) {
      if (top100changePercent.size() < 100) {
        top100changePercent.add(percentChange);
        top100changeTickers.add(tickers.get(i));
      }
      if ((abs(top100changePercent.get(top100changePercent.size()-1))< percentChange) && top100changePercent.size() >= 100) {
        top100changePercent.set(top100changePercent.size()-1, percentChange);
        top100changeTickers.set(top100changeTickers.size()-1, tickers.get(i));
      }
    } else {
      if (sectors.get(i).equals(sector)) {

        sectorPercents.add(percentChange);
        sectorTickers.add(tickers.get(i));
      }
    }
  }
}


void printTopNumbers(int numberOfStocks, int x, int y, String sector) {
  if (sector.equals("ALL")) {
    textAlign(CENTER, BOTTOM);
    text("Top " +numberOfStocks + " Biggest Overall Changes", x+100, y-30);
    textAlign(LEFT, BOTTOM);
    for (int i =0; i < numberOfStocks; i++) {
      fill(textColor);
      text(top100changeTickers.get(i) + ":", x, y);
      fill((top100changePercent.get(i) > 0) ? green : red); // The percentage is displayed green if positive, red if negative.
      text(top100changePercent.get(i) + "%", x + textWidth(top100changeTickers.get(i))+10, y);
      y+= 20;
    }
  } else {
    sortList(sectorPercents, sectorTickers);
    textAlign(CENTER, BOTTOM);
    text("Changes in " + sector + " Sector", x+100, y-30);
    textAlign(LEFT, BOTTOM);
    if (sectorPercents.size() == 0)
      text("No data available.", x, y);
    for (int j= 0; j < sectorPercents.size(); j++) {
      fill(textColor);
      text(sectorTickers.get(j) + ":", x, y); 
      fill((sectorPercents.get(j) > 0) ? green : red); // The percentage is displayed green if positive, red if negative.
      text(sectorPercents.get(j) + "%", x + textWidth(sectorTickers.get(j))+10, y);
      y+= 20;
    }
  }
}

void printTopNumbersDates(int x, int y) {
  text("Changes between " + datesList.get(minDate) + "and " + datesList.get(maxDate), x, y-20);
  for (int i = 0; i < datePercents.size(); i++) {
    text(dateTickers.get(i) + ":", x, y); 
    fill((datePercents.get(i) > 0) ? green : red);
    text(datePercents.get(i) + "%", x + 100, y);
    y+= 20;
  }
  if (datePercents.size() == 0) {
    text("No data between these dates", x, y);
  }
}


void sortList(ArrayList<Float> percents, ArrayList<String> tickersList) {
  if (percents!=null) {
    for (int index=0; index< percents.size() -1; index++) {
      int minimumIndex = index;
      for (int index2=index+1; index2<percents.size(); index2++) {
        if (abs(percents.get(index2)) > abs(percents.get(minimumIndex)))
          minimumIndex = index2;
      }
      float temp = percents.get(index);
      String tempS = tickersList.get(index);
      percents.set(index, percents.get(minimumIndex));
      percents.set(minimumIndex, temp);
      tickersList.set(index, tickersList.get(minimumIndex));
      tickersList.set(minimumIndex, tempS);
    }
  }
}

void calculateChangeDates(int minDate, int maxDate) {
  float startPrice = 0;
  float endPrice = 0;
  float percentChange = 0;
  dateTickers = new ArrayList<String>();
  datePercents =  new ArrayList<Float>();
  ArrayList<Datapoint> stockData = new ArrayList<Datapoint>();
  for (int i =0; i < data.length; i++) {
    stockData = data[i];
    startPrice = 0;
    endPrice = 0;
    for (int j = 0; j < stockData.size(); j++) {
      if (datesList.get(minDate).contentEquals(stockData.get(j).year)) {
        startPrice = stockData.get(j).open_price;
      }
      if (datesList.get(maxDate).contentEquals(stockData.get(j).year)) {
        endPrice = stockData.get(j).adjusted_close;
      }
    }
    if (startPrice != 0 && endPrice != 0 ) {
      percentChange = (endPrice - startPrice) /100;
      datePercents.add(percentChange);
      dateTickers.add(tickers.get(i));
    }
  }
  sortList(datePercents, dateTickers);
}

int findIndex(String year) {
  int index = -1;
  for (int i = 0; i < datesList.size(); i++) {
    if (year.contentEquals(datesList.get(i))) {
      index = i;
    }
  }
  return index;
}
