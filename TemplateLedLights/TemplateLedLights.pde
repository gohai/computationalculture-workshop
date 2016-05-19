import processing.serial.*;
Serial serial;
int cols = 25;
int size = 10;  // pixels per grid element
color pixels[] = new color[cols];

void setup() {
  size(250, 10);

  printArray(Serial.list());
  // this line might need to be adapted to point to your Arduino
  serial = new Serial(this, Serial.list()[2], 57600);

  // set a default color
  for (int i=0; i < cols; i++) {
    pixels[i] = color(255, 255, 255);
  }

  updateLights();
}

void draw() {
  // draw grid
  for (int i=0; i < cols; i++) {
    fill(pixels[i]);
    rect(i * size, 0, (i+1) * size, height-1);
  }
}

void mouseClicked() {
  int i = mouseX / size;

  // swap color
  if (pixels[i] == color(255, 255, 255)) {
    pixels[i] = color(0, 0, 204);
  } else {
    pixels[i] = color(255, 255, 255);
  }

  updateLights();
}

void updateLights() {
  // we encode the information to be sent to the Arduino in the following way
  // CCRRRGGGBBB\n
  // ^^ the column (00-25)
  //   ^^^ the red value (000-255) etc
  //            ^ a new line character

  for (int i=0; i < cols; i++) {
    // encode for each column
    String out = "";
    out = nf(i, 2);
    // += is a shorter way of writing "out = out + ..."
    out += nf((int)red(pixels[i]), 3) + nf((int)green(pixels[i]), 3) + nf((int)blue(pixels[i]), 3);
    out += "\n";
    // send it out
    //print(out);
    serial.write(out);
  }
}