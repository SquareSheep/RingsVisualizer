static float bpm = 106;
static float mspb = 1;
static float framesPerBeat = 1;
static float cos60 = cos(PI/3);
static float sin60 = sin(PI/3);

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim mim;
AudioPlayer song;
ddf.minim.analysis.FFT fft;
static int binCount = 144;
float[] av = new float[binCount];
float max;
float avg;

ArrayList<Event> events = new ArrayList<Event>();
ArrayList<Mob> mobs = new ArrayList<Mob>();
ArrayList<Ring> rings = new ArrayList<Ring>();
Camera cam;

// GLOBAL ANIMATION VARIABLES -------------------

static int de; //width of screen de*2
static int aw; //Animation depth
static PVector front;
static PVector back;
static float defaultMass = 3;
static float defaultVMult = 0.3;


BeatTimer timer;
int currTime;
int currBeat;

// ---------------------------------------------


void setup() {
  frameRate(60);
  //fullScreen(P3D);
  size(800, 800,P3D);

  de = (int)(min(width,height)*1);
  aw = (int)(4*de);
  front = new PVector(-de*2,de*1.2,de*0.4);
  back = new PVector(de*2,-de*2,-aw);

  cam = new Camera(de/2, de/2, -de*1.2);
  cam.ang.P.set(0,0,0);

  textSize(de/10);

  rectMode(CENTER);
  textAlign(CENTER);

  mim = new Minim(this);
  song = mim.loadFile("chaos.mp3", 1024);
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  addEvents();

  song.loop();
  song.setGain(-25);

  timer = new BeatTimer(50,0,bpm);

  createBasicRing(new PVector(0,0,0), de*0.75, de*0.18,25);
  createBasicRing(new PVector(0,0,0), de*0.65, de*0.16,25);
  createBasicRing(new PVector(0,0,0), de*0.55, de*0.14,25);
  createBasicRing(new PVector(0,0,0), de*0.45, de*0.12,25);
  // createPanelRing(new PVector(0,0,0), de*0.5, de*0.1, new PVector[]{
  // 	new PVector(0,1,0), new PVector(1,0,0), new PVector(-1,-1,0)}, 10);
  // createPanelRing(new PVector(0,0,0), de*0.5, de*0.1, new PVector[]{
  // 	new PVector(1,1,0), new PVector(1,0,0), new PVector(-1,-1,0)}, 10);
  rings.get(0).av.P.set(0,0.02,0.1);
  rings.get(0).ang.P.x = PI*0.65;
  rings.get(1).av.P.set(0,0.007,0.05);
  rings.get(1).ang.P.x = -PI*0.8;
  rings.get(2).av.P.set(0,-0.002,-0.15);
  rings.get(2).ang.P.x = PI;
  rings.get(3).av.P.set(0,-0.01,0.07);
  rings.get(3).ang.P.x = -PI*1.6;
}

void draw() {
  update();

  cam.render();

  background(0);

  // drawBorders();
  // drawWidthBox(de);
  // drawPitches();
  // push();
  // translate(0,de*0.5,0);
  // text(currBeat,0,0);
  // pop();

  for (Mob mob : mobs) {
    if (mob.draw) mob.render();
  }
}

void update() {
  calcFFT();

  currTime = song.position();
  if (timer.beat) currBeat ++;

  cam.update();
  timer.update();

  updateEvents();
  updateMobs();
}

void updateEvents() {
  for (int i = 0 ; i < events.size() ; i ++) {
    Event event = events.get(i);
    if (currBeat >= event.time && currBeat < event.timeEnd) {
      if (!event.spawned) {
        event.spawned = true;
        event.spawn();
      }
      event.update();
    }
  }
}

void updateMobs() {
  for (Mob mob : mobs) {
    mob.update();
  }

  for (int i = 0 ; i < mobs.size() ; i ++) {
    if (mobs.get(i).finished) mobs.remove(i);
  }
}