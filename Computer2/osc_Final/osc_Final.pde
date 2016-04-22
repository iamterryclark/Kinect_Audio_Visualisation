/*import minim library, used for FFT analysis*/
import ddf.minim.analysis.*;
import ddf.minim.*;

/*import oscP5 library, used for sending and receiving open sound control messages*/
import netP5.*;
import oscP5.*;

//FFT
Minim           minim;

/*using soundflower, I am able to reroute my audio output (i.e. from Ableton Live) to the input channel. Allowing me to use it as an input to minim's FFT object*/
AudioInput      input;
FFT             fft;
BeatDetect      beatDetect;

/*The filter object is a one pole filter. Creating an array of them provides the flexibility to give each part of the frequency spectrum a unique filter*/
Filter[]        filter;

/*the outputs from the frequency spectrum*/
float []        damp;

SenderClass     sender;

void setup () {
  size(640, 480);
  minim = new Minim(this);
  input = minim.getLineIn(minim.STEREO, 512);
  fft = new FFT(input.bufferSize(), input.sampleRate());
  fft.logAverages(10, 2); //start logging fft averages at 10hz, 2 bands per octave
  filter = new Filter[fft.avgSize()]; //set size of filter array to same as fft spectrum
  damp = new float[fft.avgSize()]; //set size of output array to same as fft spectrum

  /*filter array*/
  for (int i= 0; i < filter.length; i++) {
    filter[i] = new Filter(); //create a new filter object
    filter[i].setOnePoleTime(0.00008); //set all my filters to a low value
  }

  //osc message
  sender = new SenderClass();

  //BeatDetect
  beatDetect = new BeatDetect(input.bufferSize(), input.sampleRate());
}

void draw () {
  background(20);
  fft.forward(input.mix); //forward stereo mix to fft function
  beatDetect.detect(input.mix);
  /* iterate over filter array*/
  
  /*
  We wanted to manipulate the color of the particlesystem based off fft bin 1
  Due to not having enough time to make it polished we decided to not implement it.
  */
  for (int i = 0; i < filter.length; i++) {
    filter[i].incr(fft.getBand(i)); //input fftbands to filter class to smooth out rate of change
    damp[i] = filter[i].z; //set each element of output array to a filtered signal
  }
 // sender.fftOutput(output); //output output array to fftOutput function
  sender.fftOut(damp[1]);
}