import processing.io.*;

// 0.96" 128x64 OLED display ("SKU 346540")
SSD1306 oled;

void setup() {
  size(128, 64);

  // the display can be set to one of these two addresses: 0x3c (default) or 0x3d
  // (they might be listed as 0x7a and 0x7b on the circuit board)
  //oled = new SSD1306(I2C.list()[0], 0x3c);
  frameRate(1);
  textSize(36);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(255);
  fill(0);
  if (frameCount % 2 == 1) {
    text("YES", width/2, height/2);
  } else {
    text("NO", width/2, height/2);
  }
  oled.sendImage(get());
}