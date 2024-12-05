
//The player character.
class Player {
  //vars
  int x;
  int y;

  int w;
  int h;

  PImage anImageRed;
  PImage anImageBlue;

  Animation jumpAnimationBlue;
  Animation jumpAnimationRed;
  Animation walkAnimationRed;
  Animation walkAnimationBlue;

  PImage[] jumpImagesBlue = new PImage[8];
  PImage[] jumpImagesRed = new PImage[8];
  PImage[] walkImagesRed = new PImage[5];
  PImage[] walkImagesBlue = new PImage[5];

  int cRed;
  int cBlue;

  boolean isMovingLeft;
  boolean isMovingRight;
  boolean isFloorActive;

  boolean isJumping;
  boolean isFalling;

  int speed;

  int jumpHeight; // how high you can jump
  int highestY;  //y value of the top of the jump

  int left;
  int right;
  int bottom;
  int top;

  boolean isRed;
  boolean isBlue;


  // constructor
  Player(int startingX, int startingY, int startingW, int startingH, PImage startingBlue, PImage startingRed) {
    x = startingX;
    y = startingY;
    w = startingW;
    h = startingH;
    anImageRed = startingRed;
    anImageBlue = startingBlue;

    isMovingLeft = false;
    isMovingRight = false;

    isJumping = false;
    isFalling = false;
    isFloorActive = true;

    speed = 10;

    jumpHeight = 250;
    highestY = (y - jumpHeight);

    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;

    isRed = true;
    cRed = color(255, 0, 0);

    isBlue = false;
    cBlue = color(0, 0, 255);

    for (int index=0; index<jumpImagesRed.length; index++) {
      jumpImagesRed[index] = loadImage("jumpRed"+index+".png");
    }
    for (int index=0; index<jumpImagesBlue.length; index++) {
      jumpImagesBlue[index] = loadImage("jumpBlue"+index+".png");
    }

    for (int index=0; index<walkImagesRed.length; index++) {
      walkImagesRed[index] = loadImage("walkRed"+index+".png");
    }

    for (int index=0; index<walkImagesBlue.length; index++) {
      walkImagesBlue[index] = loadImage("walkBlue"+index+".png");
    }
    jumpAnimationBlue = new Animation(jumpImagesBlue, .15, 1);

    jumpAnimationRed = new Animation(jumpImagesRed, .15, 1);

    walkAnimationRed = new Animation(walkImagesRed, .15, 1);

    walkAnimationBlue = new Animation(walkImagesBlue, .15, 1);
  }

  //functions
  void render() {
    if (isRed == true) {
      fill(cRed);
      image(anImageRed, x, y);
      if (jumpAnimationRed.isAnimating == true) {
        jumpAnimationRed.display(x, y);
      }
    } else if (isBlue == true) {
      fill(cBlue);
      image(anImageBlue, x, y);
      if (jumpAnimationBlue.isAnimating == true) {
        jumpAnimationBlue.display(x, y);
      }
    }
  }
  void move() {
    if (isMovingLeft == true ) {
      x -= speed;
      left = x - w/2;
      right = x + w/2;
      top = y - h/2;
      bottom = y + h/2;

      if (isRed == true) {
        walkAnimationRed.isAnimating = true;

        if (walkAnimationRed.isAnimating == true) {
          walkAnimationRed.display(x, y);
        }
      }
      if (isBlue == true) {
        walkAnimationBlue.isAnimating = true;

        if (walkAnimationBlue.isAnimating == true) {
          walkAnimationBlue.display(x, y);
        }
      }
    }

    if (isMovingRight == true) {
      x += speed;

      left = x - w/2;
      right = x + w/2;
      top = y - h/2;
      bottom = y + h/2;

      if (isRed == true) {
        walkAnimationRed.isAnimating = true;

        if (walkAnimationRed.isAnimating == true) {
          walkAnimationRed.display(x, y);
        }
      }
      if (isBlue == true) {
        walkAnimationBlue.isAnimating = true;

        if (walkAnimationBlue.isAnimating == true) {
          walkAnimationBlue.display(x, y);
        }
      }
    }
  }
  void jumping() {
    if (isJumping == true) {
      y -= speed;
      left = x - w/2;
      right = x + w/2;
      top = y - h/2;
      bottom = y + h/2;
      if (isRed == true) {
        jumpAnimationRed.isAnimating = true;
      } else if (isBlue == true) {
        jumpAnimationBlue.isAnimating = true;
      }
    }
  }

  void falling() {
    if (isFalling == true) {
      y += speed;
      left = x - w/2;
      right = x + w/2;
      top = y - h/2;
      bottom = y + h/2;
    }
  }

  void topOfJump() {
    if (y <= highestY) {
      isJumping = false;
      isFalling = true;
    }
  }
  void land() {
    if (isFloorActive == true) {
      if (y >= height - h/2) {
        isFalling = false;  // stop falling
        y = height - h/2; //snap player to bottom
      }
    }
    if (isFloorActive == false) {
      if (y >= height - h/2) {
        state++;
      }
    }
  }

  // check to see if player is colliding with platform
  //if not, make player start falling

  void fallOffPlatform(ArrayList<Platform> aPlatformList) {
    //check that player is not in middle of a jump
    // and is not on the ground
    if (isJumping == false && y < height - h/2) {

      boolean onPlatform = false;

      for (Platform aPlatform : aPlatformList) {
        if (top <= aPlatform.bottom &&
          bottom >= aPlatform.top &&
          left <= aPlatform.right &&
          right >= aPlatform.left && aPlatform.collisionOn == true) {
          onPlatform = true;
          y += 1;
        }
      }
      if (onPlatform == false) {
        isFalling = true;
      }
    }
  }
  //Check to see if the color of player matches the color of platform
  void checkColor(Platform aPlatform) {
    if (isRed == true && aPlatform.isRed == true) {
      aPlatform.collisionOn = true;
    } else if (isRed == true && aPlatform.isBlue == true) {
      aPlatform.collisionOn = false;
    } else if (isBlue == true && aPlatform.isRed == true) {
      aPlatform.collisionOn = false;
    } else if (isBlue == true && aPlatform.isBlue == true) {
      aPlatform.collisionOn = true;
    }
  }
}
