static float bpm = 145;
static float cos60 = cos(PI/3);
static float sin60 = sin(PI/3);

import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.function.*;

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

void setup() {
  frameRate(60);
  //fullScreen(P3D);
  size(500,500,P3D);

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

  float d = front.z - back.z+aw;
  createBasicRing("Pyramid", new PVector(0,0,front.z - d*0.1), de*0.6, de*0.05,22, 16,0,0);
  createBasicRing("Box", new PVector(0,0,front.z - d*0.15), de*0.65, de*0.05,27, 0,16,5);
  createBasicRing("Pyramid", new PVector(0,0,front.z - d*0.2), de*0.7, de*0.07,32, 18,5,25);
  createBasicRing("Box", new PVector(0,0,front.z - d*0.25), de*0.65, de*0.06,20, 5,5,17);
  createBasicRing("Pyramid", new PVector(0,0,front.z - d*0.3), de*0.75, de*0.07,24, 5,20,5);
  createBasicRing("Box", new PVector(0,0,front.z - d * 0.35), de*0.65, de*0.06,14, 25,5,5);
  createBasicRing("Pyramid", new PVector(0,0,front.z - d*0.4), de*0.6, de*0.05,22, 16,0,0);
  createBasicRing("Box", new PVector(0,0,front.z - d*0.45), de*0.65, de*0.05,27, 0,16,5);
  createBasicRing("Pyramid", new PVector(0,0,front.z - d*0.5), de*0.7, de*0.07,32, 18,5,25);
  createBasicRing("Box", new PVector(0,0,front.z - d*0.55), de*0.65, de*0.06,20, 5,5,17);
  createBasicRing("Pyramid", new PVector(0,0,front.z - d*0.65), de*0.75, de*0.07,24, 5,20,5);
  createBasicRing("Box", new PVector(0,0,front.z - d), de*0.75, de*0.06,14, 25,5,5);
  rings.get(0).av.P.z = 0.01;
  rings.get(1).av.P.z = 0.02;
  rings.get(2).av.P.z = -0.015;
  rings.get(3).av.P.z = 0.013;
  rings.get(4).av.P.z = -0.02;
  rings.get(5).av.P.z = 0.018;
}

void draw() {
  cam.ang.P.x += sin((float)frameCount/100 + PI/2)/500;
  cam.p.P.y += sin((float)frameCount/100 + PI/2)/50;
  for (int i = 0 ; i < rings.size() ; i ++) {
    Ring ring = rings.get(i);
    ring.p.P.z += de*0.015;
    if (ring.p.p.z > front.z + aw) {
      ring.p.P.z = back.z;
      ring.p.p.z = back.z;
      ring.sca.x = 0;
    }
  }

  for (Ring ring : rings) {
    for (int i = 0 ; i < ring.parts.size() ; i ++) {
      Poly part = (Poly) ring.parts.get(i);
      part.points[4].v.y -= av[part.fillStyle[0].index]*part.w*0.03;
    }
  }

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