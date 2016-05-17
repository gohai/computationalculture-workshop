// this needs the program jmtpfs installed
// (sudo aptitude install jmtpfs)

void setup() {
}

void draw() {
  // make sure the phone isn't mounted
  unmountPhone();

  // try to mount phone
  if (mountPhone() == true) {
    println("Found a phone!");

    println("Found the following images:");
    String[] images = getImages();
    printArray(images);
  }

  // go to sleep for a second
  delay(1000);
}


boolean mountPhone() {
  File drive = new File(sketchPath() + "/phone");
  drive.mkdir();
  
  try {
    Process proc = Runtime.getRuntime().exec("jmtpfs " + sketchPath() + "/phone");
    // wait for the process to finish and check what exit code it returned
    int retVal = proc.waitFor();
    if (retVal == 255) {
      // this means no phone is connected
      return false;
    } else if (retVal != 0) {
      // some other error occurred
      println("jmtpfs returned " + retVal);
      return false;
    }
  } catch (Exception e) {
    // something went wrong
    println(e);
    return false;
  }
  
  return true;
}

String[] getImages() {
  ArrayList<String> images = new ArrayList<String>();

  File drive = new File(sketchPath() + "/phone/DCIM/100ANDRO");
  if (drive.isDirectory() == false) {
    println("Image directory does not exist");
    return new String[]{};
  }

  File[] dir = drive.listFiles();
  for (File file : dir) {
    // TODO: check if file is indeed an image
    images.add(file.toString());
  }

  return images.toArray(new String[images.size()]);
}

void unmountPhone() {
  try {
    Runtime.getRuntime().exec("fusermount -u " + sketchPath() + "/phone");    
  } catch (Exception e) {
  }

  File drive = new File(sketchPath() + "/phone");
  if (drive.isDirectory()) {
    if (drive.delete() == false) {
      println("Cannot delete the phone directory");
    }
  }
}