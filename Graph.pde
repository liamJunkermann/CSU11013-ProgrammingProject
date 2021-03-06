//Created by Liam Junkermann 19/3/2020
//Initial setup of graphs
//Fixed graphs and added colour by Liam Junkermann 19/3/2020
//Added graph colour by Liam O'Lionard 19/3/2020
//Added earliest date to graph and changed circle() to ellipse() by Liam O'Lionard 26/3/2020
//Details on graph updated by Liam Junkermann 26/3/2020
//Created filter option by Liam Junkermann 9/4/2020
//Updates including filtering by date by Liam Junkermann 16/4/2020


// Graph class - class to calculate and render graph including filtering.
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
    Widget dataSelector;
    int showDetail;
    float sliderStart; //<>//
    float sliderEnd;
 //<>//
    Graph(ArrayList<Datapoint> datapoints){
        this.datapoints = datapoints; //<>// //<>// //<>//
        graph_height = 275;
        graph_width = 700;
        adj_closes = new float[0];
        dates = new int[0];
        showDetail = -1;
        sliderStart = 0;
        sliderEnd = 1;
        graphSetup();
    }

    Graph(ArrayList<Datapoint> datapoints, int graph_width, int graph_height){
        this.datapoints = datapoints;
        this.graph_height = graph_height;
        this.graph_width = graph_width;
        adj_closes = new float[0];
        dates = new int[0];
        showDetail = -1;
        sliderStart = 0;
        sliderEnd = 1;
        graphSetup();
    }

    void draw(int x, int y) {
      dataSelector.draw(x+graph_width+5, y);
      fill(color(backgroundDark));
      rect(x,y,graph_width,graph_height);
      padding = 30;
      minDate = min(dates);
      maxDate = max(dates);
      minX = x + padding;
      maxX = (x+graph_width) - padding;
      minVal = 0;
      float filterMin = map(sliderStart, 0,1,minDate, maxDate);   // adds filter if applied
      float filterMax = map(sliderEnd, 0,1,minDate, maxDate);     // Adds filter if applied
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
         maxDateFormat = DATE_FORMAT.format(easyFormat.parse(Integer.toString((int)filterMax)));
         minDateFormat = DATE_FORMAT.format(easyFormat.parse(Integer.toString((int)filterMin)));
      } catch (Exception e){
        println("Exception Occurred: "+ e);
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
          // if values don't fit in filtered values, skip drawing
          if(newDate>filterMin && newDate<filterMax){
            float newPointX = map(newDate, filterMin, filterMax, minX, maxX); 
            float newPointY = map(newVal, minVal, maxVal, minY, maxY);
            float highVal = map(datapoints.get(i).high, minVal, maxVal, minY, maxY);
            float lowVal = map(datapoints.get(i).low, minVal, maxVal, minY, maxY);
            line(
              map( oldDate, filterMin, filterMax, minX, maxX ), // x1
              map( oldVal, minVal, maxVal, minY, maxY ), // y1
              newPointX, // x2
              newPointY // y2
            );

            // Need to make this extra data optional
            //if(showDetail==1){
              stroke(green);
              line(newPointX, newPointY, newPointX, highVal);
              noFill();
              ellipse(newPointX, highVal, 5, 5);

              stroke(red);
              line(newPointX, newPointY, newPointX, lowVal);
              noFill();
              ellipse(newPointX, lowVal, 5, 5);
            //}
          }   
      }
      // Add slider from minx-maxX at minY

    }

    void graphSetup(){
      dataSelector = new Widget(parseInt(textWidth("Data")),50, "Data", color(backgroundDark), font, -2);
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
    void filter(int minDate, int maxDate){
      maxVal = 0;
        for (Datapoint dp : datapoints ) {
          if(parseInt(easyFormat.format(dp.date))>minDate && parseInt(easyFormat.format(dp.date))<maxDate){
            adj_closes = Arrays.copyOf(adj_closes, adj_closes.length+1);
            if(dp.adjusted_close>maxVal) maxVal = dp.adjusted_close;
            dates = Arrays.copyOf(dates, dates.length+1);
            adj_closes[adj_closes.length-1] = dp.adjusted_close;
            dates[dates.length-1]=parseInt(easyFormat.format(dp.date));
          } 
        }
    }
} 
// Potential adding mouse overs (definitely need more time for this)