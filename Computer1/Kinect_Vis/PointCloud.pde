class PointCloud {
  int    depthWidth;
  int    depthHeight;
  
  float zoomf = 0.4f;
  int    steps       = 15;

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
    translate(width/2, height/2, 0);
    rotateX(radians(180));
    scale(zoomf);
    
    translate(0, 0, -1000);

    // draw the 3d point depth map
    int[]   depthMap = kinect.depthMap();

    for (int y=0; y < kinect.depthHeight (); y += steps) {
      for (int x=0; x < kinect.depthWidth (); x += steps) {
        int offset = x + y * kinect.depthWidth();
        if (depthMap[offset] > 0) {
          realWorldPoint = kinect.depthMapRealWorld()[offset];
          if (realWorldPoint.z < 2500) { // Sets the threshold
            if (bassDrumOn) system.addParticle(realWorldPoint);
          }
        }
      }
    }
    strokeWeight(4);
    system.run(snareParam);
    popStyle();
    popMatrix();
  }
}

