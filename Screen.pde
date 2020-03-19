class Screen {
  String ticker;
  Widget backButton;
  int indexOfStock;
  float open_price, close_price, adjusted_close, low, high;
  int volume;
  Date date;
  Graph graph;

  Screen(int index) {
    indexOfStock =  index;
    backButton = new Widget(400, 400, 50, 50, "back", backgroundDark, font, 1);
  }

  void draw() {
    background(backgroundLight);
    text(ticker, 200, 50);
    graph.draw(10, 10);
    textPanels.get(indexOfStock).draw(10,graph.graph_height + 10);
    backButton.draw();
  }
  void setTicker (String ticker){
    this.ticker = ticker;
  }
  void graphSetup(){
    graph = new Graph(data[indexOfStock]);
  }
}
