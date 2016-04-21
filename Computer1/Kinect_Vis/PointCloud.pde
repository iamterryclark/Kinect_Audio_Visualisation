class PointCloud {
  float lifeDecrease;
  float zoom = 0.7;
  int   steps = 15;
  int   depthWidth;
  int   depthHeight;

  PVector realWorldPoint;
  ParticleSystem system;

  PointCloud() {
    system = new ParticleSystem();

    depthWidth  = kinect.depthWidth();
    depthHeight = kinect.depthHeight();

    // enable depthMap generation 
    if (!kinect.enableDepth()) {
      println("Can't open the depthMap, maybe the camera is not connected!"); 
      exit();
      return;
    }
  }

  void run() { 
    pushMatrix();
    pushStyle();
  
    // set the point cloud to center
    translate(width/2, height/2);
    rotateX(radians(180));
    scale(zoom);

    // draw the 3d point depth map
    int[]   depthMap = kinect.depthMap();
    for (int y=0; y < kinect.depthHeight (); y += steps) {
      for (int x=0; x < kinect.depthWidth (); x += steps) {
        int offset = x + y * kinect.depthWidth();
        if (depthMap[offset] > 0) {
          realWorldPoint = kinect.depthMapRealWorld()[offset];
          if (realWorldPoint.z < 2900) { // Sets the threshold
          //Two tracks have drums involved and we wanted to particle systems to add on the bass drum and fall with the snare
          //Otherwise we want to particle systemt to always add
            if (oscMsg.scene == 1 ||oscMsg.scene == 2) { 
             // println(bassDrumOn);
              if (bassDrumOn) {
                system.addParticle(realWorldPoint);
                lifeDecrease = 6.0;
              }
            } else if (oscMsg.scene == 0 || oscMsg.scene == 3) {
              system.addParticle(realWorldPoint);
              lifeDecrease = 8.0;
            }
          }
        }
      }
    }
    system.run(lifeDecrease);
    popStyle();
    popMatrix();
  }
}

