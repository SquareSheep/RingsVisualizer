void createBasicRing(String type, PVector p, float w, float w2, int num, float rm, float gm, float bm) {
	Ring ring = new Ring(p);
	for (int i = 0 ; i < num ; i ++) {
		Poly box = newPoly(type, new PVector(0,w,0), w2);
		box.p = new Point(0,w,0);
		box.setC(25,25,25,125);
		box.setM(rm, gm, bm,5);
		for (int k = 0 ; k < box.fillStyle.length ; k ++) {
			box.fillStyle[k].index = (int)((float)i/num*binCount);
		}
		ring.addPart(box, (float)i/num*2*PI);
	}
	mobs.add(ring);
	rings.add(ring);
}

class Ring extends Mob {

	ArrayList<Mob> parts = new ArrayList<Mob>();
	ArrayList<SpringValue> angs = new ArrayList<SpringValue>();
	Point av = new Point();

	Ring(PVector p) {
		this.p = new Point(p);
	}

	void update() {
		updatePoints();
		for (Mob part : parts) {
			part.update();
		}
		for (SpringValue ang : angs) {
			ang.update();
		}
		av.update();
		ang.P.add(av.p);
	}

	void render() {
		setDraw();
		for (int i = 0 ; i < parts.size() ; i ++) {
			push();
			rotateZ(angs.get(i).x);
			parts.get(i).render();
			pop();
		}
		pop();
	}

	void addPart(Mob part, float ang) {
		parts.add(part);
		angs.add(new SpringValue(ang));
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
		scale(sca.x);
	}
}

abstract class Mob {
	boolean finished = false;
	boolean draw = true;
	Point p;
	SpringValue sca = new SpringValue(1, 0.5, 10);
	Point ang = new Point();
	
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
		scale(sca.x);
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