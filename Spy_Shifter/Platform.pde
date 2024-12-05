
//The platforms that the player can jump on.
class Platform {
  // vars
  int x;
  int y;
  int w;
  int h;

  color red;
  color blue;

  float randomColorNumber;

  int left;
  int right;
  int top;
  int bottom;

  boolean collisionOn;

  boolean shouldRemove;

  boolean isRed;
  boolean isBlue;


  //constructor
  Platform(int startingX, int startingY) {
    x = startingX;
    y = startingY;
    w = 150;
    h = 15;

    red = color(255, 0, 0);
    blue = color(0, 0, 255);
    randomColorNumber = (random(1));

    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;

    shouldRemove = false;
    collisionOn = true;
  }

  //Functions

  void randomNumber() {
    if (randomColorNumber > .5) {
      isRed = true;
      isBlue = false;
    } else {
      isRed = false;
      isBlue = true;
    }
  }
  void render() {
    if (isRed == true) {
      fill(red);
      rect(x, y, w, h);
    }
    if (isBlue == true) {
      fill(blue);
      rect(x, y, w, h);
    }
  }
  void move() {
    y += 1;
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }

  void collision(Player aPlayer) {
    if (collisionOn == true) {
      if (left < aPlayer.right && right > aPlayer.left
        && top < aPlayer.bottom && bottom > aPlayer.top
        && aPlayer.isFalling == true) {

        aPlayer.isFalling = false;
        aPlayer.y = y - h/2 - aPlayer.h/2;
        aPlayer.isJumping = false;
      }
    }
  }
  void checkRemove() {
    if (y > 800) {
      shouldRemove = true;
    }
  }
  void collideWithFloor(float startingRandomNumber) {
    if (y == height) {
      randomColorNumber = startingRandomNumber;
      randomNumber();
      y = 0;
      x = (int(random(150, 950)));
    }
  }
}
