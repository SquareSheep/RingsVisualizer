class IColor extends AColor {
  float rm;
  float gm;
  float bm;
  float am;
  int rc;
  int gc;
  int bc;
  int ac;
  int index;
  int rup = 1;
  int gup = 1;
  int bup = 1;

  IColor(float rm, float gm, float bm, float am, float rc, float gc, float bc, float ac, float index) {
  	super(rc, gc, bc, ac);
  	this.rm = rm; this.gm = gm; this.bm = bm; this.am = am;
  	this.rc = (int)rc; this.gc = (int)gc; this.bc = (int)bc; this.ac = (int)ac;
  	this.index = (int)index;
  }

  IColor(float rc, float gc, float bc, float ac) {
  	this(0,0,0,0, rc,gc,bc,ac, 0);
  }

  IColor() {
    this(0,0,0,0, 0,0,0,0, 0);
  }

  void update() {
    r.X = av[index] * rm + rc;
    g.X = av[index] * gm + gc;
    b.X = av[index] * bm + bc;
    a.X = av[index] * am + ac;
    r.update();
    g.update();
    b.update();
    a.update();
  }

  void setM(float rm, float gm, float bm, float am) {
  	this.rm = rm;
  	this.gm = gm;
  	this.bm = bm;
  	this.am = am;
  }

  void setC(float rc, float gc, float bc, float ac) {
  	this.rc = (int)rc;
  	this.gc = (int)gc;
  	this.bc = (int)bc;
  	this.ac = (int)ac;
  }
}

class AColor {
  SpringValue r;
  SpringValue g;
  SpringValue b;
  SpringValue a;
  AColor(float R, float G, float B, float A, float vMult, float mass) {
    this.r = new SpringValue(R, vMult, mass);
    this.g = new SpringValue(G, vMult, mass);
    this.b = new SpringValue(B, vMult, mass);
    this.a = new SpringValue(A, vMult, mass);
  }

  AColor(float R, float G, float B, float A) {
    this(R, G, B, A, defaultVMult, defaultMass);
  }

  AColor copy() {
    return new AColor(r.X, g.X, b.X, a.X, r.vMult, r.mass);
  }
  void update() {
    r.update();
    g.update();
    b.update();
    a.update();
  }

  void fillStyle() {
    fill(r.x, g.x, b.x, a.x);
  }

  void strokeStyle() {
    stroke(r.x, g.x, b.x, a.x);
  }

  void addx(AColor other) {
    this.r.x += other.r.x;
    this.g.x += other.g.x;
    this.b.x += other.b.x;
    this.a.x += other.a.x;
  }

  void addX(AColor other) {
    this.r.X += other.r.X;
    this.g.X += other.g.X;
    this.b.X += other.b.X;
    this.a.X += other.a.X;
  }

  void setx(float r, float g, float b, float a) {
    this.r.x = r;
    this.g.x = g;
    this.b.x = b;
    this.a.x = a;
  }

  void setX(float r, float g, float b, float a) {
    this.r.X = r;
    this.g.X = g;
    this.b.X = b;
    this.a.X = a;
  }

  void setMass(float mass) {
    this.r.mass = mass;
    this.g.mass = mass;
    this.b.mass = mass;
    this.a.mass = mass;
  }

  void setVMult(float vMult) {
    this.r.vMult = vMult;
    this.g.vMult = vMult;
    this.b.vMult = vMult;
    this.a.vMult = vMult;
  }

  void addx(float R, float G, float B, float A) {
    this.r.x += R;
    this.g.x += G;
    this.b.x += B;
    this.a.x += A;
  }
}

class Point {
  PVector p;
  PVector P;
  PVector v = new PVector(0,0,0);
  float vMult;
  float mass;

  Point(PVector p, float vMult, float mass) {
    this.p = p;
    this.P = p.copy();
    this.vMult = vMult;
    this.mass = mass;
  }

  Point() {
    this(new PVector(0,0,0), defaultVMult, defaultMass);
  }

  Point(PVector p) {
    this(p, defaultVMult, defaultMass);
  }

  Point(float x, float y, float z) {
    this(new PVector(x, y, z), defaultVMult, defaultMass);
  }

  Point(float x, float y, float z, float vMult, float mass) {
    this(new PVector(x, y, z), vMult, mass);
  }

  void update() {
    v.mult(vMult);
    v.add(PVector.sub(P,p).div(mass));
    p.add(v);
  }

  void move() {
    translate(p.x,p.y,p.z);
  }

  Point copy() {
    return new Point(p.copy(), vMult, mass);
  }
}

class SpringValue {
  float x;
  float X;
  float v = 0;
  float vMult;
  float mass;

  SpringValue(float x, float vMult, float mass) {
    this.x = x;
    this.X = x;
    this.vMult = vMult;
    this.mass = mass;
  }

  SpringValue(float x) {
    this(x, defaultVMult, defaultMass);
  }

  void update() {
    v += (X - x)/mass;
    v *= vMult;
    x += v;
  }
}

class BeatTimer {
  int offset;
  float bpm;
  float sec;
  int threshold;
  boolean beat = false;
  boolean beatAlready = false;
  int tick = 1;

  BeatTimer(int threshold, int offset, float bpm) {
    this.bpm = bpm;
    this.sec = sec;
    this.offset = offset;
    this.threshold = threshold;
  }

  void update() {
    float currMil = (currTime + offset) % (60000.0/bpm);
    if (!beatAlready && currMil < threshold) {
      beat = true;
      beatAlready = true;
      tick ++;
      if (tick > 4) tick = 1;
    } else {
      beat = false;
    }
    if (currMil > threshold) {
      beatAlready = false;
    }
  }
}

class Camera {
  Point p;
  Point ang;
  PVector dp;
  PVector dang;
  boolean lock = true;

  Camera(float x, float y, float z) {
    this.p = new Point(x, y, z);
    this.dp = this.p.p.copy();
    this.ang = new Point();
    this.dang = new PVector();
    this.ang.mass = 10;
    this.ang.vMult = 0.5;
  }

  void update() {
	if (!lock) {
		cam.ang.P.y = (float)mouseX/width*2*PI - PI;
		cam.ang.P.x = -(float)mouseY/height*2*PI - PI;
	}
    p.update();
    ang.update();
  }

  void render() {
    camera();
    translate(p.p.x,p.p.y,p.p.z);
    rotateX(ang.p.x);
    rotateY(ang.p.y);
    rotateZ(ang.p.z);
  }
}