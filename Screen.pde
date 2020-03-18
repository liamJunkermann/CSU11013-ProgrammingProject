class Screen {
  float open_price, close_price, adjusted_close, low, high;
  int volume;
  String ticker;
  Widget backButton;

  Screen(Datapoint stock) {
    this.open_price = stock.open_price;
    this.close_price = stock.close_price;
    this.adjusted_close = stock.adjusted_close;
    this.low = stock.low;
    this.high = stock.high;
    this.volume = stock.volume;
    backButton = new Widget(400, 400, 50, 50, "back", backgroundDark, font, 1);
  }

  void draw() {
    background(backgroundLight);
    text(ticker, 200, 50);
    text("Open Price: " + open_price,200,100);
    backButton.draw();
  }
  void setTicker (String ticker){
    this.ticker = ticker;
  }
}
