class Screen {
  float open_price, close_price, adjusted_close, low, high;
  Date date;
  String ticker;

  Screen (Datapoint stockData) {
    this.open_price = stockData.open_price;
    this.close_price = stockData.close_price;
    this.adjusted_close = stockData.adjusted_close;
    this.low = stockData.low;
    this.high = stockData.high;
    this.ticker =  stockData.ticker;
  }
  void draw() {
    background(255);
    drawData();
  }
  void drawData() {
    text("Open Price: " + open_price, 100, 100);
    text("Close Price: " + close_price, 100, 150);
    text("Adjusted Close: " + adjusted_close, 100, 200);
    text("Low: " + low, 100, 250);
    text("High: " + high, 100, 300);
  }
}
