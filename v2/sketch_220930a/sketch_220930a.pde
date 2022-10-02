cell c;
pic p;
int w = 500,h = 500;
int rows = 20,cols = 20,spacing =2 ,xoffset = 0,yoffset =0;
PImage img;
void settings(){
  size(w,h,P2D);
};

void setup(){
  //size(800,800);
  float pw = ((w-spacing/2+xoffset)/(rows))-spacing/2;
  float ph = ((h-spacing/2+yoffset)/(cols))-spacing/2;
  println(pw,ph,500/11);
  p = new pic(rows,cols,pw,ph);
  frameRate(9);
};
int [] cells = {2,3,4};
void draw(){
  background(255);
  p.draw();
  p.findOpposite(cells);
  
};
