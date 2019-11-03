Poly newPoly(String type, PVector p, float w) {
	if (type == "Pyramid") return new Poly(p, w, new PVector(0,0,0), new float[]{-1,0,-1, -1,0,1, 1,0,1, 1,0,-1, 0,-2,0}, new int[][]{
		new int[]{0,1,2,3}, new int[]{0,1,4}, new int[]{1,2,4}, new int[]{2,3,4}, new int[]{3,0,4}
	});
	if (type == "Box") return new Poly(p, w, new PVector(0,0,0), new float[]{-1,-1,-1, -1,-1,1, -1,1,1, -1,1,-1, 1,-1,-1, 1,-1,1, 1,1,1, 1,1,-1}, new int[][]{
		new int[]{0,1,2,3}, new int[]{0,1,5,4}, new int[]{1,2,6,5}, new int[]{2,3,7,6}, new int[]{0,3,7,4}, new int[]{4,5,6,7}
	});
	return new Poly();
}

class Poly extends Mob {
	float w;
	Point[] points;
	IColor[] fillStyle;
	int[][] faces;

	Poly() {}

	Poly(PVector p, float w, PVector ang, float[] vertices, int[][] faces) {
		this.p = new Point(p);
		this.ang = new Point(ang);
		this.w = w;

		float max = 0;
		for (int i = 0 ; i < vertices.length ; i ++) {
			if (vertices[i] > max) max = vertices[i];
		}
		for (int i = 0 ; i < vertices.length ; i ++) {
			vertices[i] /= max;
		}

		this.points = new Point[vertices.length/3];
		for (int i = 0 ; i < vertices.length ; i += 3) {
			this.points[i/3] = new Point(vertices[i]*w, vertices[i+1]*w, vertices[i+2]*w);
		}
		this.faces = new int[faces.length][];
		this.fillStyle = new IColor[faces.length];
		for (int i = 0 ; i < faces.length ; i ++) {
			this.faces[i] = new int[faces[i].length];
			for (int k = 0 ; k < faces[i].length ; k ++) {
				this.faces[i][k] = faces[i][k];
			}
			this.fillStyle[i] = new IColor(125,125,125,255);
		}
	}

	Poly(PVector p, float w, float[] vertices, int[][] faces) {
		this(p, w, new PVector(0,0,0), vertices, faces);
	}

	void render() {
		setDraw();
		for (int i = 0 ; i < faces.length ; i ++) {
			push();
			fillStyle[i].fillStyle();
			beginShape();
			for (int k = 0 ; k < faces[i].length ; k ++) {
				vertex(points[faces[i][k]].p.x, points[faces[i][k]].p.y, points[faces[i][k]].p.z);
			}
			vertex(points[faces[i][0]].p.x, points[faces[i][0]].p.y, points[faces[i][0]].p.z);
			endShape();
			pop();
		}
		pop();
	}

	void update() {
		updatePoints();
		for (int i = 0 ; i < points.length ; i ++) {
			points[i].update();
		}
		for (int i = 0 ; i < fillStyle.length ; i ++) {
			fillStyle[i].update();
		}
	}

	void setC(float r, float g, float b, float a) {
		for (int i = 0 ; i < fillStyle.length ; i ++) {
			fillStyle[i].setC(r, g, b, a);
		}
	}

	void setM(float r, float g, float b, float a) {
		for (int i = 0 ; i < fillStyle.length ; i ++) {
			fillStyle[i].setM(r, g, b, a);
		}
	}
}
