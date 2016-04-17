class Gestures {
  PFont text;
  boolean gesture1On, gesture2On, gesture3On, gesture4On, gesture5On;
  int gesture1Count, gesture2Count, gesture3Count, gesture4Count, gesture5Count;
  int gestureMaxTime = 60;

  Gestures() {
    textSize(30);
    textAlign(CENTER);
    fill(255);
  }

  void run() {    
    PVector lHand     = joints.lhand;
    PVector lElbow    = joints.lelbow;
    PVector lShoulder = joints.lshoulder;

    PVector rHand     = joints.rhand;
    PVector rElbow    = joints.relbow;
    PVector rShoulder = joints.rshoulder;

    gesture1On = gestureCheck(lHand, rShoulder); //Play
    gesture2On = gestureCheck(rHand, lShoulder); //Stop

    gesture3On = gestureCheck(lHand, rElbow   ); //Next Scene
    gesture4On = gestureCheck(rHand, lElbow   ); //Previous Scene 

    gesture5On = gestureCheck(lHand, rHand    ); //Beat Repeat =

    if (gesture1On) {
      gesture1Count++;
      
      gesture2Count = 0;
      gesture3Count = 0;
      gesture4Count = 0;
      gesture5Count = 0;
      
      fill(255);
      text("Gesture 1", width/2, height/2);
      loadingGestureIcon(gesture1Count);
      if (gesture1Count == gestureMaxTime) {
        oscMsg.playScene();
        gesture1Count = 0;//Count reset
        println("track started");
      }
    }

    //    if (gesture2On) {
    //      gesture2Count++;
    //      text("Gesture 2", width/2, height/2);
    //      if (gesture2Count == gestureMaxTime) {
    //        oscMsg.stopScene();
    //        gesture2Count = 0; //Count reset
    //      }
    //    }

    if (gesture3On) {
      gesture3Count++;
      
      gesture1Count = 0;
      gesture2Count = 0;
      gesture4Count = 0;
      gesture5Count = 0;
      
      loadingGestureIcon(gesture3Count);
      fill(255);
      text("Gesture 3", width/2, height/2);
      if (gesture3Count == gestureMaxTime) {
        oscMsg.nextScene();
        gesture3Count = 0; //Count reset
        println("track changed >> scene:" + oscMsg.scene);
      }
    } 
    
    if (gesture4On) {
      gesture4Count++;
      
      gesture1Count = 0;
      gesture2Count = 0;
      gesture3Count = 0;
      gesture5Count = 0;
      
      loadingGestureIcon(gesture4Count);
      fill(255);
      text("Gesture 4", width/2, height/2);
      if (gesture4Count == gestureMaxTime) {
        oscMsg.prevScene();
        gesture4Count = 0; //Count reset
        println("track changed << scene:" + oscMsg.scene);
      }
    } 
    
    if (gesture5On) {
      gesture5Count++;
      
      gesture1Count = 0;
      gesture2Count = 0;
      gesture3Count = 0;
      gesture4Count = 0;
      
      loadingGestureIcon(gesture5Count);
      fill(255);
      text("Gesture 5", width/2, height/2);
      if (gesture5Count == gestureMaxTime) {
        if (oscMsg.isBeatRepeatOn)  oscMsg.beatReapeatChance(0);// Send once turn on beat Repeater
        if (!oscMsg.isBeatRepeatOn)  oscMsg.beatReapeatChance(1);// Send once
        oscMsg.isBeatRepeatOn = !oscMsg.isBeatRepeatOn;
        gesture5Count = 0; //Count reset
      }
    } 
    
    if (oscMsg.isBeatRepeatOn) {
      oscMsg.run();
      oscMsg.beatRepeat();      
      fill(255, 30);
      text("Repeat Activated", width/2, 50);
    } 
    
    if (!oscMsg.isBeatRepeatOn) {
      oscMsg.run();
      oscMsg.sceneInstruments();
    }
  }

  boolean gestureCheck(PVector v1, PVector v2) {
    //See Book reference for finding distance between Joints pg 297
    PVector diffVector = PVector.sub(v1, v2);
    float magnitude = diffVector.mag();

    if (magnitude < 170) {
      return true;
    } else {
      return false;
    }
  }

  void loadingGestureIcon(int count) {
    float countmap = map(count, 0, gestureMaxTime, 0, 360);
    pushMatrix();
    pushStyle();
    noFill();
    stroke(60, 100, 250, 80);
    strokeWeight(20);
    arc(width/2, height/2, 200, 200, radians(0), radians(countmap));
    popStyle();
    popMatrix();
  }
}

