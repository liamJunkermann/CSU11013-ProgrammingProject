//Created by April Sheeran 12/3/2020
//Fixed issues and displays correct stock info by April Sheeran 18/3/2020
//Graphs drawn in screen class + sidebar always visible by April Sheeran 19/3/2020
//Print list of biggest overall changes in stock price by April Sheeran 25/3/2020
//Print list of biggest changes in stock price by year by April Sheeran 23/4/2020



class Screen {
  String ticker;
  Widget backButton, dateFilter;
  ArrayList<Widget> filterButtons, yearButtons;
  int indexOfStock;
  float open_price, close_price, adjusted_close, low, high;
  int volume;
  Date date;
  Graph graph;
  Slider slider;

  Screen(int index) {
    filterButtons = new ArrayList<Widget>();
    yearButtons = new ArrayList<Widget>();
    indexOfStock = index;
    backButton = new Widget(900, 400, 50, 50, "back", backgroundDark, font, 1);
    slider = new Slider(200, 300, 700);
    if (index == -1) {
      filterButtons.add(new Widget(250, 50, 275, 45, "CONSUMER SERVICES", backgroundDark, font, -2));
      filterButtons.add(new Widget(250, 95, 275, 45, "CONSUMER DURABLES", backgroundDark, font, -3));
      filterButtons.add(new Widget(250, 140, 275, 45, "TECHNOLOGY", backgroundDark, font, -4));
      filterButtons.add(new Widget(250, 185, 275, 45, "FINANCE", backgroundDark, font, -5));
      filterButtons.add(new Widget(250, 230, 275, 45, "CAPITAL GOODS", backgroundDark, font, -6));
      filterButtons.add(new Widget(250, 275, 275, 45, "ENERGY", backgroundDark, font, -7));
      filterButtons.add(new Widget(250, 320, 275, 45, "HEALTH CARE", backgroundDark, font, -8));
      filterButtons.add(new Widget(250, 365, 275, 45, "N/A", backgroundDark, font, -9));
      filterButtons.add(new Widget(250, 410, 275, 45, "ALL", backgroundDark, font, -10));
      dateFilter = new Widget(420, 10, 170, 35, "Filter by Date", backgroundDark, font, -11);
    }
    if (index == -2) {
      int x =150;
      int year = 1980;
      int event = -2;
      int y = 50;
      for (int i = 0; i < 8; i ++) {
        if (i == 4) {
          y = 150;
          year = 1980;
          x = 150;
        }
        yearButtons.add(new Widget(x, y, 50, 50, "" +year, backgroundDark, font, event));
        x+= 60;
        event -= 1;
        year += 10;
      }
      yearButtons.add(new Widget(210, y+100,50,50, "-", backgroundDark, font, -10));
      yearButtons.add(new Widget(270, y+100,50,50, "+", backgroundDark, font, -11));
      yearButtons.add(new Widget(210, y+200,50,50, "-", backgroundDark, font, -12));
      yearButtons.add(new Widget(270, y+200,50,50, "+", backgroundDark, font, -13));
    }
  }




void draw() {
  if (indexOfStock >= 0) {        // Show stocks
    background(backgroundLight);
    text(ticker, 200, 100);
    textPanels.get(indexOfStock).draw(200, 350);
    backButton.draw();
    graph.draw(200, 25);
    slider.draw();
    graph.sliderStart = slider.getStartPercentage();
    graph.sliderEnd = slider.getEndPercentage();
    drawWidgets();
  } else if (indexOfStock == -1) {         // Show filter options by category
    background(backgroundLight);
    drawWidgets();
    dateFilter.draw();
    text("Filter by Sector: ", 250, 40);
    printTopNumbers(20, 650, 70, sectorQuery);
    for (Widget filterButton : filterButtons) {
      filterButton.draw();
    }
  } else if ( indexOfStock == -2) {        // Show filter options by date
    background(backgroundLight);
    backButton.draw();
    drawWidgets();
    printTopNumbersDates(650, 70);
    fill(textColor);
    text("Set minimum to: ", 150, 40);
    text("Set maximum to: ", 150, 140);
    text("Minimum: ", 220, 240);
    text("Maximum: ", 220, 340);
    println(datesList.size());
    for (Widget yearButton : yearButtons) {
      yearButton.draw();
    }
  }
}


void setTicker (String ticker) {
  this.ticker= ticker;
}


void graphSetup() {
  graph = new Graph(data[indexOfStock]);
}
}