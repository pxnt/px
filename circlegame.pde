static int center = 500;

float tick;
String outputText;

int enemyStart = 5;
float enemyAlertSize;
boolean setupEnemyAlert;
boolean doDrawEnemyAlert;

float playerSize = 20;

int score;
int fails;
int wins;
int highscore;

float blobX = center;
float blobY = center;
int moveStart;
float moveBlobX;
float moveBlobY;
int blobSize = 50;

float enemyX = center;
float enemyY = center;
int enemySize = 20;
float enemyLimiter = (100 - (score - enemyStart + 1)/5);
boolean doDrawEnemy = false;

void setup(){
  size(1000,1000);
};

void generateNew(){ //generate new blob
  blobX = (100 + random(800));
  blobY = (100 + random(800));
  if (score > moveStart){
  moveBlobX = (random(2+0.2*score) - (1+0.1*score));
  moveBlobY = (random(2+0.2*score) - (1+0.1*score));
  } else {
  moveBlobX = 0;
  moveBlobY = 0;
  }
}

void successRun(){
   wins++;
   generateNew();
   score++;
   fill(0, 255, 0);
   println("success | tick: " + tick + " | score: " + score);
   tick = 0;
}

void failRun(String reason){
   fails++;
   generateNew();
   score -= 2;
   fill(255, 0, 0);
   println("fail: " + reason + " | tick: " + tick + " | score: " + score);
   tick = 0;
}

void moveBlob(){
  blobX = blobX + moveBlobX;
  blobY = blobY + moveBlobY;
}

void tickIncrement(){
  tick += 1+score/50; //counter increment each round, will fail at 200   
}

void blobWallTeleports(){
 if(blobX >= 1010)
     {blobX = 5; tick -= 20;}
 if(blobY >= 1010)
     {blobY = 5; tick -= 20;}
 if(blobX <= -10)
     {blobX = 1005; tick -= 20;}
 if(blobY <= -10)
     {blobY = 1005; tick -= 20;}  
}

void drawBlob(){
 fill(0,0,0,0);
 stroke(0+tick, 0, 255-tick);
 circle(blobX, blobY, blobSize);
}

void enemyAlert(){
  if(setupEnemyAlert == true){
    println("called setupEnemyAlert successfully");
    doDrawEnemyAlert = true;
    enemyAlertSize = 200;
    enemyX = center;
    enemyY = center;
    setupEnemyAlert = false;
  } else if (doDrawEnemyAlert && enemyAlertSize > 20) {
    enemyAlertSize -= 1;
    drawEnemyAlert();
  } else if (doDrawEnemyAlert && enemyAlertSize <= 20) {
    println("drawing enemy from now on");
    drawEnemyAlert();
    doDrawEnemyAlert = false;
    doDrawEnemy = true;
  }
}

void drawEnemyAlert(){
  stroke(200,0,0);
  fill ((-1 * enemyAlertSize) + 200, 0, 0);
  circle(center, center, enemyAlertSize);
  stroke(255);
}

void moveEnemy(){
  if(score >= enemyStart){
    if (!doDrawEnemy && !doDrawEnemyAlert) {
      setupEnemyAlert = true;
    } else if (!doDrawEnemyAlert) {
      if (enemyX < mouseX) {
        enemyX = enemyX + (1 + (dist(enemyX, enemyX, mouseX, mouseX)/enemyLimiter));
      } else {
        enemyX = enemyX - (1 + (dist(enemyX, enemyX, mouseX, mouseX)/enemyLimiter));
      }
      if (enemyY < mouseY) {
        enemyY = enemyY + (1 + (dist(enemyY, enemyY, mouseY, mouseY)/enemyLimiter));
      } else {
        enemyY = enemyY - (1 + (dist(enemyY, enemyY, mouseY, mouseY)/enemyLimiter));
      }
      drawEnemy();
    }
  } else if (score < 10 && doDrawEnemy){
    doDrawEnemy = false;
  }
}

void drawEnemy(){
  stroke(255);
  fill(200,0,0);
  stroke(0);
  circle(enemyX, enemyY, 20);
}

void checkConditions(){
 if(dist(mouseX, mouseY, blobX, blobY) < (blobSize + playerSize)/2){
    successRun();
  } else if(tick >= 200) {
    failRun("timeout");
  } else if (doDrawEnemy && dist(mouseX, mouseY, enemyX, enemyY) < (enemySize + playerSize)/2){
    failRun("collide");
    enemyX = center;
    enemyY = center;
  }
  if (score < 0) {score = 0;}
}

void updateHighScore(){
 if(score > highscore){highscore = score;}
 outputText = "" + highscore;
}

void enemyStatus(){
  if (!doDrawEnemy && !doDrawEnemyAlert){
    outputText = "Currently not drawing anything.";
  } else if (doDrawEnemyAlert){
    outputText = "Currently drawing Enemy Alert at size " + enemyAlertSize;
  } else {
    outputText = "Drawing Enemy at " + enemyX + ", " + enemyY;
  }
}

void scoreDisplay(){
  fill (0, 255, 0);
  updateHighScore();
  text("Highscore: "+ outputText, 20, 30);
  text("Score: "+ score, 20, 40);
  text("Wins: " + wins, 20, 50);
  text("Fails: " + fails, 20, 60);
  text("Tick: " + round(tick/20), 20, 80);
  enemyStatus();
  text("EnemyStatus: " + outputText, 20, 100);
}

void draw(){
  background(0); //canvas reset  
  
  tickIncrement(); 
  moveBlob();
  blobWallTeleports();
  drawBlob();
  
  moveEnemy();
  enemyAlert();
  
  fill(0,0,0,0);
  stroke(255);
  if(mousePressed){playerSize += 5;} else if(playerSize > 20){playerSize--;}
  circle(mouseX,mouseY, playerSize); //mouse circle
  line(blobX, blobY, mouseX, mouseY);
  
  checkConditions();  
  scoreDisplay();    
};
