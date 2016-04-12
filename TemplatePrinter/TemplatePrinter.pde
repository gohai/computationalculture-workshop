Printer p;
PFont font;

void setup() {
  p = new Printer();
  size(300, 300);

  //printArray(PFont.list());
  //font = createFont("Helvetica", 32);
  //textFont(font);
}

void draw() {
  background(255);

  line(0, 0, width, height);
  line(0, height, width, 0);

  fill(0);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("A nice day, isn't it?", width/2, height/2);

  p.printDialog();

  // instead of printDialog() you could also use the following
  // lines, which will try to print using the default connected
  // printer without a dialog

  //if (p.print() == false) {
  //// printing failed, let's wait 5 seconds and try again
  //  delay(5000);
  //  return;
  //}

  // the job is done, exit the program
  exit();
}
