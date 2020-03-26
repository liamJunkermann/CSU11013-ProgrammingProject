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
    backButton = new Widget(900, 400, 50, 50, "back", backgroundDark, font, 1);
  }

  

  void draw() {
   if(indexOfStock >= 0){
    background(backgroundLight);
    text(ticker, 200, 100);
    textPanels.get(indexOfStock).draw(200,350);
    backButton.draw();
    graph.draw(200,25);
    drawWidgets();
   }
   else{
    background(backgroundLight);
    drawWidgets();
   }
  }
  void setTicker (String ticker){
    this.ticker = ticker;
  }
  void graphSetup(){
    graph = new Graph(data[indexOfStock]);
  }
}
