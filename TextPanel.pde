// Text Panel class to include various data about ticker
// Text panels can be made as part of screen class
class TextPanel{
    String ticker, exchange, name, sector, industry;
    float currentValue;
    PFont font;
    int incrementer = 20;
    // Constructor to input details from table (need to sort out input parsing from stocks.csv table)
    TextPanel(String ticker, String exchange, String name, String sector, String industry, float currentValue, PFont font){
        this.ticker = ticker;
        this.exchange = exchange;
        this.name = name;
        this.sector = sector;
        this.industry = industry;
        this.currentValue = currentValue;
        this.font = font;
    }
    
    // Mainly a test constructor
    TextPanel(PFont font){
      this.ticker = "";
      this.exchange = "";
      this.name = "";
      this.sector = "";
      this.industry = "";
      this.currentValue = 0;
      this.font = font;
    }

    // x and y of the text box start location called from screen
    void draw(int x, int y){
        background(color(#2f5b9f));
        textSize(32);
        text("Name: "+name, x, y+incrementer);
        textSize(20);
        text("Exchange: " + exchange, x, y+(incrementer*3));
        text("Sector: " + sector, x, y+(incrementer*4)+5);
        text("Industry: " + industry, x, y+(incrementer*5)+10);
    }
}