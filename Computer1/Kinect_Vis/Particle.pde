class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float velocityMap, gravityMap;
   color lerp;
   
  Particle(PVector l) {
    acceleration = new PVector(1,1);
    velocity = new PVector(0.05,1); // Sort for next time!!!
    location = l.get(); //input location vector
    lifespan = 255.0; //opacity
    
  }
  void run(float snare) {
    update(snare);
    display();
  }

  void update(float snare) {
//    color from = color(100,100,100); 
//    color to = color (202, 0, 42); 
//    float at = map(lifespan, 255, 140, 0, 1);
//    lerp = lerpColor (from, to, at);
    
    /*Physics*/
    velocity.x += acceleration.x;
    velocity.y -= snare;
    location.add(velocity);
    lifespan -= 3.0;
  }

  void display() {
    stroke(255, lifespan);
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

