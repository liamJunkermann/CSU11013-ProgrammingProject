class Screen {
  String ticker;
  Widget backButton, dateFilter;
  ArrayList<Widget> filterButtons;
  int indexOfStock;
  float open_price, close_price, adjusted_close, low, high;
  int volume;
  Date date;
  Graph graph;
  Slider slider;

  Screen(int index) {
    filterButtons = new ArrayList<Widget>();
    indexOfStock = index;
    backButton = new Widget(900, 400, 50, 50, "back", backgroundDark, font, 1);
    slider = new Slider(200, 300, 700);
    if (index < 0) {
      filterButtons.add(new Widget(250, 50, 275, 45, "CONSUMER SERVICES", backgroundDark, font, -2));
      filterButtons.add(new Widget(250, 95, 275, 45, "CONSUMER DURABLES", backgroundDark, font, -3));
      filterButtons.add(new Widget(250, 140, 275, 45, "TECHNOLOGY", backgroundDark, font, -4));
      filterButtons.add(new Widget(250, 185, 275, 45, "FINANCE", backgroundDark, font, -5));
      filterButtons.add(new Widget(250, 230, 275, 45, "CAPITAL GOODS", backgroundDark, font, -6));
      filterButtons.add(new Widget(250, 275, 275, 45, "ENERGY", backgroundDark, font, -7));
      filterButtons.add(new Widget(250, 320, 275, 45, "HEALTH CARE", backgroundDark, font, -8));
      filterButtons.add(new Widget(250, 365, 275, 45, "N/A", backgroundDark, font, -9));
      filterButtons.add(new Widget(250, 410, 275, 45, "ALL", backgroundDark, font, -10));
      dateFilter = new Widget(420, 10, 170, 30, "Filter by Date", backgroundDark, font, -11);
      slider.sliderPositionY = 380;
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
    } else if (indexOfStock == -1) {                        // Show filter options
      background(backgroundLight);
      drawWidgets();
      dateFilter.draw();
      text("Filter by Sector: ", 250, 40);
      printTopNumbers(20, 650, 70, sectorQuery);
      for (Widget filterButton : filterButtons) {
        filterButton.draw();
      }
    } else if ( indexOfStock == -2) {
      background(backgroundLight);
      backButton.draw();
      drawWidgets();
      slider.draw();
      printTopNumbersDates(150,70); // have to fix issues
    }
  }


  void setTicker (String ticker) {
    this.ticker= ticker;
  }


  void graphSetup() {
    graph = new Graph(data[indexOfStock]);
  }
}
