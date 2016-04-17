/* 
 Title        : G&T Installation
 
 Authors      : Terry Clark and Gustaf Svenungsson
 
 Description  : 
 - An interactive wall with Kinect and OSC messages sent through to AbletonLive 9.5 via OSCLive plugin.
 - Currently built to only take 1 user but this could be extended for multiple
 
 Reference    : 
 Kinect v1 Skeleton = https://simple-openni.googlecode.com/svn-history/r440/trunk/SimpleOpenNI-2.0/dist/all/SimpleOpenNI/examples/OpenNI/User/User.pde
 OSC & NetP5        = http://www.sojamo.de/libraries/oscP5/
 PointCloud         = http://stackoverflow.com/questions/9577662/simpleopenni-point-cloud-program-with-kinect
 ParticleSystem     = Part of Previous project, further alteration through advice in class
 Book               = Making Things See: 3D vision with Kinect, Processing, Arduino and MakerBot
 
 Libraries    :
 openKinect   = Pointcloud system from core kinect files
 SimpleOpenNI = SimpleOpenNI Library used for Skeleton tracking and sending the vector points through to OSC messaging
 OSCP5        = Handles packaging the OSC message
 netP5        = Sends osc through a sever to connect both laptops
 */

//Import Libraries
import SimpleOpenNI.*; // Library to connect and use skeleton vectors from Kinect
import oscP5.*; // Sends OSC Messages
import netP5.*; // Sets IP address for OSC message to send

// Initialising all libraries
SimpleOpenNI   kinect;
OscP5          sender;
NetAddress     address;

//Skeleton, OSC and Calibration Classes
Joints        joints;
Gestures      gestures;
OSCMsgSend    oscMsg;
PointCloud    pointCloud;

int kinectMaxPixelDepth, kinectMaxPixelWidth, kinectMaxPixelHeight;
boolean bassDrumOn;
float snareParam;

void setup() {  
  size(displayWidth, displayHeight, P3D);
  background(0);

  ellipseMode(CENTER);
  //Kinect Setup
  kinect = new SimpleOpenNI(this); // Setup skeleton detection
  kinect.enableDepth(); //depth maps to be scaled to the 500-2047 range 
  kinect.setMirror(true);
  kinect.enableUser(); // enables skeleton generation for all joint vectorså

  kinectMaxPixelDepth = 2400;
  kinectMaxPixelWidth = 1000;
  kinectMaxPixelHeight = 700;

  //OSC Setup (Sender & Receiver Networks)
  sender = new OscP5(this, 12345); // Setup OSC Sender
  //  address = new NetAddress("10.100.186.137", 9000);  //UNI Network IP Address
  address = new NetAddress("10.40.14.45", 9000);  //UNI Network IP Address

  //Initialise skeleton and OSC classes
  joints = new Joints();
  gestures = new Gestures();
  oscMsg = new OSCMsgSend();
  pointCloud = new PointCloud();
}

void draw() {
  noStroke();
  background(0);

  fill(0, 10);
  rect(0, 0, width, height);

  fill(0, 100);
  ellipse(width/2, height/2 + 100, height, height);

  //Update the cam pixels
  kinect.update();

  // Assigns an int to a list of possible users
  int[] userList = kinect.getUsers();
  fill(255, 50, 50);
  ellipse(20, 20, 30, 30);

  //A loop which defines all possible users
  for (int i=0; i<userList.length; i++) {
    if (kinect.isTrackingSkeleton(userList[i])) {
      //All skeleton and osc message run only if person is connected to kinect
      joints.getMiddle(userList[i]);
      joints.getLeft(userList[i]);
      joints.getRight(userList[i]);
      gestures.run();
      oscMsg.run();
      /* See Joint Information Below for Calibration data by Gustaf and Terry */
      fill(50, 255, 50);
      ellipse(20, 20, 30, 30);
    }
  }
  pointCloud.run();//Poiint cloud is always running

}

void  oscEvent(OscMessage  oscMsg) { 
  //Code from week9 AVC Class Slides, alteration by looping through list of floats
  if  (oscMsg.checkAddrPattern("/fft")) { 
    if (oscMsg.checkTypetag("Tf")) {
      bassDrumOn = true;
      snareParam = oscMsg.get(1).floatValue();
    } else {
      bassDrumOn = false;
    }
  }
}

//Default functions from kinect to show when a user has been connected
void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  curContext.startTrackingSkeleton(userId);
}

//Default functions from kinect to show when a user has been lost
void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

//boolean sketchFullScreen() {
//  return true;
//}


/*
Skeleton Calibration Data
 -----
 As the vectors of the hand cover the same space as the other joint vectors we
 used this as a basis in order to get our minimum and maximum points
 
 LEFT HAND
 X
 - 1200/-1440 pixels
 
 Y 
 hand raised
 - 700
 
 hand dropped
 - 550->600
 
 Z
 close to camera
 - 1400
 
 further away from camera
 - 2600
 
 ------
 
 RIGHT HAND 
 X
 - 1440
 
 Y and Z are the same as left
 
 */
