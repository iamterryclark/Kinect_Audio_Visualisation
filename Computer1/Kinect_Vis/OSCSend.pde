class OSCMsgSend {
  PVector lHand, rHand;// main joint varibles

  float lHandMapX, lHandMapY, lHandMapZ;
  float rHandMapX, rHandMapY, rHandMapZ; //
  float lHandMapDist;
  
  int lHandXTo, lHandXFrom, rHandXTo, rHandXFrom;
  int lHandYTo, lHandYFrom, rHandYTo, rHandYFrom;
  int lHandZTo, lHandZFrom, rHandZTo, rHandZFrom;

  int lHandDistTo, lHandDistFrom;

  int scene = 0;

  boolean isBeatRepeatOn;

  OSCMsgSend() {
  }

  void run() {
    lHand = joints.lhand;
    rHand = joints.rhand;

    lHandMapX    = map( lHand.x, joints.middle.x, -kinectMaxPixelWidth,   lHandXTo,   lHandXFrom );
    lHandMapY    = map( lHand.y,               0,                  600,   lHandYTo,   lHandYFrom );
    lHandMapZ    = map( lHand.z,            1500,  kinectMaxPixelDepth,   lHandZTo,   lHandZFrom );

    rHandMapX    = map( rHand.x, joints.middle.x,  kinectMaxPixelWidth,   rHandXTo,   rHandXFrom );
    rHandMapY    = map( rHand.y,               0,                  600,   rHandYTo,   rHandYFrom );
    rHandMapZ    = map( rHand.z,            1500,  kinectMaxPixelDepth,   rHandZTo,   rHandZFrom );

    lHandMapDist = map( lHand.dist(rHand),     0,   1000,   lHandDistTo,   lHandDistFrom );
  }

  void sceneInstruments() {   

    if (scene == 0) {    
      lHandZTo = 127;
      lHandZFrom = 0;

      rHandXTo = 1;
      rHandXFrom = -1;

      /* ------------- */

      //Begin Bundle - First Message
      OscBundle sceneInstruments = new OscBundle();
      OscMessage message = new OscMessage("/live/pan");
      message.add(5);//add track number (instrument) to alter
      message.add(rHandMapX); //add mapped int for Volume
      sceneInstruments.add(message);//Send this specific message to bundle
      message.clear();// After putting message into bundle clear the message

      //Start Second Message etc
      message.setAddrPattern("/live/device");
      message.add(5); //
      message.add(0); //
      message.add(7); //parameter arp rate
      message.add(int(lHandMapZ)); //value 14 - 0
      sceneInstruments.add(message);

      sceneInstruments.setTimetag(sceneInstruments.now() + 1000); //Set time delaye of bundle being sent
      sender.send(sceneInstruments, address); //Send to osc address
    }

    if (scene == 1) {
      lHandZTo = 3;
      lHandZFrom = 0;

      rHandXTo = 0;
      rHandXFrom = 7;

      /* ------------- */

      OscBundle sceneInstruments = new OscBundle();
      OscMessage message = new OscMessage("/live/device");
      message.add(8); //track
      message.add(2); //device
      message.add(4); //parameter drum grid
      message.add(lHandMapZ); //value 12 - 0
      sceneInstruments.add(message);
      message.clear();

      message.setAddrPattern("/live/device");
      message.add(8); //track
      message.add(2); //device
      message.add(2); //parameter drum interval
      message.add(rHandMapX); //value 7 - 0
      sceneInstruments.add(message);

      sceneInstruments.setTimetag(sceneInstruments.now() + 1000); //Set time delaye of bundle being sent
      sender.send(sceneInstruments, address); //Send to osc address
    }

    if (scene == 2) {
      lHandZTo = 1;
      lHandZFrom = 0;

      rHandZTo = 1;
      rHandZFrom = 0;

      rHandYTo = 0;
      rHandYFrom = 127;

      lHandDistTo = 16;
      lHandDistFrom = 0;

      /* ------------- */

      //Bass Volume
      OscBundle sceneInstruments = new OscBundle();
      OscMessage message = new OscMessage("/live/volume");
      message.add(0); //track
      message.add(lHandMapZ); //add mapped int for Volume
      sceneInstruments.add(message);//Send this specific message to bundle
      message.clear();// After putting message into bundle clear the message

      //Synth Volume
      message.setAddrPattern("/live/volume");
      message.add(1); //track
      message.add(rHandMapZ);
      sceneInstruments.add(message);
      message.clear();// After putting message into bundle clear the message

      //Synth Modulation
      message.setAddrPattern("/live/device");
      message.add(1); //track
      message.add(0); //device
      message.add(1); //parameter 
      message.add(rHandMapY); //value 0 - 127
      sceneInstruments.add(message);
      message.clear();// After putting message into bundle clear the message

      //Drum BitCrush needs 2 messages!!!! clear above message if implemented 
      message.setAddrPattern("/live/device");
      message.add(9); //track
      message.add(1); //device
      message.add(2); //parameter drum grid
      message.add((int)lHandMapDist); //value 0 - 16
      sceneInstruments.add(message);

      sceneInstruments.setTimetag(sceneInstruments.now() + 1000); //Set time delaye of bundle being sent
      sender.send(sceneInstruments, address); //Send to osc address
    }

    if (scene == 3) {
      lHandZTo = 1;
      lHandZFrom = 0;
      
      rHandZTo = 1;
      rHandZFrom = 0;

      rHandYTo = 0;
      rHandYFrom = 124;
      
      rHandXTo = 1;
      rHandXFrom = -1;

      /* ------------- */

      //Bass Volume
      OscBundle sceneInstruments = new OscBundle();
      OscMessage message = new OscMessage("/live/volume");
      message.add(0); //track
      message.add(lHandMapZ); //add mapped int for Volume
      sceneInstruments.add(message);//Send this specific message to bundle
      message.clear();// After putting message into bundle clear the message

      //Space Synth Volume
      message.setAddrPattern("/live/volume");
      message.add(3); //track
      message.add(rHandMapZ); //add mapped int for Volume
      sceneInstruments.add(message);//Send this specific message to bundle
      message.clear();// After putting message into bundle clear the message

      //Space Synth Modulation
      message.setAddrPattern("/live/device");
      message.add(3); //track
      message.add(0); //device
      message.add(7); //parameter 
      message.add(rHandMapY); //value 0 - 124
      sceneInstruments.add(message);
      message.clear();

      //Space Synth Pan
      message.setAddrPattern("/live/pan");
      message.add(3); //track
      message.add(rHandMapX);//value
      sceneInstruments.add(message);

      sceneInstruments.setTimetag(sceneInstruments.now() + 1000); //Set time delaye of bundle being sent
      sender.send(sceneInstruments, address); //Send to osc address
    }
  }

  void nextScene() {
    //scene changer
    scene++;
    scene = abs(scene % 4);
    OscMessage myMessage = new OscMessage("/live/play/scene");
    myMessage.add(scene);
    sender.send(myMessage, address);
  }

  void prevScene() {
    //scene changer
    scene--;
    scene = abs(scene % 4);
    OscMessage myMessage = new OscMessage("/live/play/scene");
    myMessage.add(scene);
    sender.send(myMessage, address);
  }  

  void playScene() {
    OscMessage message = new OscMessage("/live/play");
    sender.send(message, address);
  }

//  void stopScene() {
//    OscMessage message = new OscMessage("/live/stop/");
//    message.add(scene);
//    sender.send(message, address);
//  }

  void beatRepeat() {
    lHandXTo = 3;
    lHandXFrom = 0;

    rHandXTo = 12;
    rHandXFrom = 0;

    rHandYTo = 12;
    rHandYFrom = 0;

    OscBundle beatRepeat = new OscBundle();

    OscMessage message = new OscMessage("/live/master/device");
    message.add(0);
    message.add(2); //This is the interval
    message.add((int)lHandMapX); //Value of the interval
    beatRepeat.add(message);
    message.clear();

    message.setAddrPattern("/live/master/device");
    message.add(0);
    message.add(4); //This is the grid
    message.add((int)rHandMapX); //Value of the interval
    beatRepeat.add(message);
    message.clear();

    message.setAddrPattern("/live/master/device");
    message.add(0);
    message.add(11); //This is the pitch
    message.add((int)rHandMapY); //Value of the interval
    beatRepeat.add(message);

    beatRepeat.setTimetag(beatRepeat.now() + 1000);
    sender.send(beatRepeat, address);
  }

  void beatReapeatChance(int percent) {
    OscMessage message = new OscMessage("/live/master/device");
    message.add(0);
    message.add(0); //This is the chance perameter
    message.add(percent); //Value of the interval
    sender.send(message, address);
  }
}

