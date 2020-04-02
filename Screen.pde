class Screen {
  String ticker;
  Widget backButton;
  ArrayList<Widget> filterButtons;
  int indexOfStock;
  float open_price, close_price, adjusted_close, low, high;
  int volume;
  Date date;
  Graph graph;

  Screen(int index) {
    filterButtons = new ArrayList<Widget>();
    indexOfStock = index;
    backButton = new Widget(900, 400, 50, 50, "back", backgroundDark, font, 1);
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
    }
  }


  void draw() {
    if (indexOfStock >= 0) {        // Show stocks
      background(backgroundLight);
      text(ticker, 200, 100);
      textPanels.get(indexOfStock).draw(200, 350);
      backButton.draw();
      graph.draw(200, 25);
      drawWidgets();
    } else {                        // Show filter options
      background(backgroundLight);
      drawWidgets();
      text("Filter by Sector: ", 250, 40);
      printTopNumbers(20, 650, 70, sectorQuery);
      for (Widget filterButton : filterButtons) {
        filterButton.draw();
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