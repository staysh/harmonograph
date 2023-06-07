/********************************
  Station's Harmonograph
  (or Basically an XY Oscilloscope)
  This sketch plots points (2x2 rectangles)
  using the amplitude of one signal for the x
  coordinate and the amplitude of the other signal
  (some ratio of the base signal) as the y coordinate
*****************************************************/

import controlP5.*;
import processing.sound.*;

SinOsc sine1, sine2;
ControlP5 cp5;
Slider s1, s2, s3, s4, s5;

int resolution = 3600;   //number of points to plot
int size = 100;           // distance from origin for max values
float ratio = 3.0/2.0;    //
float inc = 0.01;         // basically "time" or something...
float base = 211.0;       //root note
int equalstep = 0;
float numerator = 1.0;
float denominator = 1.0;
float ratioBuffer = ratio;

void setup () {
  size(800,800);          //sets the size of the window
  
  cp5 = new ControlP5(this);
  sine1 = new SinOsc(this);
  sine2 = new SinOsc(this);
  
  sine1.amp(0.5);
  sine2.amp(0.5);
  sine1.freq(base);
  sine2.freq(ratio * base);
  //sine1.play();
  //sine2.play();
  
  s1 = cp5.addSlider("ratio")
    .setPosition(100,20)
    .setSize(600,20)
    .setRange(1.0,2.0);
  
  s2 = cp5.addSlider("equalstep")
    .setPosition(100,770)
    .setSize(600,20)
    .setRange(0,12)
    .setNumberOfTickMarks(13);
  
  s2.addCallback(new CallbackListener() {
     public void controlEvent(CallbackEvent theEvent) {
       if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
         s1.setValue(pow(2.0, floor(s2.getValue()) / 12.0));
       }
     }
  });
  
  s3 = cp5.addSlider("numerator")
    .setPosition(10,100)
    .setSize(10,600)
    .setRange(1.0,20.0)
    .setNumberOfTickMarks(20);
    
  s4 = cp5.addSlider("denominator")
    .setPosition(60,100)
    .setSize(10,600)
    .setRange(1.0,20.0)
    .setNumberOfTickMarks(20);
  
  s5 = cp5.addSlider("resolution")
    .setPosition(750,100)
    .setSize(20,600)
    .setRange(1000,10000);
  
  s3.addCallback(new CallbackListener() {
     public void controlEvent(CallbackEvent theEvent) {
       if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
         s1.setValue(s3.getValue() / s4.getValue());
       }
     }
  });
  s4.addCallback(new CallbackListener() {
     public void controlEvent(CallbackEvent theEvent) {
       if (theEvent.getAction()==ControlP5.ACTION_BROADCAST) {
         s1.setValue(s3.getValue() / s4.getValue());
       }
     }
  });
}

void draw () {
  background(10);         // redraws the background every frame
  if(ratioBuffer != ratio)
  {
    sine2.freq(base * ratio);
    ratioBuffer = ratio;
  }
  pushMatrix();
  translate(width/2, height/2); //relocate the origin in center
  fill(230);              //set fill color
  
  //the resolution can be seen as a 'sampling rate'
  for (int i = 0; i < resolution; i++)
  {
    float x = sin(base * i * (TWO_PI / resolution) + inc) * size;
    float y = sin(base * ratio * i * (TWO_PI / resolution) + inc) * size;
    rect(x, y, 3, 3);
  }
  popMatrix();
  inc += 0.01;
}
