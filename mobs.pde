/*
Possible songs:
Bliss2k
Gorgeous
Crazy


Rings:
- All parts face towards center
- All parts have angZ relative to center in addition to normal ang

Create all Rings from Ring, no subclasses
*/
void createBasicRing(PVector p, float w, float w2, int num) {
	Ring ring = new Ring(p);
	for (int i = 0 ; i < num ; i ++) {
		MobF box = new Pyramid(new PVector(0,w,0), (float)i/num*2*PI, new PVector(w2,w2,w2));
		box.fillStyle.setC(15,15,15,255);
		box.fillStyle.setM(5,5,5,5);
		box.fillStyle.index = (int)((float)i/num*binCount);
		ring.parts.add(box);
	}
	mobs.add(ring);
	rings.add(ring);
}

void createPanelRing(PVector p, float w, float w2, PVector[] vertices, int num) {
	Ring ring = new Ring(p);
	for (int i = 0 ; i < num ; i ++) {
		PVector[] vert = new PVector[vertices.length];
		for (int k = 0 ; k < vertices.length ; k ++) {
			vert[k] = vertices[k].copy();
		}
		Panel panel = new Panel(new PVector(0,w,0), w2, (float)i/num*2*PI, vert);
		panel.fillStyle.setC(255,255,255,255);
		ring.parts.add(panel);
		
	}
	mobs.add(ring);
	rings.add(ring);
}

void createPolyRing(PVector p, float w, Panel[] panels, int num) {
	Ring ring = new Ring(p);
	for (int i = 0 ; i < num ; i ++) {
		Panel[] pan = new Panel[panels.length];
		for (int k = 0 ; k < panels.length ; k ++) {
			pan[k] = panels[k].copy();
		}
		Poly poly = new Poly(new PVector(0,w,0), pan);
		poly.angZ.X = (float)i/num*2*PI;
		ring.parts.add(poly);
		
	}
	mobs.add(ring);
	rings.add(ring);
}
class Ring extends Mob {

	ArrayList<Mob> parts = new ArrayList<Mob>();
	Point av = new Point();

	Ring(PVector p) {
		this.p = new Point(p);
	}

	void update() {
		updatePoints();
		for (Mob part : parts) {
			part.update();
		}
		av.update();
		ang.P.add(av.p);
	}

	void render() {
		setDraw();
		for (Mob part : parts) {
			push();
			rotateZ(part.angZ.x);
			part.render();
			pop();
		}
		pop();
	}

	void resetAng(PVector value) {
		av.P = value;
		av.p.x %= 2*PI;
		av.p.y %= 2*PI;
		av.p.z %= 2*PI;
	}

	void setPartZ(float z) {
		for (Mob part : parts) {
			part.p.P.z = z;
		}
	}

	void setPartZ(float z, int step) {
		for (int i = 0 ; i < parts.size() ; i += step) {
			parts.get(i).p.P.z = z;
		}
	}

	void setPartAng(PVector ang) {
		for (Mob part : parts) {
			part.ang.P = ang;
		}
	}

	void setPartAng(PVector ang, int step) {
		for (int i = 0 ; i < parts.size() ; i += step) {
			parts.get(i).ang.P = ang;
		}
	}
}

class Pyramid extends Box {

	 Pyramid(PVector p, float ang, PVector w) {
	 	super(p, ang, w);
	 }

	 void display() {
	 	beginShape(); vertex(-w.p.x/2,0,-w.p.z/2); vertex(w.p.x/2,0,-w.p.z/2); 
	 	vertex(0,w.p.y,0); endShape();
	 	beginShape(); vertex(-w.p.x/2,0,w.p.z/2); vertex(w.p.x/2,0,w.p.z/2); 
	 	vertex(0,w.p.y,0); endShape();
	 	beginShape(); vertex(-w.p.x/2,0,-w.p.z/2); vertex(-w.p.x/2,0,w.p.z/2); 
	 	vertex(0,w.p.y,0); endShape();
	 	beginShape(); vertex(w.p.x/2,0,-w.p.z/2); vertex(w.p.x/2,0,w.p.z/2); 
	 	vertex(0,w.p.y,0); endShape();
	 }
}

class Box extends MobF {

	Point w;

	Box(PVector p, float ang, PVector w) {
		this.p = new Point(p);
		this.w = new Point(w);
		this.angZ = new SpringValue(ang);
	}

	void update() {
		updatePoints();
		w.update();
		angZ.update();
	}

	void display() {
		box(w.p.x,w.p.y,w.p.z);
	}
}

class Poly extends Mob {
	Panel[] panels;

	Poly(PVector p, Panel[] panels) {
		this.p = new Point(p);
		this.panels = panels;
	}

	void render() {
		push();
		translate(p.p.x,p.p.y,p.p.z);
		rotateX(ang.p.x);
		rotateY(ang.p.y);
		rotateZ(ang.p.z);
		for (Panel panel : panels) {
			panel.render();
		}
		pop();
	}

	void update() {
		updatePoints();
		for (Panel panel : panels) {
			panel.update();
		}
	}
}

class Panel extends MobF {
	float w;
	PVector[] vertices;

	Panel(PVector p, float w, float ang, PVector[] vertices) {
		this.p = new Point(p);
		this.ang = new Point();
		this.angZ = new SpringValue(ang);
		this.w = w;
		this.vertices = new PVector[vertices.length];
		for (int i = 0 ; i < vertices.length ; i ++) {
			this.vertices[i] = vertices[i].mult(w);
		}

	}

	void update() {
		updatePoints();
		angZ.update();
	}

	void render() {
		setDraw();
		beginShape();
		for (int i = 0 ; i < vertices.length ; i ++) {
			vertex(vertices[i].x, vertices[i].y, vertices[i].z);
		}
		endShape();
		pop();

	}

	Panel copy() {
		return new Panel(p.P.copy(), w, angZ.X, copyPVectorArray(vertices));
	}
}

abstract class Mob {
	boolean finished = false;
	boolean draw = true;
	Point p;
	SpringValue sca = new SpringValue(1);
	Point ang = new Point();
	SpringValue angZ;
	
	void updatePoints() {
		p.update();
		ang.update();
		sca.update();
	}

	void setDraw() {
		push();
		translate(p.p.x, p.p.y, p.p.z);
		rotateX(ang.p.x);
		rotateY(ang.p.y);
		rotateZ(ang.p.z);
	}

	void update() {
		updatePoints();
	}

	void render() {
		setDraw();
		display();
		pop();
	}

	void display() {
	}
}

abstract class MobF extends Mob {
	IColor fillStyle = new IColor();
	IColor strokeStyle = new IColor();

	void updatePoints() {
		p.update();
		ang.update();
		sca.update();
		fillStyle.update();
		strokeStyle.update();
	}

	void setDraw() {
		push();
		fillStyle.fillStyle();
		strokeStyle.strokeStyle();
		translate(p.p.x, p.p.y, p.p.z);
		rotateX(ang.p.x);
		rotateY(ang.p.y);
		rotateZ(ang.p.z);
	}
}