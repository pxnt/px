final int baseDifficulty = 3;
int mid = 250;
float difficulty = baseDifficulty;

//ball
float bx = mid-100;
float by = mid;
float vx = difficulty;
float vy = difficulty;
int bsize = 25;
int br = bsize/2;

//player
final float px = 450;
float py = mid;
int pwidth = 50;
int pbroadth = 10;
float ptop = py-(pwidth/2);
float pbottom = py+(pwidth/2);

//enemy
final float ex = 50;
float ey = mid;
int ewidth = 50;
int ebroadth = 10;
float etop = ey-(ewidth/2);
float ebottom = ey+(ewidth/2);

//score
int pScore = 0;
int eScore = 0;

//setup
void setup() {
  size(500, 500);
  //frameRate(30);
  rectMode(CENTER);
  textAlign(CENTER);
}

//reverses x when the ball is heading at the wall he is closer to
void reverseVx() {
  if (bx < mid && vx < 0 || mid < bx && 0 < vx) {
    vx *= -1;
  }
}

//reverses y when the ball is heading at the wall he is closer to
void reverseVy() {
  if (by < mid && vy < 0 || mid < by && 0 < vy) {
    vy *= -1;
  }
}

//moves the player up and down
void keyboardInput() {
  if (keyPressed && key == CODED) {
    if (keyCode == DOWN) {
      py += 5;
      if (height-25 < py) {
        py = height-25;
      }
    } else if (keyCode == UP) {
      py -= 5;
      if (py < 25) {
        py = 25;
      }
    }
  }
}

void bounceCheck(float x1, float y1, float x2, float y2, float pos) {
  if (dist(x1, y1, x2, y2) < br) {
    reverseVx();
    vy = -1 * (((pos-y2)/50)*difficulty);
    println("bounceCheck Success");
  }
}

void updateValues() {
  ptop = py-(pwidth/2);
  pbottom = py+(pwidth/2);
  etop = ey-(ewidth/2);
  ebottom = ey+(ewidth/2);

  difficulty = baseDifficulty+(pScore/2)-(eScore/4);

  bx += vx;
  by += vy;
  //bx = mouseX;
  //by = mouseY;
}

void bouncePlayer() {
  if (px < bx+br && bx+br < px+br) {
    if (by > ptop && pbottom > by) {
      reverseVx();
      vy = -1 * (((py - by)/50)*difficulty);
      println("bounce mitte");
    } else {
      bounceCheck(px, pbottom, bx, by, py);
      bounceCheck(px, ptop, bx, by, py);
    }
  }
}

void bounceEnemy() {
  if (ex > bx-br && bx-br > ex-br) {
    if (by > etop && ebottom > by) {
      reverseVx();
      vy = (((by - ey)/50)*difficulty);
      println("enemy bounce mitte");
    } else {
      bounceCheck(ex, ebottom, bx, by, ey);
      bounceCheck(ex, etop, bx, by, ey);
    }
  }
}

void wallsCheck() {
  if (by < br) {
    by = br; 
    reverseVy();
    println("oben");
  }
  if (height-br < by) {
    by = height-br; 
    reverseVy();
    println("unten");
  }
}

void updateEnemy() {
  if (by+10 < ey && bx < mid*1 && vx < 0) {
    ey -= difficulty-0.5;
  } else if (ey < by-10 && bx < mid && vx < 0) {
    ey += difficulty-0.5;
  }
}

void deathCheck() {
  if (bx > width-br) {  
    println("fail");
    bx = mid+100;
    by = mid;
    vx *= -1;
    vy = difficulty/random(3, 5);
    eScore++;
  } else   if (bx < 0) {  
    println("win");
    bx = mid-100;
    by = mid;
    vx *= -1;
    vy = -1 * (difficulty/random(3, 5));
    pScore++;
  }
}

void debugText() {
  fill(150);
  noStroke();
  textSize(10);
  text("ptop: " + int(ptop) + ", pbottom: " + int(pbottom) + ", bx: " + int(bx) + ", by: " + int(by) + ", mouseX: " + int(mouseX) + ", mouseY: " + int(mouseY), mid, height-20);
  text("etop: " + int(etop) + ", ebottom: " + int(ebottom) + ", ey: " + int(ey) + ", py: " + int(py) + ", vx: " + int(vx) + ", vy: " + int(vy) + ", difficulty: " + difficulty, mid, height-10);
}

void gameText() {
  fill(255);
  noStroke();
  textSize(50);
  text(pScore, mid, 75);
  text(eScore, mid, height-50);
}

void drawObjects() {
  fill(255);
  noStroke();
  circle(bx, by, bsize);
  rect(px+pbroadth/2, py, pbroadth, pwidth);  
  rect(ex-ebroadth/2, ey, ebroadth, ewidth);
}

void draw() {
  background(0);
  keyboardInput();
  updateValues();
  wallsCheck();
  bouncePlayer();
  updateEnemy();
  bounceEnemy();
  deathCheck();
  debugText();
  gameText();
  drawObjects();
  //saveFrame("gif/mySketch-####.jpg");
}
