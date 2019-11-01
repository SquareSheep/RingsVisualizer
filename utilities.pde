void calcFFT() {
  fft.forward(song.mix);

  avg = 0;
  max = 0;
  for (int i = 0 ; i < av.length ; i ++) {
    float temp = 0;
    for (int k = i ; k < fft.specSize() ; k += i + 1) {
      temp += fft.getBand(k);
    }
    temp /= av.length / (i + 1);
    temp = pow(temp,1.4);
    avg += temp;
    av[i] = temp;
  }
  avg /= av.length;

  for (int i = 0 ; i < av.length ; i ++) {
    if (av[i] < avg*1.2) {
      av[i] /= 2;
    } else {
      av[i] += (av[i] - avg * 1.2) /2;
    }
    if (av[i] > max) max = av[i];
  }

}

void mousePressed() {
  float temp = ((float)mouseX / width) * song.length();
  song.cue((int)temp);
  currBeat = (int)(song.position()/60000.0*bpm);
}

void seekTo(float time) {
  song.cue((int)time);
}

void keyPressed() {
	if (key == 'e') {
		if (!cam.lock) {
			cam.lock = true;
			cam.ang.P.set(cam.dang.x, cam.dang.y, cam.dang.z);
		} else {
			cam.lock = false;
		}
		println("Cam lock: " + cam.lock);
	} else {
		println("KEY: " + key + " " + currTime + " " + currBeat);
	}
}

void drawPitches() {
  push();
  fill(255);
  translate(0,height,0);
  for (int i = 0 ; i < binCount ; i ++) {
    float w = width/(float)binCount;
    translate(w, 0,0);
    rect(0,0,w,av[i]*10);
  }
  pop();
}

void drawBorders() {
  noFill();
  stroke(255);
  push();
  translate(0,0,-aw);
  rect(0,0,de*2,de*2);
  pop();
  line(de,de,aw,de,de,-aw);
  line(de,-de,aw,de,-de,-aw);
  line(-de,de,aw,-de,de,-aw);
  line(-de,-de,aw,-de,-de,-aw);
}

void renderQuad(PVector p1, PVector p2, PVector p3, PVector p4) {
  beginShape();
  vertex(p1.x, p1.y, p1.z);
  vertex(p2.x, p2.y, p2.z);
  vertex(p3.x, p3.y, p3.z);
  vertex(p4.x, p4.y, p4.z);
  vertex(p1.x, p1.y, p1.z);
  endShape();
}

void drawWidthBox(float w) {
  push();
  textSize(w/10);
  push();
  translate(0,0,0);
  text("0,0,0",0,0);
  pop();

  push();
  translate(w,w,w);
  text("1,1,1",0,0);
  pop();

  push();
  translate(-w,w,w);
  text("-1,1,1",0,0);
  pop();

  push();
  translate(-w,-w,w);
  text("-1,-1,1",0,0);
  pop();

  push();
  translate(w,-w,w);
  text("1,-1,-1",0,0);
  pop();

  push();
  translate(w,w,-w);
  text("1,1,-1",0,0);
  pop();

  push();
  translate(-w,w,-w);
  text("-1,1,-1",0,0);
  pop();

  push();
  translate(-w,-w,-w);
  text("-1,-1,-1",0,0);
  pop();

  push();
  translate(w,-w,-w);
  text("1,-1,-1",0,0);
  pop();
  pop();
}