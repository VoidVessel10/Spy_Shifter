
//Cameron Levine

//Note: the animations for walking and jumping are there, just slightly hard to see due to size.

//declaring vars
int state;

PImage backgroundWall;

Player p1;

Platform plat1;
Platform plat2;
Platform plat3;
Platform plat4;
Platform plat5;
Platform plat6;
Platform plat7;

Laser laser1;

Wall wallLeft;
Wall wallRight;

Turret turret1;
Turret turret2;
Turret turret3;


ArrayList<Platform> platformList;
ArrayList<Laser> laserList;
ArrayList<Turret> turretList;
ArrayList<Bullet> bulletList;

//Timer Laser
int startTimeLaser;
int currentTimeLaser;
int intervalLaser;

//Timer Score
int startTimeScore;
int currentTimeScore;
int intervalScore;
int score;

//Timer Turret
int startTimeTurret;
int currentTimeTurret;
int intervalTurret;

//import sound
import processing.sound.*;

//background noise declared
//portal 2 song
SoundFile backgroundNoise;

//declare walk sound
//freesound.org/people/Unlistenable/sounds/414326/
SoundFile walkSound;

//declare jump sound
//myself
SoundFile jumpSound;

//declare bulletFired sound
//https://www.soundgator.com/product/1418-bulletFired-01-sound-effect/
SoundFile bulletFired;

//declare switch sound
//www.soundgator.com/product/2095-whoosh-02-sound-effect/
SoundFile switchSound;

//declare theme sound
//myself
SoundFile theme;

PImage wallImage;

Animation turretAnimation;

PImage[] turretImages = new PImage[6];

PImage defaultBlue;
PImage defaultRed;

void setup() {
  size(1200, 800);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  textSize(75);

  defaultBlue = loadImage("defaultBlue.png");
  defaultRed = loadImage("defaultRed.png");

  wallImage = loadImage("wall.jpg");
  wallImage.resize(width, height);

  backgroundWall = loadImage("wallBackground.jpg");
  backgroundWall.resize(width, height);
  //intitalize vars
  p1 = new Player(width/2, height-25, 50, 50, defaultBlue, defaultRed);

  plat1 = new Platform((int(random(100, 1000))), 700);
  plat2 = new Platform((int(random(100, 1000))), 600);
  plat3 = new Platform((int(random(100, 1000))), 500);
  plat4 = new Platform((int(random(100, 1000))), 400);
  plat5 = new Platform((int(random(100, 1000))), 300);
  plat6 = new Platform((int(random(100, 1000))), 200);
  plat7 = new Platform((int(random(100, 1000))), 100);

  platformList = new ArrayList<Platform>();

  platformList.add(plat1);
  platformList.add(plat2);
  platformList.add(plat3);
  platformList.add(plat4);
  platformList.add(plat5);
  platformList.add(plat6);
  platformList.add(plat7);

  // Laser has a random value to randomize whether or not
  // to have a blue or red laser to start
  laser1 = new Laser(random(1));

  laserList = new ArrayList<Laser>();

  laserList.add(laser1);

  wallLeft = new Wall(10, height-1, wallImage);
  wallRight = new Wall(width - 10, height-1, wallImage);

  turret1 = new Turret(30, 700);
  turret2 = new Turret(30, 400);
  turret3 = new Turret(30, 150);


  turretList = new ArrayList<Turret>();
  turretList.add(turret1);
  turretList.add(turret2);
  turretList.add(turret3);


  bulletList = new ArrayList<Bullet>();

  startTimeLaser = millis();
  intervalLaser = 1000;

  startTimeScore = millis();
  intervalScore = 1000;
  score = 0;

  startTimeTurret = millis();
  intervalTurret = 2000;

  text(score, 100, 100);

  //initialize sound
  walkSound = new SoundFile(this, "walk.wav");
  backgroundNoise = new SoundFile(this, "Portal2Audio.wav");
  jumpSound = new SoundFile(this, "jump.wav");
  bulletFired = new SoundFile(this, "gunshot.wav");
  switchSound = new SoundFile(this, "switchSound.wav");
  theme = new SoundFile(this, "theme.wav");

  //change sound rate
  jumpSound.rate(4);
  walkSound.rate(.8);

  for (int index=0; index<turretImages.length; index++) {
    turretImages[index] = loadImage("sprite_"+index+".png");
  }
  turretAnimation = new Animation(turretImages, .1, 3);
  
  theme.play();
}


void draw() {
  background(backgroundWall);
  currentTimeLaser = millis();
  currentTimeScore = millis();
  currentTimeTurret = millis();

  switch (state) {
  case 0:
    startScreen();
    break;

  case 1:
    info();
    break;

    //actual game
  case 2:
    //all player functions
    p1.render();
    p1.move();
    p1.jumping();
    p1.falling();
    p1.topOfJump();
    p1.land();
    p1.fallOffPlatform(platformList);

    //for loop to go through all platforms
    for (Platform aPlatform : platformList) {
      aPlatform.randomNumber();
      aPlatform.render();
      aPlatform.move();
      aPlatform.collision(p1);
      p1.checkColor(aPlatform);
      aPlatform.collideWithFloor(random(1));
    }


    //for loop that removes platforms that go off screen
    for (int i = platformList.size() - 1; i >= 0; i = i-1) {
      Platform aPlatform = platformList.get(i);
      aPlatform.checkRemove();
      if (aPlatform.shouldRemove == true) {
        platformList.remove(aPlatform);
      }
    }

    //for loop to go through all lasers
    for (Laser aLaser : laserList) {
      if (currentTimeLaser - startTimeLaser >= intervalLaser) {
        aLaser.render();
        aLaser.isOn = !aLaser.isOn;
        startTimeLaser = millis();
      }
      aLaser.render();
      aLaser.moveDown();
      aLaser.collisionWithPlayerWithColorRed(p1);
      aLaser.collisionWithPlayerWithColorBlue(p1);
      aLaser.collideWithFloor();
    }


    //walls on the sides
    wallLeft.render();
    wallLeft.playerCollide(p1);

    wallRight.render();
    wallRight.playerCollide(p1);

    //timer for score
    if (currentTimeScore - startTimeScore >= intervalScore) {
      score += 1;
      startTimeScore = millis();
    }
    //Show Score
    fill(255);
    textSize(100);
    text(score, 100, 100);

    //play background noise
    if (backgroundNoise.isPlaying() == false) {
      backgroundNoise.play();
    }

    noFloor(p1);

    for (Turret aTurret : turretList) {
      aTurret.shoot();
      turretAnimation.display(aTurret.x, aTurret.y);
    }



    //for loop to go through all bullets
    for (Bullet aBullet : bulletList) {
      aBullet.render();
      //turretAnimation.isAnimating = true;
      aBullet.move();
      aBullet.checkRemove();
      aBullet.shootPlayer(p1);
    }

    //for loop that removes unwanted bullets
    for (int i = bulletList.size() - 1; i >= 0; i = i-1) {
      Bullet aBullet = bulletList.get(i);
      if (aBullet.shouldRemove == true) {
        bulletList.remove(aBullet);
      }
    }
    break;

  case 3:
    endScreen();
    break;
  }
  /////////////////////////////////////////////////////////////////////////
  //Sound//
  //walk sound
  if (p1.isMovingLeft == true && p1.isFalling == false && p1.isJumping == false) {
    if (walkSound.isPlaying() == false) {
      walkSound.play();
    }
  }
  if (p1.isMovingRight == true && p1.isFalling == false && p1.isJumping == false) {
    if (walkSound.isPlaying() == false) {
      walkSound.play();
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == 'a') {
    p1.isMovingLeft = true;
  }
  if (key == 'd') {
    p1.isMovingRight = true;
  }

  if (key == 'w' && p1.isJumping == false && p1.isFalling == false) {
    p1.isJumping = true; //start jump
    p1.highestY = (p1.y - p1.jumpHeight);
    jumpSound.play();
  }


  // color shift
  if (key == ' ' && state == 2) {
    switchSound.play();
    if (p1.isRed == true) {
      p1.isRed = false;
      p1.isBlue = true;
    } else if (p1.isBlue == true) {
      p1.isRed = true;
      p1.isBlue = false;
    }
  }
  //go through menu
  if (key == ' ' && state < 2) {
    state ++;

    if (state >= 4) {
      state = 0;
    }
  }
}

void keyReleased() {
  if (key == 'a') {
    p1.isMovingLeft = false;
  }
  if (key == 'd') {
    p1.isMovingRight = false;
  }
}

void startScreen() {
  if (state == 0) {
    background(backgroundWall);
    image(defaultRed, width/2 - 100, height - 450);
    fill(255);
    text("→", width/2, height-430);
    fill(color(255, 0, 255));
    image(defaultBlue, width/2 + 100, height-450);
    text("SPY SHIFTER!", width/2, height/2 - 200);
    text("Press SPACE", width/2, height/2 + 300);
    fill(40);
    text("Ninja Infiltration", width/2, height/2 + 200);
  }
}

void info() {
  if (state == 1) {
    textSize(30);
    fill(255);
    background(0);
    text("You are infilrating a secret base.", width/2, height/2 - 100);
    text("Avoid the lasers by using your patented ShiftGear™", width/2, height/2 - 50);
    text("ShiftGear™ will change your color to match platforms that are the same color as yourself", width/2, height/2);
    text("Press SPACE to use the ShiftGear™ and control with WASD", width/2, height/2 + 50);
    text("Beware, after 5 seconds, the security floor will kick in and you cannot be on the ground", width/2, height/2 + 100);
  }
}

void endScreen() {
  if (state == 3) {
    backgroundNoise.stop();

    fill(255);
    background(0);
    text("Time Lasted", width/2, height/2 - 150);
    text(score, width/2, height/2 + 100);
  }
}
// This is for after a certain amount of time
// you cant land on the floor anymore
void noFloor(Player aPlayer) {
  int x = width/2;
  int y = 800;
  int w = width ;
  int h = 40;

  if (score > 5) {
    aPlayer.isFloorActive = false;
    fill(0);
    rect(x, y, w, h);
  }
}
