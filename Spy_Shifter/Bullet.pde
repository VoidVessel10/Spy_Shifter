class Bullet {
  //vars

  int x;
  int y;
  int d;

  int left;
  int right;
  int top;
  int bottom;

  int speed;

  boolean shouldRemove;
  //constructor

  Bullet(int startingX, int startingY) {
    x = startingX;
    y = startingY;
    d = 20;

    speed = 15;

    left = x - d/2;
    right = x + d/2;
    top = y - d/2;
    bottom = y + d/2;

    shouldRemove = false;
  }

  void render() {
    fill(color(255, 255, 0));
    circle(x, y, d);
  }

  void move() {
    x += speed;

    left = x - d/2;
    right = x + d/2;
    top = y - d/2;
    bottom = y + d/2;
  }

  void checkRemove() {
    if (x > width) {
      shouldRemove = true;
    }
  }

  // if bullet collides with an Player, end game
  void shootPlayer(Player aPlayer) {
    if (left <= aPlayer.right && right >= aPlayer.left
      && top <= aPlayer.bottom && bottom >= aPlayer.top) {
      state++;
    }
  }
}
