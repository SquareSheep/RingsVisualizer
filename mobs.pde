class Poly extends Mob {
	float w;
	Panel[] panels;

	Poly(PVector p, float w, Panel[] panels) {
		this.p = new Point(p);
		this.w = w;
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

	Panel(PVector p, PVector ang, float w, PVector[] vertices) {
		this.p = new Point(p);
		this.ang = new Point(ang);
		this.w = w;
		this.vertices = new PVector[vertices.length];
		for (int i = 0 ; i < vertices.length ; i ++) {
			this.vertices[i] = vertices[i].mult(w);
		}

	}

	Panel(PVector p, float w, PVector[] vertices) {
		this.p = new Point(p);
		this.ang = new Point();
		this.w = w;
		this.vertices = new PVector[vertices.length];
		for (int i = 0 ; i < vertices.length ; i ++) {
			this.vertices[i] = vertices[i].mult(w);
		}

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
}

abstract class Mob {
	boolean finished = false;
	boolean draw = true;
	Point p;
	SpringValue sca = new SpringValue(1);
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
	}

	void update() {
		updatePoints();
	}

	abstract void render();
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