class Gestures {
  //PFont text;
  
  boolean gesture1On, gesture2On, gesture3On, gesture4On, gesture5On;
  int gesture1Count, gesture2Count, gesture3Count, gesture4Count, gesture5Count;
  int gestureMaxTime = 40;
  color loadingCol = color(60, 100, 250);

  Gestures() {
    textAlign(CENTER);
    fill(255);
    noStroke();
  }

  void run() {    
    //Capture all joint information into variables within this class
    PVector lHand     = joints.lhand;
    PVector lElbow    = joints.lelbow;
    PVector lShoulder = joints.lshoulder;

    PVector rHand     = joints.rhand;
    PVector rElbow    = joints.relbow;
    PVector rShoulder = joints.rshoulder;

    //Checking which gestures are activated and switching the booleans
    gesture1On = gestureCheck(lHand, rShoulder); //Play
    //gesture2On = gestureCheck(rHand, lShoulder); //Stop

    gesture3On = gestureCheck(lHand, rElbow   ); //Next Scene
    gesture4On = gestureCheck(rHand, lElbow   ); //Previous Scene 

    gesture5On = gestureCheck(lHand, rHand    ); //Beat Repeat =

    if (gesture1On) {
      gesture1Count++;//Count up if the gesture is on to define when to send the OSC Command
      
      //Reseting all other timers to 0 helps with the kinect glitches when tracking the skeleton
      gesture2Count = 0;
      gesture3Count = 0;
      gesture4Count = 0;
      gesture5Count = 0;
      
      //Present to user activation loader for each gesture
      loadingGestureIcon(gesture1Count);
      
      fill(loadingCol);
      //Instruction on what the user is doing
      text("PLAY", width/2, height/2);
      if (gesture1Count == gestureMaxTime) {
        //Send the OSC message once max time has been met
        oscMsg.drumReset = true; //Drums may be glitching from interactions previously and so reseting here helps the overall sound
        oscMsg.playScene();
        gesture1Count = 0;//Count reset
      }
    }

    //   We could not Implement this gesture just yet 
    //   if (gesture2On) {
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
      fill(loadingCol);
      textSize(50);
      text("»", width/2-10, height/2);
      textSize(30);
      text("|", width/2+10, height/2-2);
      if (gesture3Count == gestureMaxTime) {
        oscMsg.drumReset = true;
        oscMsg.nextScene();
        gesture3Count = 0; //Count reset
        //println("track changed >> scene:" + oscMsg.scene);
      }
    } 
    
    if (gesture4On) {
      gesture4Count++;
      
      gesture1Count = 0;
      gesture2Count = 0;
      gesture3Count = 0;
      gesture5Count = 0;
      
      loadingGestureIcon(gesture4Count);
      fill(loadingCol);
      textSize(50);
      text("«", width/2-10, height/2);
      textSize(30);
      text("|", width/2+10, height/2-2);
      if (gesture4Count == gestureMaxTime) {
        oscMsg.drumReset = true;
        oscMsg.prevScene();
        gesture4Count = 0; //Count reset
        //println("track changed << scene:" + oscMsg.scene);
      }
    } 
    
    if (gesture5On) {
      gesture5Count++;
      
      gesture1Count = 0;
      gesture2Count = 0;
      gesture3Count = 0;
      gesture4Count = 0;
      
      loadingGestureIcon(gesture5Count);
      fill(loadingCol);
      textSize(30);
      text("Beat Repeat", width/2, height/2);
      if (gesture5Count == gestureMaxTime) {
        if (oscMsg.isBeatRepeatOn)  {
          oscMsg.beatReapeatChance(0);// Send once turn on beat Repeater and switch ableton device 'chance' to 0
        } else if (!oscMsg.isBeatRepeatOn) {
          oscMsg.beatReapeatChance(1);// Send once
        }
        oscMsg.drumReset = true;
        oscMsg.isBeatRepeatOn = !oscMsg.isBeatRepeatOn;//Main switch boolean to turn beat repeat on and off
        gesture5Count = 0; //Count reset
      }
    } 
    
    oscMsg.run();//Joint information will now update

    if (oscMsg.isBeatRepeatOn) {
      oscMsg.beatRepeat(); //Only beat repeat interactions switched on
      fill(loadingCol);
      textSize(30);
      text("Beat Repeat On", width/2, 50);
    } 
    if (!oscMsg.isBeatRepeatOn) {
      oscMsg.sceneInstruments();
    }
  }

  boolean gestureCheck(PVector v1, PVector v2) {
    //See Book reference for finding distance between Joints pg 297
    PVector diffVector = PVector.sub(v1, v2);
    float magnitude = diffVector.mag();

    if (magnitude < 130) {
      return true;
    } else {
      return false;
    }
  }

  void loadingGestureIcon(int count) {
    float countmap = map(count, 0, gestureMaxTime, 0, 360);
    pushMatrix();
      translate(0,0, 600);
      pushStyle();
        //fill(0, 0);
        //noStroke();
        //ellipse(width/2, height/2, 70,70);
        noFill();
        stroke(loadingCol);
        strokeWeight(20);
        arc(width/2, height/2, 70, 70, radians(0), radians(countmap));
      popStyle();
    popMatrix();
    
  }
}

