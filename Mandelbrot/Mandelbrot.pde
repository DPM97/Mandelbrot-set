float xMin, xMax, yMin, yMax; //the plot bounds 
int plotW, plotH, plotX, plotY; //the plot bitmap position and size
int newPlotW, newPlotH;
int maxIter; //the maximum number of iterations to use when computing the Mandelbrot set
PImage plotImage;
int bgColor;
float scale;
int x1, y1, x2, y2, l, w;
int x, y;

// defines variables && plots origional pixels && refresh's screen
void setup() {
  size(600, 600);
  scale = 1;

  bgColor = 0xFF222222;

  xMin = -2.5;
  xMax = 1.5;
  yMin = -2;
  yMax = 2;
  maxIter = 100;

  plotW = 580;
  plotH = 580;
  plotX = 10;
  plotY = 10;
  newPlotW = l - x1;
  newPlotH = w - y1;


  plotImage = createImage(plotW, plotH, RGB);
  plotImage.loadPixels(); //makes the pixels available for editing.

  // plots and refreshes at given points
  plot();
  refreshScreen();
}

// if space is pressed then invert colors
void keyPressed() {
  if (keyPressed && key == ' ') {
    filter(INVERT);
  }
}

// redraw background && replot image with frame of plotX, and plotY
void refreshScreen() {
  background(bgColor);
  image(plotImage, plotX, plotY);
}

// plots and colors every individual pixel 
void plot() {

  for (int x = 0; x < plotW; x++) {
    for (int y = 0; y < plotH; y++) {
      int loc = plotImage.width*y + x;
      // call calcMandel and save number of steps
      int numSteps = 0;
      numSteps = calcMandel(0, 0, bitmapPixToX(x), bitmapPixToY(y), 0);
      println(numSteps);
      // send the number of steps to colorByEscapeTime
      int colorSave = colorByEscapeTime(numSteps);
      // save the color from colorByEscapeTime and assign it to the pixel
      plotImage.pixels[loc] = colorSave;
      if (numSteps > 12 && numSteps < 25) {
        plotImage.pixels[loc] = #00ffbb;
      }
      if (numSteps > 10 && numSteps < 13) {
        plotImage.pixels[loc] = #ff80b3;
      }
      //update pixels
      plotImage.updatePixels();
    }
  }
}

// needed for mousePressed && mouseDragged, etc...
void draw() {
}

// defines corner points
void mousePressed() {
  x1 = mouseX;
  y1 = mouseY;
}

// defines other corner points && length && width && draws rectangle
void mouseDragged() {
  x2 = mouseX;
  y2 = mouseY;
  l = mouseX - x1;
  w = mouseY - y1;
  noStroke();
  refreshScreen();
  fill(211, 79, 197, 15);
  rect(x1, y1, l, w);
}

// update coords
// plot
// refresh screen
void mouseReleased() {
  xMin = bitmapPixToX(x1);
  xMax = bitmapPixToX(x2);
  yMin = bitmapPixToY(y2);
  yMax = bitmapPixToY(y1);
  plot();
  refreshScreen();
}


// calculates numSteps so that the plot function knows which colors to use
int calcMandel(float za, float zb, float ca, float cb, int numSteps) {
  if (numSteps > maxIter) {
    return numSteps;
  } else {
    // calculate magnitude of z
    float magZ = za * za + zb * zb;
    // if z*2 > 4 return numsteps
    if (magZ > 4) {
      return numSteps;
    }
    // otherwise calc new z
    else {
      float newza = za * za - zb * zb + ca;
      float newzb = 2 * zb * za + cb;
      // update steps - steps ++
      numSteps++;
      // call calcMandel again with new z
      numSteps = calcMandel(newza, newzb, ca, cb, numSteps);
      return numSteps;
    }
  }
}

// calculates lerpColor so that its not just one color
int colorByEscapeTime(int i) {
  int color0 = 0x000000;
  int color1 = #70ffa2;
  int numSteps = 20;
  float lerpParam = ((float)(i % numSteps))/(numSteps-1);
  return lerpColor(color0, color1, lerpParam);
}

// goes from pixels to imaginary for X
float bitmapPixToX(float pixX) {
  return xMin + pixX/plotW*(xMax - xMin);
}

// goes from pixels to imaginary for Y
float bitmapPixToY(float pixY) {
  return yMax + pixY/plotH*(yMin - yMax);
}
