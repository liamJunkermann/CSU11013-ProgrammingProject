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
      filterButtons.add(new Widget(250, 50, 275, 50, "CONSUMER SERVICES", backgroundDark, font, -2));
      filterButtons.add(new Widget(250, 100, 275, 50, "CONSUMER DURABLES", backgroundDark, font, -3));
      filterButtons.add(new Widget(250, 150, 275, 50, "TECHNOLOGY", backgroundDark, font, -4));
      filterButtons.add(new Widget(250, 200, 275, 50, "FINANCE", backgroundDark, font, -5));
      filterButtons.add(new Widget(250, 250, 275, 50, "CAPITAL GOODS", backgroundDark, font, -6));
      filterButtons.add(new Widget(250, 300, 275, 50, "HEALTHCARE", backgroundDark, font, -7));
      filterButtons.add(new Widget(250, 350, 275, 50, "N/A", backgroundDark, font, -8));
      filterButtons.add(new Widget(250, 400, 275, 50, "ALL", backgroundDark, font, -9));
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