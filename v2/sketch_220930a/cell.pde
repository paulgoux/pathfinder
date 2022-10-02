class cell{
  int id,xpos,ypos;
  float w,h;
  boolean toggle,mouseDown,visited,visited2,visited3,visiteds,node;
  cell opposite,target,pth;
  HashMap<cell,Boolean> visitedBy = new HashMap<cell,Boolean>();
  ArrayList<Integer[]> pthInfo = new ArrayList<Integer[]>();
  ArrayList<Integer[]> nodeInfo = new ArrayList<Integer[]>();
  HashMap<cell,Integer> parent = new HashMap<cell,Integer>();
  ArrayList<cell> children = new ArrayList<cell>();
  ArrayList<cell> connectedNodes = new ArrayList<cell>();
  ArrayList<cell> imprinted_by = new ArrayList<cell>();
  ArrayList<cell> myfootprint = new ArrayList<cell>();
  HashMap<Integer,cell> best_paths = new HashMap<Integer,cell>();
  HashMap<Integer,cell> temp_paths = new HashMap<Integer,cell>();
  HashMap<Integer,cell> path_ref = new HashMap<Integer,cell>();
  
  int steps;
  
  color pcol = color(0,50),pcol2,col = color(0),col2 = col;
  cell(int i,int j,int ii){
    id = ii;
    xpos = i;
    ypos = j;
    w = 20;
    h = 20;
  }
  
  cell(int ii,int i,int j,float ww,float hh){
    id = ii;
    xpos = i;
    ypos = j;
    w = ww+spacing/2;
    h = hh+spacing/2;
  };
  
  void draw(){
    
    fill(0);
    setCol();
    fill(col);
    stroke(255);
    
    strokeWeight(spacing/2);
    rect(xoffset+spacing/2+(w)*xpos,spacing/2+yoffset+(h)*ypos,w,h);
    fill(0,0,255);
    //text(id,xoffset+spacing/2+(w)*xpos,spacing/2+yoffset+(h)*ypos+20);
  };
  void draw2(){
    fill(col);
    stroke(255);
    strokeWeight(spacing/2);
    rect(xoffset+spacing/2+(w)*xpos,spacing/2+yoffset+(h)*ypos,w,h);
    fill(0,0,255);
    text(id,xoffset+spacing/2+(w)*xpos,spacing/2+yoffset+(h)*ypos+20);
  };
  
  boolean pos(){
    return mouseX>xpos*w&&mouseX<xpos*w+w
    &&mouseY>ypos*h&&mouseY<ypos*h+h;
  };
  
  boolean toggle(){
    if(pos()&&mousePressed&&!mouseDown&&mouseButton==LEFT){
      toggle =!toggle;
      visiteds=!visiteds;
      mouseDown = true;
      println("toggle",id);
    }
    if(!mousePressed)mouseDown = false;
    //if(visiteds)println("toggle",xpos,ypos,id);
    return toggle;
  };
  
  void visit(cell c){
    //println("visit",id);
    c.steps++;
    c.pcol = pcol;
    children.add(c);
    visited = true;
    visiteds = true;
    Integer[] n = new Integer[2];
    n[0] = c.id;
    n[1] = c.steps;
    pthInfo.add(n);
  };
  
  void parent(cell c){
    visitedBy.put(c,true);
    //println("prent",c.id,id,visitedBy.get(c));
    parent.put(c,c.steps);
    pcol = c.pcol;
    c.steps = steps;
  };
  
  void visit(){
    //println("visit",id);
    //c.steps++;
    visited = true;
    visiteds = true;
  };
  
  void setCol(){
    if(toggle()||visiteds)col = pcol;
    else if(node)col = color(0,0,255);
    else col = col2 ;
  };
};
