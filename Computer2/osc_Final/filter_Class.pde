/*one pole filter. used to smooth out rate of change of fft input*/
class Filter {
  float a, b, z, time;

  Filter() {
  }
  //set attack and decay of filter  
  void setOnePoleTime(float time)
  {
    b = exp(-1.0/(time * 44100.0));
    a = 1.0 - b;
  }

  void incr(float input)
  {
    z = input * a + z * b;
  }
}