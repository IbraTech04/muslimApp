import processing.sound.*; //Import Sound library //<>// //<>//
import java.util.Calendar; //Import Calendar Functions
import uibooster.*; //Import UIBooster
UiBooster booster;//Define UIBooster Instance
Calendar cal = Calendar.getInstance(); //Get calendar date
SoundFile athan; //Define Sound Varible
PFont font; //Define Font  variable
PImage home, prayer, calendar; //Define image varibles
String calDate = ""; //Varible which holds the date
int day = day(), mon = month(), lineNum, hourLeft, minLeft, nextPrayerMin, nextPrayerHour, date = cal.get(Calendar.DAY_OF_WEEK), screenNumber = 1;
boolean fajrStat;
String[] week = {"", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}, months = {"", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}, times;
String fajrHour, fajrMinute, duhurHour, duhurMinute, asrHour, asrMinute, maghribHour, maghribMinute, ishaHour, ishaMinute, fajrHourNext, fajrMinuteNext, nextPrayer; //Varibles which hold prayer times
String prevPrayer;
float posX, posY;
float scaleFactor = 1.5;

ArrayList<WeekRect> rects = new ArrayList<WeekRect>();
Calendar viewWeek = Calendar.getInstance(); //Get calendar date
Calendar event = Calendar.getInstance(); //Get calendar date


void setup() {
  //Setup Function
  background(0); //Setting Background
  textSize(100); //Set text size
  textAlign(CENTER);
  text("TMMuslim " + ver, width/2, height/2); //Loading Text
  times = loadStrings("Annual Prayers.txt"); //Load the file with all the prayer times
  loadTimes(); //Load the prayer times 
  surface.setTitle("TMMuslim");
  surface.setResizable(true);
  size(1280, 720);
  noStroke();
  font = createFont("ProductSans-Bold.ttf", 100); //Load the font
  home = loadImage("mosque.png"); //Load the images
  calendar = loadImage("calL.png"); //Load the images
  prayer = loadImage("Clock.png");
  athan = new SoundFile(this, "Athan1.wav"); //Loading the Athan sound
  booster = new UiBooster();
  initWeekView();
  File saveDir = new File(System.getProperty("user.home") + "\\TMMuslim");
  if (!saveDir.exists()) {
    saveDir.mkdirs();
  }
  checkForUpdates();
}
void draw() {
  if (updateMode) {
    update();
  } else {
    checkPrayer(); //Check which prayer is next
    playAthan();
    if (screenNumber == 0) {   //if statement which changes between the screens
    } else if (screenNumber == 1) {
      if (view == 0) {
        mainScreen();
      } else {
        weekView();
      }
    } else if (screenNumber == 2) {
      prayerList();
    } else if (screenNumber == 3) {
      background(0);
      onTime(event);
    }
  }
}
void mainScreen() {
  //The main screen function that draws the home screen
  calDate = "";
  date();
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height); //These two are the two rectangles on the top and bottom
  rect(0, 0, width, height*0.102986612);
  fill(255);
  textFont(font, 50); //Setting Text Font
  textAlign(CENTER);
  text("TMMuslim Home", width/2, height*0.0494444444 + 25); //Top Text
  imageMode(CENTER); //Setting the image mode to Center
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  image(calendar, width - height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  pushMatrix();
  translate(0, -20);
  textFont(font, 40);
  text(calDate, width/2, height/2-155); //Drawing hte date
  textFont(font, 150);
  //Calculating current time
  int hour = hour();
  if (hour > 12) {
    hour -= 12; //Convert to 12-hour if necissary
  }
  if (hour == 0) {
    hour = 12;
  }
  String min = str(minute());
  if (minute() < 10) {
    min = nf(minute(), 2); //Add 0 before number if necissary
  }
  text(hour + " :" + min, width/2, height/2); //Draw clock
  textFont(font, 40);
  if (athan.isPlaying()) {
    text("Current Prayer: " + prevPrayer, width/2, height/2+55); //Draw the current prayer
  } else {
    text("Next Prayer: " + nextPrayer, width/2, height/2+55); //Draw the next prayer
    textFont(font, 40);
    String nextPrayerMinS = str(nextPrayerMin); //Add Zero to prayer time if necissary
    if (nextPrayerMin < 10) {
      nextPrayerMinS = nf(nextPrayerMin, 2);
    }
    text("At: " + nextPrayerHour + ":" + nextPrayerMinS, width/2, height/2+95); //Draw next prayer's time
    text("(-" + return0Value(timeCalc(nextPrayerHour, nextPrayerMin, fajrStat)[0]) + ":" + return0Value(timeCalc(nextPrayerHour, nextPrayerMin, fajrStat)[1]) + ")", width/2, height/2+140); //Draw how much time is left
    if (isSuhoorNext) {
      if (hour() == 0) {
        text("Time until Fajr: (-" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[0]) + ":" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[1]) + ")", width/2, height/2+180); //Draw how much time is left
      } else if (hour() > 0 && hour < 5) {
        text("Time until Fajr: (-" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[0]) + ":" + return0Value(timeCalc(int(fajrHour), int(fajrMinute), true)[1]) + ")", width/2, height/2+180); //Draw how much time is left
      } else {
        text("Time until Fajr: (-" + return0Value(timeCalc(int(fajrHourNext), int(fajrMinuteNext), true)[0]) + ":" + return0Value(timeCalc(int(fajrHourNext), int(fajrMinuteNext), true)[1]) + ")", width/2, height/2+180); //Draw how much time is left
      }
    } else {
      text("Time until Maghrib: (-" + return0Value(timeCalc(int(maghribHour), int(maghribMinute), false)[0]) + ":" + return0Value(timeCalc(int(maghribHour), int(maghribMinute), fajrStat)[1]) + ")", width/2, height/2+180); //Draw how much time is left
    }
  }
  popMatrix();
}
void prayerList() {
  background(0);
  fill(43, 88, 12);
  rect(0, height -  height*0.102986612, width, height); //Rectangles at top and bottom
  rect(0, 0, width, height*0.102986612);
  fill(255);
  textFont(font, 50);
  textAlign(CENTER);
  text("TMMuslim Prayer List", width/2, height*0.0494444444 + 25); //Top text
  imageMode(CENTER);
  image(home, height*0.102986612/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2); //Icons for switching Screens
  image(prayer, width/2, height - height*0.102986612/2, height*0.102986612/2, height*0.102986612/2);
  textAlign(CENTER);
  textFont(font, 55);
  text("Prayer Times:", width/2, height/2-225);
  textFont(font, 55);
  if (nextPrayer.equals("Fajr")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Fajr") && athan.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Fajr: " + fajrHour + ":" + fajrMinute, width/2, height/2-105); //Drawing Prayer times
  if (nextPrayer.equals("Duhur")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Duhur") && athan.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Duhur: " + duhurHour + ":" + duhurMinute, width/2, height/2-52);
  if (nextPrayer.equals("Asr")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Asr") && athan.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Asr: " + asrHour + ":" + asrMinute, width/2, height/2);
  if (nextPrayer.equals("Maghrib")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Maghrib") && athan.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Maghrib: " + maghribHour + ":" + maghribMinute, width/2, height/2+52);
  if (nextPrayer.equals("Isha")) {
    fill(50, 130, 184);
  } else if (prevPrayer.equals("Isha") && athan.isPlaying()) {
    fill(128, 0, 0);
  } else {
    fill(255);
  }
  text("Isha: " + ishaHour + ":" + ishaMinute, width/2, height/2+105);
  fill(255);
  text("Total Fast Time: " + return0Value(timeCalc(int(maghribHour), int(maghribMinute), int(fajrHour), int(fajrMinute), false)[0]) + ":" + return0Value(timeCalc(int(maghribHour), int(maghribMinute), int(fajrHour), int(fajrMinute), false)[1]), width/2, height/2+158);
}
//Calculate Date in format which user can understand
void date() {
  calDate += week[date];
  calDate += ", ";
  calDate += months[mon];
  calDate += " ";
  calDate += day;
  calDate += ", ";
  calDate += year();
}
//The function that loads the prayer times from a file and hands them to the program
void loadTimes() {
  String num = str(day());
  if (day() < 10) {
    num = nf(day(), 2); //Add 0 before number if necissary
  }
  String date = num + months[mon];
  for (int i = 0; i < times.length; i++) { //Until you find the entry with todays date continue the loop
    String toCheck = times[i];
    if (toCheck.equals(date)) { //Once you've found todays date, import all the prayer data
      fajrHour = split(times[i+1], ':')[0];
      fajrMinute = (split(times[i+1], ':')[1]);
      duhurHour = (split(times[i+2], ':')[0]);
      duhurMinute = (split(times[i+2], ':')[1]);
      asrHour = (split(times[i+3], ':')[0]);
      asrMinute = (split(times[i+3], ':')[1]);
      maghribHour = (split(times[i+4], ':')[0]);
      maghribMinute = (split(times[i+4], ':')[1]);
      ishaHour = (split(times[i+5], ':')[0]);
      ishaMinute = (split(times[i+5], ':')[1]);
      fajrHourNext = (split(times[i+7], ':')[0]);
      fajrMinuteNext = (split(times[i+7], ':')[1]);
      break; //Break the loop (stop the loop)
    }
  }
}

void mousePressed() { //Function which detects whether the mouse has pressed an icon or not
  if (mouseY >= height -  height*0.102986612 && mouseX <=height*0.102986612) {
    screenNumber = 1;
  } else if (mouseY >= height -  height*0.102986612 && mouseX >=width - height*0.102986612) {
    if (screenNumber == 1) {
      if (view == 0) {
        view = 1;
      } else {
        view = 0;
      }
    }
  } else if (mouseY >= height -  height*0.102986612 && mouseX <= width/2 + height*0.102986612/2 && mouseX >= width/2 - height*0.102986612/2) {
    screenNumber = 2;
  }
}
void checkPrayer() { //Function which checks which prayer is next by using LOTS AND LOTS OF MATH (Not even gonna bother explaining how)
  if (hour() > int(ishaHour) + 12 || hour() <= int(fajrHour)) {
    isSuhoorNext = true;
    nextPrayer = "Fajr";
    prevPrayer = "Isha";
    fajrStat = true;
    if (hour() == 0) {
      nextPrayerHour = int(fajrHour);
      nextPrayerMin = int(fajrMinute);
    } else if (hour() > 0 && hour() < 5) {
      nextPrayerHour = int(fajrHour);
      nextPrayerMin = int(fajrMinute);
    } else {
      nextPrayerHour = int(fajrHourNext);
      nextPrayerMin = int(fajrMinuteNext);
    }

    if (hour() == int(fajrHour)) {
      if (minute() < int(fajrMinute)) {
        isSuhoorNext = true;
        nextPrayer = "Fajr";
        prevPrayer = "Isha";
        fajrStat = true;
        nextPrayerHour = int(fajrHour);
        nextPrayerMin = int(fajrMinute);
      } else {
        isSuhoorNext = false;
        fajrStat = false;
        nextPrayer = "Duhur";
        prevPrayer = "Fajr";
        nextPrayerHour = int(duhurHour);
        nextPrayerMin = int(duhurMinute);
      }
    }
  } else if (hour() >= int(fajrHour) && hour() <= returnGreaterThan(int(duhurHour))) {
    isSuhoorNext = false;
    nextPrayer = "Duhur";
    prevPrayer = "Fajr";
    fajrStat = false;
    nextPrayerHour = int(duhurHour);
    nextPrayerMin = int(duhurMinute);
    if (hour() == returnGreaterThan(int(duhurHour))) {
      if (minute() < int(duhurMinute)) {
        nextPrayer = "Duhur";
        prevPrayer = "Fajr";
        fajrStat = false;
        nextPrayerHour = int(duhurHour);
        nextPrayerMin = int(duhurMinute);
      } else {
        nextPrayer = "Asr";
        prevPrayer = "Duhur";
        fajrStat = false;
        nextPrayerHour = int(asrHour);
        nextPrayerMin = int(asrMinute);
      }
    }
  } else if (hour() >= returnGreaterThan(int(duhurHour)) && hour() <= int(asrHour) + 12) {
    isSuhoorNext = false;
    nextPrayer = "Asr";
    prevPrayer = "Duhur";
    fajrStat = false;
    nextPrayerHour = int(asrHour);
    nextPrayerMin = int(asrMinute);
    if (hour() == int(asrHour) + 12) {
      if (minute() < int(asrMinute)) {
        nextPrayer = "Asr";
        prevPrayer = "Duhur";
        fajrStat = false;
        nextPrayerHour = int(asrHour);
        nextPrayerMin = int(asrMinute);
      } else {
        nextPrayer = "Maghrib";
        prevPrayer = "Asr";
        fajrStat = false;
        nextPrayerHour = int(maghribHour);
        nextPrayerMin = int(maghribMinute);
      }
    }
  } else if (hour() >= int(asrHour) + 12 && hour() <= int(maghribHour) + 12) {
    isSuhoorNext = false;
    nextPrayer = "Maghrib";
    prevPrayer = "Asr";
    fajrStat = false;
    nextPrayerHour = int(maghribHour);
    nextPrayerMin = int(maghribMinute);
    if (hour() == int(maghribHour) + 12) {
      if (minute() < int(maghribMinute)) {
        nextPrayerHour = int(maghribHour);
        nextPrayerMin = int(maghribMinute);
        nextPrayer = "Maghrib";
        prevPrayer = "Asr";
        fajrStat = false;
      } else {
        isSuhoorNext = true;
        fajrStat = false;
        nextPrayer = "Isha";
        prevPrayer = "Maghrib";
        nextPrayerHour = int(ishaHour);
        nextPrayerMin = int(ishaMinute);
      }
    }
  } else if (hour() >= int(maghribHour) + 12 && hour() <= int(ishaHour) + 12) {
    isSuhoorNext = true;
    fajrStat = false;
    nextPrayerHour = int(ishaHour);
    nextPrayerMin = int(ishaMinute);
    nextPrayer = "Isha";
    prevPrayer = "Maghrib";
    if (hour() == int(ishaHour) + 12) {
      if (minute() < int(ishaMinute)) {
        isSuhoorNext = true;
        fajrStat = false;
        nextPrayer = "Isha";
        prevPrayer = "Maghrib";
        nextPrayerHour = int(ishaHour);
        nextPrayerMin = int(ishaMinute);
      } else {
        isSuhoorNext = true;
        fajrStat = true;
        nextPrayer = "Fajr";
        prevPrayer = "Isha";
        nextPrayerHour = int(fajrHourNext);
        nextPrayerMin = int(fajrMinuteNext);
      }
    }
  }
}
void playAthan() { //Function which checks whether its time to play the athan, and does so
  int hour = hour();
  if (hour > 12) { //Convert to 12 hour time (if necissary)
    hour -= 12;
  }
  if (!athan.isPlaying()) { //If the Athan is not playing
    if (int(fajrHour) == hour && int(fajrMinute) == minute()) { //IF its fajr
      booster.createNotification(prevPrayer + " Athan is Now", "TMMuslim"); //Create Notification
      athan.play(); //Play athan
    } else  if (int(duhurHour) == hour && int(duhurMinute) == minute()) { //If its duhur
      booster.createNotification(prevPrayer + " Athan is Now", "TMMuslim"); //Create Notification
      athan.play(); //Play Athan
    } else  if (int(asrHour) == hour && int(asrMinute) == minute()) { //If its asr 
      booster.createNotification(prevPrayer + " Athan is Now", "TMMuslim"); //Create Notification
      athan.play(); //Play athan
    } else  if (int(maghribHour) == hour && int(maghribMinute) == minute()) { //If its maghtib
      athan.play(); //Play Athan
      booster.createNotification(prevPrayer + " Athan is Now", "TMMuslim"); //Create Notification
    } else  if (int(ishaHour) == hour && int(ishaMinute) == minute()) { //If its Isha
      athan.play(); //Play Athan
      booster.createNotification(prevPrayer + " Athan is Now", "TMMuslim"); //Create Notification
    }
  }
}

int[] timeCalc(int prayerHour, int prayerMin, boolean fajr) { //Time calculation function (If you think im gonna bother explaining all the math you're insane)
  int minute = minute(), hour = hour(); 
  int localMinLeft = 0;
  int localHourLeft = 0;
  int localHours = prayerHour;
  if (localHours < 12) {
    localHours +=12;
  }
  if (fajr) { //If we're calculating Fajr do this (This is because calculating Fajr is a bit more involved than other prayers)
    if (hour == 0) {
      localMinLeft = 60 - minute;
      localHours --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += int(prayerHour);
    } else if (hour > 0 && hour < 5) {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft = localHourLeft + (int(prayerHour) - hour());
    } else {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += 24 - hour;

      localHourLeft += int(prayerHour);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
    }
    return new int[]{ localHourLeft, localMinLeft};
  } else {//Otherwise proceed normally
    localMinLeft = 60 - minute;
    localHours --;
    localMinLeft += prayerMin;
    if (localMinLeft >= 60) {
      localHourLeft ++;
      localMinLeft = localMinLeft - 60;
    }
    localHourLeft = localHourLeft + ((localHours) - hour());
    return new int[]{ localHourLeft, localMinLeft};
  }
}

int[] timeCalc(int prayerHour, int prayerMin, int startHour, int startMin, boolean fajr) { //Time calculation function (If you think im gonna bother explaining all the math you're insane)
  int minute = startMin, hour = startHour; 
  int localMinLeft = 0;
  int localHourLeft = 0;
  int localHours = prayerHour;
  if (localHours < 12) {
    println("here");
    localHours +=12;
  }
  if (fajr) { //If we're calculating Fajr do this (This is because calculating Fajr is a bit more involved than other prayers)
    if (hour == 0) {
      localMinLeft = 60 - minute;
      localHours --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += int(prayerHour);
    } else if (hour > 0 && hour < 5) {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft = localHourLeft + (int(prayerHour) - hour());
    } else {
      localMinLeft = 60 - minute;
      localHourLeft --;
      localMinLeft += int(prayerMin);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
      localHourLeft += 24 - hour;

      localHourLeft += int(prayerHour);
      if (localMinLeft >= 60) {
        localHourLeft ++;
        localMinLeft = localMinLeft - 60;
      }
    }
    return new int[]{ localHourLeft, localMinLeft};
  } else {//Otherwise proceed normally
    localMinLeft = 60 - minute;
    localHours --;
    localMinLeft += prayerMin;
    if (localMinLeft >= 60) {
      localHourLeft ++;
      localMinLeft = localMinLeft - 60;
    }
    localHourLeft = localHourLeft + ((localHours) - hour);
    return new int[]{ localHourLeft, localMinLeft};
  }
}

int returnGreaterThan(int input) {
  if (input < 12) {
    return input + 12;
  } else {
    return input;
  }
}
String return0Value(int input) {
  if (input < 10) {
    String toReturn = nf(input, 2);
    return toReturn;
  } else {
    return str(input);
  }
}
