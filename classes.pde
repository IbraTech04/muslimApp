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
    rect(10, 10, width-20, 90, 10, 10, 10, 10);
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
