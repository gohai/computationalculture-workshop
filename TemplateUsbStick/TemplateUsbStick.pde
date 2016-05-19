import java.nio.file.*;
String[] drives;
String[] images;


void setup() {
  // get the list of drives as they existed at startup
  drives = getDrives();
}


void draw() {
  // get an updated list of connected drives
  String[] updatedDrives = getDrives();
  // see if there have been any new drives added to the list
  String newDrive = getNewDrive(drives, updatedDrives);

  if (newDrive != null) {
    // get the path of the drive's root directory
    String path = getPathFromDrive(newDrive);
    println("Found a new USB disk at " + path);

    // get all image files
    images = getImageFiles(path);
    printArray(images);

    // the file names in the images array can now (or in later trips
    // through draw) used with loadImage() etc

    // keep in mind that the drive containing the images can also
    // go away at any time again
  }

  drives = updatedDrives;
}


String[] getDrives() {
  ArrayList<String> drives = new ArrayList<String>();

  FileSystem fileSystem = FileSystems.getDefault();
  for (FileStore store : fileSystem.getFileStores()) {
    // on OS X toString() returns e.g. "/Volumes/G (/dev/disk2s1)"
    // on Raspbian e.g. "/media/pi/G (/dev/sda1)"
    drives.add(store.toString());
  }

  return drives.toArray(new String[0]);
}


String getNewDrive(String[] oldDrives, String[] newDrives) {
  for (String newDrive : newDrives) {
    // see if the drive already existed previously
    boolean found = false;
    for (String oldDrive : oldDrives) {
      if (oldDrive.equals(newDrive)) {
        found = true;
        break;
      }
    }
    // found a drive that didn't exist previously
    if (found == false) {
      return newDrive;
    }
  }
  // found no new drive, so let the caller know by returning null
  return null;
}


String getPathFromDrive(String drive) {
  String[] parts = drive.split(" ");
  return parts[0];
}


String[] getImageFiles(String path) {
  ArrayList<String> files = new ArrayList<String>();
  try {
    files = getAllFileNames(files, Paths.get(path));
  } catch (Exception e) {
  }

  // remove the filenames that aren't images
  for (int i=0; i < files.size(); i++) {
    String fn = files.get(i);
    // convert to lowercase, to that we handle also "JPG" etc
    fn = fn.toLowerCase();

    // look at the file extensions
    if (fn.endsWith(".gif") ||
        fn.endsWith(".jpg") ||
        fn.endsWith(".jpeg") ||
        fn.endsWith(".png") ||
        fn.endsWith(".tga")) {
          // it's an image file, nothing to do
        } else {
          // not an image file, remove
          files.remove(i);
          i--;
        }
  }

  return files.toArray(new String[0]);
}


// based on http://stackoverflow.com/a/24324367
ArrayList<String> getAllFileNames(ArrayList<String> fileNames, Path dir) {
    try {
      DirectoryStream<Path> stream = Files.newDirectoryStream(dir);
      for (Path path : stream) {
          if(path.toFile().isDirectory()) {
              getAllFileNames(fileNames, path);
          } else {
              fileNames.add(path.toAbsolutePath().toString());
          }
      }
    } catch(IOException e) {
        e.printStackTrace();
    }
    return fileNames;
}