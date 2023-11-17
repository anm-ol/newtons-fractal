import complexnumbers.*;

Complex[] roots = getroots(4);

color[] cr = new color[roots.length];
int iter=50;
int res=400;

float xstart=1,xend=2,ystart=xstart*2/3,yend=xend*2/3;
float xstep= (xend-xstart)/res, ystep=(yend-ystart)/res;
void setup() {
  size(600, 400);
  for(int i=0;i<cr.length;i++){
  cr[i] = randomcolor();
}
  //noLoop();
  noFill();
}

void draw() {
  background(255); // Clear the background on each frame
  Complex c = new Complex(random(-5,5),random(-5,5));
  {
    xstart*=.8; xend*=0.8; ystart=xstart*2/3;yend=xend*2/3;
    xstep= (xend-xstart)/res; ystep=(yend-ystart)/res;
  }
  line(width/2,0,width/2,height);
  line(0,height/2,width,height/2);
    for(Complex root:roots)
    disp(root);
  disp(new Complex(0,0));
  stroke(200,40,40);
  for (int i=1;i<30;i++); {
    stroke(closestroot(c));
    disp(c);
    println(c+"        "+polynom(c));
    c = update(c);
  }
  fillplane();
}

Complex[] getroots(int n){
  Complex[] rs = new Complex[n];
  for(int i=0;i<n;i++){
    rs[i]= new Complex(0,1).mul(2*PI*i/n).exp();
  }
  return rs;
}

Complex polynom(Complex c){
  Complex p=new Complex(1,0);
  for(int i=0;i<roots.length;i++)
    p.muleq(c.sub(roots[i]));
  return p;//c.cub().add(-1,0);
}
void disp(Complex c) {
  float x = map((float) c.re(), xstart, xend, 0, width);
  float y = map((float) c.im(), ystart, yend, 0, height);
  //point(x,y);
  circle(x,y,10);
}

Complex update(Complex z) {
  //Complex c = z.pow(3).mul(2).add(1).div(z.sq().mul(3));
  Complex c1 = z.sub(polynom(z).div(derivative(z)));
  return c1;
}

Complex derivative(Complex z){
  float dh=0.000000001;
  Complex h = new Complex(dh,dh);
  Complex c = (polynom(z.add(h)).sub(polynom(z))).div(h);
  return c;
}

color closestroot(Complex z){
  double min=500000; Complex root;
  int index=-1;
  for(int i=0;i<roots.length;i++){
    root= roots[i];
    if(z.sub(root).abs()<min){
      min = z.sub(root).abs();
      index=i;
    }
  }
  if(index==-1)
    return color(0,0,0);
  else
    return cr[index];
  /*color c;
  switch(index){
    case 0:
      c= color(40,120,200);
      break;
    case 1: 
      c= color(120,42,219);
      break;
    case 2: 
      c= color(200,200,40); break;
    default:
      c= color(0,0,0);
  }
  return c;*/
}

color randomcolor() {
  float[] a = {random(0, 256), random(0, 256), random(0, 256)}; // Generate random RGB color values.
  return color(a[0], a[1], a[2]); // Create a color based on the random RGB values.
}

void fillplane(){
  for(float x=xstart;x<=xend;x+=xstep){
    for(float y=ystart;y<=yend;y+=ystep){
      Complex z = new Complex(x,y), z2=z;
      for(int i=0;i<=iter;i++){
        z2=update(z2);
      }
      stroke(closestroot(z2));
      disp(z);
    }
  }
}
