
//The Lasers that move down.
class Laser {

  //vars
  int x;
  int y;
  int w;
  int h;

  color c;

  int left;
  int right;
  int top;
  int bottom;

  boolean isOn;

  //constructor

  Laser(float randomValue) {
    x = 0;
    y = 0;
    w = width*2;
    h = 25;

    // Laser has a random value to randomize whether or not
    // to have a blue or red laser to start
    if (randomValue >= .5) {
      c = (color(255, 0, 0));
    } else {
      c = (color(0, 0, 255));
    }

    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;

    isOn = true;
  }

  //functions
  void render() {
    if (isOn == true) {
      noStroke();
      fill(c);
      rect(x, y, w, h);
    }
    if (isOn == false) {
    }
  }
  void moveDown() {
    //make sure is divisable by height
    y += 1;
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }

  void collisionWithPlayerWithColorRed(Player aPlayer) {
    if (left < aPlayer.right && right > aPlayer.left
      && top < aPlayer.bottom && bottom > aPlayer.top
      && c == color(255, 0, 0) && aPlayer.isRed == true && isOn == true) {
      state++;
    }
  }
  void collisionWithPlayerWithColorBlue(Player aPlayer) {
    if (left < aPlayer.right && right > aPlayer.left
      && top < aPlayer.bottom && bottom > aPlayer.top
      && c == color(0, 0, 255) && aPlayer.isBlue == true && isOn == true) {
      state++;
    }
  }
  void collideWithFloor() {
    if (y == height) {
      y = 0;
      if (c == color(255, 0, 0)) {
        c = (color(0, 0, 255));
      } else {
        c = (color(255, 0, 0));
      }
    }
  }
}
