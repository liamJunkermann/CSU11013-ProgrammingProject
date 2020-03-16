class Screen {
  float open_price, close_price, adjusted_close, low, high;
  int volume;
  String ticker;
  Widget backButton;

  Screen(Datapoint stock, String ticker) {
    this.open_price = stock.open_price;
    this.close_price = stock.close_price;
    this.adjusted_close = stock.adjusted_close;
    this.low = stock.low;
    this.high = stock.high;
    this.volume = stock.volume;
    this.ticker = ticker;
    backButton = new Widget(400, 400, 50, 50, "back", backgroundDark, font, 1);
  }

  void draw() {
    background(backgroundLight);
    text("test", 250, 250);
    backButton.draw();
  }
}
