class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan, lifeDecrease, velocityMap, gravity, mass, randomAcc;
  color particleCol, lerp;

  Particle(PVector l) {
    acceleration = new PVector(random(-0.4, 0.4), 0.013);
    velocity = new PVector(random(-7, 7), random(-7, 7));
    location = l.get(); //Captures pointcloud origin
    
    //varied lifespan and size to get a more realistic particle system
    lifespan = random(150, 255.0);//stroke opacity of particle
    mass = random(3, 8);//strokeweight of particle
    randomAcc = random (-1, 1);// for snare interaction horizontal spraying
    this.lifeDecrease = lifeDecrease;
  }

  void run(float lifeDecrease) {
    update(lifeDecrease);
    display();
  }

  void update(float lifeDecrease) {
    /*Physics*/
    if (snareOn) {
        gravity = mass * randomAcc;
        acceleration.y = 0.1;
        acceleration.x *= gravity;
    } else { 
      gravity = (mass + acceleration.y) / 30;
    }

    velocity.x += acceleration.x;
    velocity.y -= gravity;

    location.add(velocity);
    lifespan -= lifeDecrease;

    switch(oscMsg.scene) {
    case 0: 
      particleCol = color(165, 225, 229);
      break;
    case 1: 
      particleCol = color(252,173,250);
      break;
    case 2: 
      particleCol = color(92,98,210);
      break;
    case 3: 
      particleCol = color(13,250,255);
      break;
    }
  }

  void display() {
    stroke(particleCol, lifespan);
    strokeWeight(mass);
    point(location.x, location.y);
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

