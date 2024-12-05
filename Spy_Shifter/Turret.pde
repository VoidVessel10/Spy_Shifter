//This is to provide another obstacle

class Turret {
  //vars
  int x;
  int y;
  int w;
  int h;

  //Constructor

  Turret(int startingX, int startingY) {
    x = startingX;
    y = startingY;
    w = 40;
    h = 40;
  }

  void render() {
    fill(color(255, 255, 0));
    rect(x, y, w, h);
  }
  void shoot() {
    if (currentTimeTurret - startTimeTurret >= intervalTurret) {
      for (Turret aTurret : turretList) {
        bulletList.add(new Bullet(aTurret.x, aTurret.y));
        turretAnimation.isAnimating = true;
        bulletFired.play();
        startTimeTurret = millis();
      }
    }
  }
}
