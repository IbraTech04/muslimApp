class WeekRect {
  int id;
  String day;
  String dayPt2;
  String P1;
  String P2;
  boolean noSchool;
  Calendar cal = Calendar.getInstance();
  public WeekRect(String[] args, int newID, int dayOfYear) {
    day = args[0];
    dayPt2 = args[1];
    P1 = split(args[2], '/')[0];
    P2 = split(args[2], '/')[1];

    cal.set(Calendar.DAY_OF_YEAR, dayOfYear);
    id = newID;
  }

  public void drawRect() {
    fill(43, 88, 12);
    rect(10, 10, width-20, 90, 20, 20, 20, 20);
    fill(255);
    textAlign(LEFT);
    textFont(font, 25); //Setting Text Font
    text(day + "\n" + dayPt2, 20, 45);
    textFont(font, 30); //Setting Text Font
    text("Fajr: " + P1, 240, 45);
    text("Maghrib: " + P2, 240, 85);
    if (mousePressed && mouseX >= 10 && mouseX <= width-20 && mouseY >= ((id*100) + (height*0.145833333)) + transScale && mouseY <= ((id*100) + (height*0.145833333) +transScale) + 90) {
      if (mouseY < height -  height*0.102986612) {
        screenNumber = 3;
        event = cal;
      }
    }
  }
}

public class ClickableText {
  String text;
  int textPosX;
  int textPosY;
  int textSize;
  boolean isCenter = false;
  public boolean isPressed() {
    if (isCenter) {
      if (mouseX >= textPosX - ((text.length())*textSize/2)/2 && mouseX <= textPosX + ((text.length())*textSize/2)/2 && mouseY >= textPosY-textSize && mouseY <= textPosY) {
        println("here");
        return true;
      }
      return false;
    } else {
      if (mouseX >= textPosX && mouseX <= (text.length())*textSize/2 && mouseY >= textPosY-textSize && mouseY <= textPosY) {
        return true;
      } else {
        return false;
      }
    }
  }
  public void drawText() {
    if (isCenter) {
      textAlign(CENTER);
    } else {
      textAlign(LEFT);
    }
    text(text, textPosX, textPosY);
  }
  public void setText(String tempText) {
    text = tempText;
  }
  public void setSize(int size) {
    textSize = size;
  }
  public void setPos(int x, int y) {
    textPosX = x;
    textPosY = y;
  }

  public void setMode(String mode) {
    if (mode.toUpperCase().equals("CENTER")) {
      isCenter = true;
    } else {
      isCenter = false;
    }
  }
  public int getTextSize() {
    return textSize;
  }
  public int getTextX() {
    return textPosX;
  }
  public int getTextY() {
    return textPosY;
  }
  public String getText() {
    return text;
  }
}

class UpdaterThread extends Thread {
  public void run()
  {
    try {
      checkForUpdates();
    }
    catch (Exception e) {
    }
  }
}
