import java.awt.Desktop;

void checkForUpdates() {
  nversionFromServer = loadStrings("https://github.com/IbraTech04/updateServer/raw/master/muslimAppVers.txt");
  println(nversionFromServer[0]);
  if (isGreater(nversionFromServer[0])) {
    if (nversionFromServer[1].equals("URGENT")) {
      booster.showConfirmDialog(
        "An urgent update (V" + nversionFromServer[0] + ") is availible. Would you like to update now?", 
        "Urgent Update", 
        new Runnable() {
        public void run() {
          isConfirmed = true;
        }
      }
      , 
        new Runnable() {
        public void run() {
          isConfirmed = false;
        }
      }
      );        
      if (isConfirmed) {
        //link("https://github.com/IbraTech04/timeTableGen/releases");
      }
    } else {
      booster.showConfirmDialog(
        "A new update (V" + nversionFromServer[0] + ") Would you like to update now?", 
        "Update!", 
        new Runnable() {
        public void run() {
          isConfirmed = true;
        }
      }
      , 
        new Runnable() {
        public void run() {
          isConfirmed = false;
        }
      }
      );        
      if (isConfirmed) {
        // link("https://github.com/IbraTech04/timeTableGen/releases");
        updateMode = true;
      }
    }
  }
}

void update() {
  if (updateState == 0) {
    background(0);
    textAlign(CENTER);
    textSize(29);
    text("Updating... \nPlease do not close this window until this process is complete", width/2, height/2+30);
    text("Preparing to Update", width/2, height/2);
    updateState++;
  } else if (updateState == 1) {
    background(0);
    text("Updating... \nPlease do not close this window until this process is complete", width/2, height/2+30);
    text("Stage One: Downloading update files", width/2, height/2);    
    updateState++;
  } else if (updateState == 2) {
    background(0);
    text("Updating... \nPlease do not close this window until this process is complete.\ntMuslim will restart soon. Follow the prompts to update tMuslim.", width/2, height/2+60);
    text("Stage Two: Applying Update", width/2, height/2);
    updateState++;
  } else if (updateState == 3) {
    File file;
    Desktop desktop = Desktop.getDesktop();  
    try {
      File theDir = new File(System.getProperty("user.home") + "\\tMuslim");
      if (!theDir.exists()) {
        theDir.mkdirs();
      }
      if (System.getProperty("sun.desktop").equals("windows")) {
        if (System.getProperty("os.arch").equals("amd64")) {
          byte[] test = loadBytes("https://github.com/IbraTech04/updateServer/raw/master/muslim64.exe");
          saveBytes(System.getProperty("user.home")+"\\tMuslim\\tMuslimV" + nversionFromServer[0] + ".exe", test);
        } else {
          byte[] test = loadBytes("https://github.com/IbraTech04/updateServer/raw/master/muslim32.exe");
          saveBytes(System.getProperty("user.home")+"\\tMuslim\\tMuslimV" + nversionFromServer[0] + ".exe", test);
        }
      } else {
        link("https://github.com/IbraTech04/muslimApp/releases");
      }

      if (!Desktop.isDesktopSupported()) {
        System.out.println("Desktop is not supported");
        return;
      }
      file = new File(System.getProperty("user.home")+"\\tMuslim\\tMuslimV" + nversionFromServer[0] + ".exe");
      if (file.exists()) { 
        desktop.open(file);
        exit();
      }
    }
    catch(Exception e)  
    {  
      e.printStackTrace();
    }
    updateState++;
  }
}

boolean isGreater(String version) {
  String ver1 = ver + ".0.0";
  version = version + ".0.0";
  String[] ww = split(version, '.');
  String[] w = split(ver1, '.');
  println(version);
  try { 

    if (int(ww[0]) > int(w[0])) {
      return true;
    } else if (int(ww[1]) > int(w[1]) && int(ww[0]) == int(w[0])) {
      println("1");
      return true;
    } else if (int(ww[2]) > int(w[2]) && int(ww[1]) == int(w[1]) && int(ww[0]) == int(w[0])) {
      println("2");

      return true;
    }
  } 
  catch (Exception e) {
    println("here");
    e.printStackTrace();
    return true;
  }
  return false;
}
