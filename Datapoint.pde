class Datapoint{
    // String ticker;
    float open_price, close_price, adjusted_close, low, high;
    int volume;
    Date date;
    Datapoint(){
        // ticker = "";
        open_price=0;
        close_price=0;
        adjusted_close=0;
        low=0;
        high = 0;
        volume = 0;
        date = new Date();
    }
    Datapoint(float open_price, float close_price, float adjusted_close, float low, float high, int volume, Date date){
        // this.ticker = ticker;
        this.open_price = open_price;
        this.close_price = close_price;
        this.adjusted_close = adjusted_close;
        this.low = low;
        this.high = high;
        this.date = date;
    }
    /* 
    void setTicker(String ticker){
        this.ticker = ticker;
    }
 */
    void setOpen_price(float open_price) {
        this.open_price = open_price;
    }

    void setClose_price(float close_price) {
        this.close_price = close_price;
    }

    void setAdjusted_close(float adjusted_close) {
        this.adjusted_close = adjusted_close;
    }

    void setLow(float low) {
        this.low = low;
    }

    void setHigh(float high) {
        this.high = high;
    }

    void setVolume(int volume) {
        this.volume = volume;
    }

    void setDate(Date date) {
        this.date = date;
    }
}
