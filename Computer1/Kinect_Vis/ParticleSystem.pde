class ParticleSystem {
  ArrayList<Particle> particles;
    
  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void run(float lifeDecrease) {
    // Cycle through the ArrayList backwards, because we are deleting while iterating
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);      
      p.run(lifeDecrease);
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle(PVector origin) {
    particles.add(new Particle(origin));
  }
}

