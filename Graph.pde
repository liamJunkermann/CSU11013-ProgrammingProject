class Graph{
    ArrayList<Datapoint> datapoints;
    int graph_height, graph_width;
    float[] adj_closes;
    int[] dates;
    int padding;
    int minDate;
    int maxDate;
    int minX;
    int maxX;
    int minVal;
    int maxVal;
    int minY;
    int maxY;

    Graph(ArrayList<Datapoint> datapoints){
        this.datapoints = datapoints; //<>//
        graph_height = 200;
        graph_width = 300;
        adj_closes = new float[0];
        dates = new int[0];
        graphSetup();
    }

    Graph(ArrayList<Datapoint> datapoints, int graph_width, int graph_height){
        this.datapoints = datapoints;
        this.graph_height = graph_height;
        this.graph_width = graph_width;
        adj_closes = new float[0];
        dates = new int[0];
        graphSetup();
    }

    void draw(int x, int y){
      fill(color(backgroundDark));
      rect(x,y,graph_width,graph_height);
      padding = 50;
      minDate = min(dates);
      maxDate = max(dates);
      minX = x + padding;
      maxX = graph_width - padding;
      minVal = 0;
      maxVal = max(parseInt(adj_closes));
      minY = graph_height - padding;
      maxY = y + padding;
      for (int i = 1; i < datapoints.size(); i++) {
          int oldDate = dates[i-1];
          int newDate = dates[i];
          float oldVal = adj_closes[i-1];
          float newVal = adj_closes[i];
          fill(255);
          stroke(255);
          line( //<>//
            map( oldDate, minDate, maxDate, minX, maxX ),
            map( oldVal, minVal, maxVal, minY, maxY ), //<>//
            map( newDate, minDate, maxDate, minX, maxX ),
            map( newVal, minVal, maxVal, minY, maxY )
          );
      }
    }

    void graphSetup(){
        println("Graph Setup");
        for (Datapoint dp : datapoints ) {
            adj_closes = Arrays.copyOf(adj_closes, adj_closes.length+1);
            dates = Arrays.copyOf(dates, dates.length+1);
            adj_closes[adj_closes.length-1] = dp.adjusted_close;
            dates[dates.length-1]=parseInt(easyFormat.format(dp.date));
        }
        
    }
}
