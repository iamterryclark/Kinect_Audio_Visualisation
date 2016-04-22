class SenderClass {
  OscP5         sender; 
  NetAddress    liveAddress;
  NetAddress    fftOut;

  float         snare;
  int           scene;
  SenderClass() {
    sender = new OscP5(this, 12345);
    liveAddress = new NetAddress("10.100.186.137", 9000); //output to ableton with this machines ip on port 9000 (the liveOsc hack only listens at port 9000)
    fftOut = new NetAddress("10.100.146.184", 12345); //output to device with ip 10.100.146.184 on port 12345 on same network
  }

  /*
  The input function turned out to be unnecessary on account of being ablte 
  communicate directly with ableton. 
  Unfourtunately this wasn't discovered until very late in development
  */
  
  /*the input function receives typetags and address patterns via the oscEvent listener. These messages are handled internally and then forwarded to ableton*/
  void input (String address) {
    OscMessage myMessage = new OscMessage(address); 
    sender.send(myMessage, liveAddress);
  }

  void input(int currentScene, String address) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(currentScene);
    sender.send(myMessage, liveAddress);
  }

  void input(int track, float value, String address) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(track);
    myMessage.add(value);
    sender.send(myMessage, liveAddress);
  }

  void input(int device, int parameter, int value, String address ) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(device);
    myMessage.add(parameter);
    myMessage.add(value);
    sender.send(myMessage, liveAddress);
  }

  void input(int track, int device, int parameter, int value, String address) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(track);
    myMessage.add(device);
    myMessage.add(parameter);
    myMessage.add(value);
    sender.send(myMessage, liveAddress);
  }

  void input(int track, int device, int parameter, float value, String address) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(track);
    myMessage.add(device);
    myMessage.add(parameter);
    myMessage.add(value);
    sender.send(myMessage, liveAddress);
  }
  /*the oscEvent handler takes incoming messages*/
  void oscEvent(OscMessage m) {
    /*sort messages by typetag*/
    switch(m.typetag()) {
    case "":
      input(m.addrPattern());
      break;

    case "i":
      input(m.get(0).intValue(), m.addrPattern());
      scene = m.get(0).intValue();
      break;

    case "if":
      input(m.get(0).intValue(), m.get(1).floatValue(), m.addrPattern());
      break;

    case "iii":
      input(m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue(), m.addrPattern());
      break;

    case "iiii":
      input(m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue(), m.get(3).intValue(), m.addrPattern());
      break;

    case "iiif":
      input(m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue(), m.get(3).floatValue(), m.addrPattern());
      break;
    }
  }

  void fftOut(float bin1) {
    if (beatDetect.isKick()) background(250);
    OscMessage msg = new OscMessage("/fft");
    msg.add(beatDetect.isKick()); //bass drum detection
    msg.add(beatDetect.isRange(20, 26, 5)); //snare drum detection
    //msg.add(bin1);
    sender.send(msg, fftOut);
  }
}