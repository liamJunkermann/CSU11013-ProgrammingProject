class Graph {
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
    float maxVal;
    int minY;
    int maxY;

    Graph(ArrayList<Datapoint> datapoints){
        this.datapoints = datapoints; //<>// //<>//
        graph_height = 275;
        graph_width = 700;
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

    void draw(int x, int y) {
      fill(color(backgroundDark));
      rect(x,y,graph_width,graph_height);
      padding = 30;
      minDate = min(dates);
      maxDate = max(dates);
      minX = x + padding;
      maxX = (x+graph_width) - padding;
      minVal = 0;
      //maxVal = Collections.max(Arrays.asList(adj_closes));
      minY = (y+graph_height) - padding;
      maxY = y + padding;
      stroke(white);
      line(minX-5, maxY-10, minX-5, minY+5);
      line(minX-5, minY+5, maxX+5, minY+5);
      fill(white);
      textSize(10);
      text(maxVal, x+2, y+15);
      String maxDateFormat = "";
      String minDateFormat = "";
      try {
         maxDateFormat = DATE_FORMAT.format(easyFormat.parse(Integer.toString(maxDate)));
         minDateFormat = DATE_FORMAT.format(easyFormat.parse(Integer.toString(minDate)));
      } catch (Exception pe){
        println("Exception Occurred: "+ pe);
      }
      text(maxDateFormat, maxX-textWidth(maxDateFormat)/2, minY+20);
      text(minDateFormat, minX, minY+20);
      
      
      for (int i = 1; i < datapoints.size(); i++) {
          int oldDate = dates[i-1];
          int newDate = dates[i];
          float oldVal = adj_closes[i-1];
          float newVal = adj_closes[i];
          fill(255);
          // // GRAPH COLOUR
          // if (adj_closes[i-1] < adj_closes[i])
          //   stroke(green);
          // else
          //   stroke(red);
          stroke(white);
          float newPointX = map(newDate, minDate, maxDate, minX, maxX); 
          float newPointY = map(newVal, minVal, maxVal, minY, maxY);
          float highVal = map(datapoints.get(i).high, minVal, maxVal, minY, maxY);
          float lowVal = map(datapoints.get(i).low, minVal, maxVal, minY, maxY);
          line(
            map( oldDate, minDate, maxDate, minX, maxX ), // x1
            map( oldVal, minVal, maxVal, minY, maxY ), // y1
            newPointX, // x2
            newPointY // y2
          );
          stroke(green);
          line(newPointX, newPointY, newPointX, highVal);
          noFill();
          ellipse(newPointX, highVal, 5, 5);

          stroke(red);
          line(newPointX, newPointY, newPointX, lowVal);
          noFill();
          ellipse(newPointX, lowVal, 5, 5);
      }
    }

    void graphSetup(){
        // println("Graph Setup");
        maxVal = 0;
        for (Datapoint dp : datapoints ) {
            adj_closes = Arrays.copyOf(adj_closes, adj_closes.length+1);
            if(dp.adjusted_close>maxVal) maxVal = dp.adjusted_close;
            dates = Arrays.copyOf(dates, dates.length+1);
            adj_closes[adj_closes.length-1] = dp.adjusted_close;
            dates[dates.length-1]=parseInt(easyFormat.format(dp.date));
        }
    }
} 
// Potential adding mouse overs (definitely need more time for this)