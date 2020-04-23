//Created by Liam Junkermann 18/3/2020
//Displays text info about stock
//Fixed some stock names length on screen by Liam Junkermann 26/3/2020


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

    // Without currentValue
    TextPanel(String ticker, String exchange, String name, String sector, String industry, PFont font){
        this.ticker = ticker;
        this.exchange = exchange;
        this.name = name;
        this.sector = sector;
        this.industry = industry;
        this.currentValue = 0;
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
        int baseTextSize = 30;
        textSize(baseTextSize);
        while(textWidth("Name: " + name)+x>width-10){
            baseTextSize -= 2;
            textSize(baseTextSize);
        }
        text("Name: "+name, x, y+incrementer);
        textSize(18);
        text("Exchange: " + exchange, x, y+(incrementer*3));
        text("Sector: " + sector, x, y+(incrementer*4)+5);
        text("Industry: " + industry, x, y+(incrementer*5)+10);
    }
}
