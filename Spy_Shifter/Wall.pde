
// This class is for the two walls on either side,
//so the player cannot escape the boundaries.
class Wall {
  // vars
  int x;
  int y;
  int w;
  int h;

  PImage wall;

  int left;
  int right;
  int top;
  int bottom;

  //constructor

  Wall(int startingX, int startingY, PImage startingImage) {
    x = startingX;
    y = startingY;
    w = 25;
    h = height * 2;

    wall = startingImage;
    wall.width = w;
    wall.height = h;

    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }

  //functions
  void render() {
    fill(42);
    rect(x, y, w, h);
    image(wall, x, y);
  }

  void playerCollide(Player aPlayer) {
    //from left
    if (aPlayer.top <= bottom
      && aPlayer.bottom >= top
      && aPlayer.right > left
      && aPlayer.left <= left) {
      aPlayer.isMovingRight = false;
      aPlayer.x = left - aPlayer.w/2;
    }
    //from right
    if (aPlayer.top <= bottom
      && aPlayer.bottom >= top
      && aPlayer.left < right
      && aPlayer.right >= right) {
      aPlayer.isMovingLeft = false;
      aPlayer.x = right + aPlayer.w/2;
    }
  }
}
