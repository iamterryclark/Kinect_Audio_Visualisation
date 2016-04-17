class Joints {
  PVector middle;
  PVector lhand, lelbow, lshoulder;
  PVector rhand, relbow, rshoulder;

  Joints() {
    middle = new PVector();
    
    lhand = new PVector();
    lelbow = new PVector();    
    lshoulder = new PVector();
    
    rhand = new PVector();
    relbow = new PVector();
    rshoulder = new PVector();
  }
  
  void getMiddle(int userId) {
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_TORSO, middle);
    //drawSkel(userId);
  }
  
  void getLeft(int userId) {
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, lhand);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, lelbow);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, lshoulder);
  }

  void getRight(int userId) {
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rhand);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, relbow);
    kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rshoulder);
  }

//  void drawSkel(int userId) {
//    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
//    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
//    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
//    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
//    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
//    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
//  }
}

