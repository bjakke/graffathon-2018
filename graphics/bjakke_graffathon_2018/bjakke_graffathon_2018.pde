import moonlander.library.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

int CANVAS_WIDTH = 640;
int CANVAS_HEIGHT = 360;

int BPM = 140;

float initTimeScene1=0;

Moonlander moonlander;

PShape scene4Flower;
PShape scene3Flower;

void settings(){
  fullScreen(P2D);
  //size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
}

void setup(){
  noCursor();
  frameRate(60);
  
  //precalc
  scene3Flower = createFlower(360, 8, 470);
  scene4Flower = createFlower(360, 8, 200);
  
  moonlander = Moonlander.initWithSoundtrack(this, "musa2.wav", BPM, 8);
  moonlander.start("localhost", 1338, "data/graffathon2018.rocket");
  
}

void drawScene5(){
  background(0);
  
  background(0);
  float time = (float) moonlander.getCurrentTime();
  float mtime = (float) moonlander.getValue("scene5Time");

  int counter = 0;
  PShape tmp = scene4Flower;
  for(int i=0; i < 6; i++){
    for(int j=0; j< 5; j++){
      pushMatrix();
      float x1 = map(i,0,5,-640,640);
      float y1 = map(j,0,4,-320,320);
            
      float t = counter*0.5;


      float x2 = cos(t);
      float y2 = sin(2*t)/2;
      x2 = x2*500;
      y2 = y2*500;
      
      float x = map(mtime, 0, 1, x1, x2);
      float y = map(mtime, 0,1, y1, y2);
      
      translate(x,y);
      rotate(radians(time*45));
      scale(0.35);
      shape(tmp);
      
      popMatrix();
      counter++;
    }
  }
}

void drawScene4(){
  background(0);
  float time = (float) moonlander.getCurrentTime();
  float beats = time * (140.0 / 60.0);
  int beat = int(beats) -72; // 72 is offset from start
  //println(beat);
  int counter = 0;
  PShape tmp = scene4Flower;
  for(int i=0; i < 6; i++){
    for(int j=0; j< 5; j++){
      pushMatrix();
      float x = map(i,0,5,-640,640);
      float y = map(j,0,4,-320,320);
            
      translate(x,y);
      rotate(radians(time*45));
      scale(0.35);
      shape(tmp);
      
      popMatrix();
      counter++;
     if(counter > beat){
       return;
     }
    }
  }
  
}

void drawScene3(){
  background(0);
  float t = (float) moonlander.getValue("scene3Time");
  //rotate scene2
  rotate(radians(t));
  PShape p = scene3Flower;
  shape(p);
}

PShape createFlower(float tMax, int k, int size){
  PShape p = createShape();
  p.beginShape();
  p.noFill();
  p.stroke(255);
  p.strokeWeight(10);

  float t = 0;
  while(true){
    if(t > tMax){
      break;      
    }
    float r = radians(t);
    float x = cos(k*r)*cos(r);
    float y = cos(k*r)*sin(r);
    p.vertex(x*size,y*size);
    t = t+0.005;
  }
  p.endShape();
  return p;  
}

void drawScene2(){
  float tMax = (float) moonlander.getValue("scene2Time");
  background(0);
  
  PShape tmp = createFlower(tMax, 8, 470);
  shape(tmp);
}

void drawScene1(){
  float tMax = (float) moonlander.getValue("scene1Time");
  background(0);
  
  noFill();
  stroke(255);
  strokeWeight(20);
  beginShape();
  
  float t = 0;
  while(true){
    t = t+0.005;
    if(t > tMax){
     break; 
    }

    float x = cos(t);
    float y = sin(2*t)/2;
    vertex(x*500,y*500);
    
  }
  endShape();
  
  
}

void drawScene0(){
  background(0);
  
  float time = (float) moonlander.getCurrentTime();
  float beats = time * (140.0 / 60.0);
  int beat = int(beats);
  int counter = 0;
  for(int i=0;i<=20;i++){
    //looks good, but 10->20 error :D
   float x = map(i, 0, 10, -640, 320);
     ellipse(x,0, 60, 60);
     counter++;
     if(counter > beat){
       return;
     }
  }
  
  
}

void draw(){
  moonlander.update();
  float time = (float) moonlander.getCurrentTime();
  //resolution independent scaling
  translate(width/2, height/2);
  scale(height / 1000.0);

  
  int scene = moonlander.getIntValue("scene");
  if(scene == 0){
    drawScene0();
  }else if(scene == 1){
    drawScene1();
  }else if(scene == 2){
    drawScene2();
  }else if(scene == 3){
    drawScene3(); 
  }else if(scene == 4){
    drawScene4();
  }else if(scene == 5){  
    drawScene5();
  }else if(scene > 5){
    exit();
  }else{
   println("Unknown scene number: "+scene); 
  }
  
  println("FPS:"+frameRate+" , time:"+time);
}
