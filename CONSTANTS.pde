import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Date;
import java.util.Arrays;
import java.util.Collections;
final DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-mm-dd");
final DateFormat easyFormat = new SimpleDateFormat("yyyymmdd");
final SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
final int EVENT_NULL = -1;

int currentEvent;

color backgroundLight = #2f5b9f;
color backgroundDark = #303844;
color textColor = #5eccff;
color red = #ff0000;
color green = #00ff00;
color white = #ffffff;

PFont font;
