#include "Adafruit_WS2801.h"
#include "SPI.h"

uint8_t dataPin  = 2;    // Yellow wire on Adafruit Pixels
uint8_t clockPin = 3;    // Green wire on Adafruit Pixels
// Don't forget to connect the ground wire to Arduino ground,
// and the +5V wire to a +5V supply
bool lightOn = false;

// Set the first variable to the NUMBER of pixels. 25 = 25 pixels in a row
Adafruit_WS2801 strip = Adafruit_WS2801(25, dataPin, clockPin);

void setup() {
  Serial.begin(57600);
  pinMode(13, OUTPUT);
  strip.begin();
  strip.show();
}

void loop() {
  // read in a line of text from Processing
  String line = Serial.readStringUntil('\n');

  if (line == NULL) {
    // no line available, nothing to do
    return;
  }
  if (line.length() < 11) {
    // line is shorter than expected, ignore
    return;
  }

  // turn the text into numbers
  String field = line.substring(0, 2);
  int col = field.toInt();
  field = line.substring(2, 5);
  int red = field.toInt();
  field = line.substring(5, 8);
  int green = field.toInt();
  field = line.substring(8, 11);
  int blue = field.toInt();

  // set the respective pixel on the strip
  strip.setPixelColor(col, red, green, blue);

  // blink the led to show it's working
  lightOn = ~lightOn;
  digitalWrite(13, lightOn);
}

