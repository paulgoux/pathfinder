class pic{
  cell c;
  ArrayList<cell> grid = new ArrayList<cell>();
  ArrayList<cell> gridbackup = new ArrayList<cell>();
  
  ArrayList<ArrayList<cell>> stack = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> stackBackup = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> hist = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> pathhist = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> backupstar = new ArrayList<ArrayList<cell>>();
  ArrayList<ArrayList<cell>> starhist = new ArrayList<ArrayList<cell>>();
  int cols,rows;
  
  ArrayList<cell> start = new ArrayList<cell>();
  ArrayList<cell> startBackup = new ArrayList<cell>();
  pic(int cols,int rows,float w,float h){
    this.cols = cols;
    this.rows = rows;
    for(int i=0;i<rows;i++){
      for(int j=0;j<cols;j++){
        int pos = j+i*(cols);
        cell c = new cell(pos,j,i,w,h);
        //println("gridpos",pos);
        grid.add(c);
        ArrayList<cell> t = new ArrayList<cell>();
        stack.add(t);
        hist.add(t);
      }
    }
    init();
    
  };
  
  void reInit(){
    cols = cols;
    rows = rows;
    println("reinit",grid.size());
    grid = null;
    float w = ((width-spacing/2+xoffset)/(rows))-spacing/2;
    float h = ((height-spacing/2+yoffset)/(cols))-spacing/2;
     grid = new ArrayList<cell>();
    gridbackup = new ArrayList<cell>();
    stack = new ArrayList<ArrayList<cell>>();
    stackBackup = new ArrayList<ArrayList<cell>>();
    hist = new ArrayList<ArrayList<cell>>();
    pathhist = new ArrayList<ArrayList<cell>>();
    backupstar = new ArrayList<ArrayList<cell>>();
    starhist = new ArrayList<ArrayList<cell>>();
    
    start = new ArrayList<cell>();
    startBackup = new ArrayList<cell>();
    println("reinit",grid.size());
    for(int i=0;i<rows;i++){
      for(int j=0;j<cols;j++){
        int pos = j+i*(cols);
        cell c = new cell(pos,j,i,w,h);
        //println("gridpos",pos,c);
        grid.add(c);
        ArrayList<cell> t = new ArrayList<cell>();
        stack.add(t);
        hist.add(t);
      }
    }
    if(grid!=null)init();
    println("reinit",grid.size());
  };
  
  void init(){
    int n = 7;
    int nn= n-1;
    //h = h-1;
    //println(grid);
    //println("pw",cols,"ph",rows,grid.size(),cols+rows*cols);
    //top right
    cell c = grid.get(0);
    
    ////lst
    cell c1 = grid.get(grid.size()-1);
    //top middle
    cell c3 = grid.get(cols/2);
    //top right
    cell c4 = grid.get((cols-1));
    
    //left middle
    //println("pw",cols,"ph",rows,grid.size(),cols+rows*cols);
    cell c2 = grid.get(rows/2*cols);
    println("left middle",c2.id);
    ////right middle
    cell c5 = grid.get(rows-1+(cols/2)*cols);
    println("right middle",c5.id);
    ////bottom left
    cell c6 = grid.get((cols-1)*cols);
    //bottom middle
    cell c7 = grid.get(((cols-1)/2)+((rows-1))*cols);
    
    c.opposite = c1;c.pcol = color(random(255),random(255),random(255));
    c1.opposite = c;c1.pcol = color(random(255),random(255),random(255));
    c3.opposite = c7;c3.pcol = color(random(255),random(255),random(255));
    c7.opposite = c3;c7.pcol = color(random(255),random(255),random(255));
    c4.opposite = c6;c4.pcol = color(random(255),random(255),random(255));
    c2.opposite = c5;c2.pcol = color(random(255),random(255),random(255));
    c5.opposite = c2;c5.pcol = color(random(255),random(255),random(255));
    c6.opposite = c4;c6.pcol = color(random(255),random(255),random(255));
    
    start.add(c);
    start.add(c1);
    start.add(c2);
    start.add(c3);
    start.add(c4);
    start.add(c5);
    start.add(c6);
    start.add(c7);
    
    
    for (int i=0;i<start.size();i++){
      cell cc = start.get(i);
      startBackup.add(cc);
      cc.visiteds = true;
      //println("toggle",cc.xpos,cc.ypos,cc.id,i);
    }
  };
  
  void draw(){
    cell c3 = null;
    resit();
    if(grid!=null&&grid.size()>0){
    for(int i=0;i<grid.size();i++){
        cell c = grid.get(i);
        c.draw();
        if(c.pos()){
          c3 = c;
          
        }
     }
     float kx = 0;
     if(mouseX>width/2)kx = -90;
     if(c3!=null){
     fill(255,0,0);
          cell c2 = startBackup.get(0).opposite;
          float dx = abs(c3.xpos-c2.xpos);
          float dy = abs(c3.ypos-c2.ypos);
          text(c3.xpos+","+c3.ypos+","+c3.id
          ,mouseX+kx,mouseY);
     }
    }
  };
  
  void findOpposite(int []k){
    
    if(mousePressed&&mouseButton==RIGHT)
    for(int i=0;i<k.length;i++){
      int n = k[i];
      cell c = start.get(n);
      cell c2 = startBackup.get(n);
      cell next = null;
      //c.col = color(0,0,255);
      c.draw2();
      c.visit();
      
      next = findNearest(c,c2.opposite);
      if(next!=null&&c!=c2.opposite){
        if(next!=c2){
        //while(next!=c.opposite){
          //println("cell opposite",c.id,c2.opposite.id);
          c.visit(next);
          next.parent(c2);
          stack.get(n).add(next);
          hist.get(n).add(next);
          
          start.set(n,next);
        }else {
          println("cell found",startBackup.get(n).id,next.id);
          break;
        }
      }else if(stack.get(n).size()>0&&c!=c2.opposite){
        cell c3 = stack.get(n).get(stack.get(n).size()-1);
        c3.node = true;
        println("trimStck",c2.id);
        start.set(n,c3);
      }
      if(stack.get(n).size()>1)trimStackN(stack.get(n),c2.opposite);
      //}
    }
  };
  
  void findOpposite(int k){
    int n = k;
    if(mousePressed&&mouseButton==RIGHT)
    for(int i=0;i<1;i++){
      cell c = start.get(n);
      cell c2 = startBackup.get(n);
      cell next = null;
      //c.col = color(0,0,255);
      c.draw2();
      c.visit();
      
      next = findNearest(c,c2.opposite);
      if(next!=null&&c!=c2.opposite){
        if(next!=c2){
        //while(next!=c.opposite){
          //println("cell opposite",c.id,c2.opposite.id);
          c.visit(next);
          next.parent(c2);
          stack.get(n).add(next);
          hist.get(n).add(next);
          
          start.set(n,next);
        }else {
          //println("cell found",startBackup.get(n).id,next.id);
          break;
        }
      }else if(stack.get(n).size()>0&&c!=c2.opposite){
        cell c3 = stack.get(n).get(stack.get(n).size()-1);
        c3.node = true;
        //println("trimStck",c2.id);
        start.set(n,c3);
      }
      if(stack.get(n).size()>1)trimStackN(stack.get(n),c2.opposite);
      //}
    }
  };
  
  void findOpposite(){
    int n = 0;
    if(mousePressed&&mouseButton==RIGHT)
    for(int i=0;i<start.size();i++){
      cell c = start.get(i);
      cell c2 = startBackup.get(i);
      cell next = null;
      //c.col = color(0,0,255);
      c.draw2();
      c.visit();
      
      next = findNearest(c,c2.opposite);
      if(next!=null&&c!=c2.opposite){
        if(next!=c2){
        //while(next!=c.opposite){
          //println("cell opposite",c.id,c2.opposite.id);
          c.visit(next);
          next.parent(c2);
          stack.get(i).add(next);
          hist.get(i).add(next);
          
          start.set(i,next);
        }else {
          println("cell found",startBackup.get(i).id,next.id);
          break;
        }
      }else if(stack.get(i).size()>0&&c!=c2.opposite){
        cell c3 = stack.get(i).get(stack.get(i).size()-1);
        c3.node = true;
        println("trimStck",c2.id);
        start.set(i,c3);
      }
      if(stack.get(i).size()>1)trimStackN(stack.get(i),c2.opposite);
      //}
    }
  };
  
  cell findNearest(cell c,cell b){
    cell next = null;
    ArrayList<cell> temp = new ArrayList<cell>();
    for(int i=c.xpos-1;i<c.xpos+2;i++){
      for(int j=c.ypos-1;j<c.ypos+2;j++){
        int x = i;
        int y = j;
        int pos = (x)+(y)*(cols);
        cell c1 = null;
        int dx = (x-c.xpos);
        int dy = (y-c.ypos);
        //println("pos id",pos,x,y,c.xpos,c.ypos,"cid",c.id,dx,dy,dx>-1&&dy>-1);
        //if(x>=0&&y>=0&&pos>=0&&pos!=c.id)println("pos id",pos,x,y);
        if((verify(x,y,pos,c))&&pos!=c.id
           &&!toggle(pos)&&!visitedBy(b.opposite,pos)){
          //println("pos id insert",pos,grid.get(pos).visitedBy.get(b.opposite));
          cell c2 = grid.get(pos);
          //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos,"c2 id",c2.id);
          temp.add(c2);
        }
        //else 
        //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos);
      }
    }
    
    if(temp.size()>1){
      cell d = temp.get(0);
      //println("tempsize",temp.size()); 
      ArrayList<cell> temp2 = new ArrayList<cell>();
      for (int i=1;i<temp.size();i++){
        cell d2 = temp.get(i);
        
        int d2x = abs(b.xpos-d2.xpos);
        int d2y = abs(b.ypos-d2.ypos);
        
        float k2x = d2x*d2x;
        float k2y = d2y*d2y;
        int dx = abs(b.xpos-d.xpos);
        int dy = abs(b.ypos-d.ypos);
        float kx = dx*dx;
        float ky = dy*dy;
        
        if(sqrt(k2x+k2y)<sqrt(kx+ky)){
          
          d = d2;
          //println("
        }
      }
      next = d;
      cell d2 = temp.get(0);
      //println("cellnerst ",next.id);
    }else if(temp.size()>0)next = temp.get(0);
    return next;
  };
  
  cell findNext(cell c){
    cell next = null;
    ArrayList<cell> temp = new ArrayList<cell>();
    for(int i=c.xpos-1;i<c.xpos+1;i++){
      for(int j=c.ypos-1;j<c.ypos+1;j++){
        int x = i;
        int y = j;
        int pos = (x)+(y)*(cols);
        cell c1 = null;
        //if(x>=0&&y>=0&&pos>=0&&pos!=c.id)println("pos id",pos,x,y);
        if(x>=0&&y>=0&&pos<grid.size()&&
        i>-1&&j>-1&&
        pos>0&&!visiteds(pos)&&
        pos!=c.id&&!visitedBy(c,pos)
          &&!visited(pos)){
          //println("pos id",pos,x/,y);
          cell c2 = grid.get(pos);
          //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos,"c2 id",c2.id);
          temp.add(c2);
        }
        //else 
        //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos);
      }
    }
    int r = floor(random(temp.size()));
    //grid.get(r).visitedBy.add(c);
    if(temp.size()>0)
    next = temp.get(r);
    //println("cellfn trim",r,next);
    return next;
  };
  
  
  cell findFurthest(cell c,cell b){
    cell next = null;
    ArrayList<cell> temp = new ArrayList<cell>();
    for(int i=c.xpos-1;i<c.xpos+2;i++){
      for(int j=c.ypos-1;j<c.ypos+2;j++){
        int x = i;
        int y = j;
        int pos = (x)+(y)*(cols);
        cell c1 = null;
        //if(x>=0&&y>=0&&pos>=0&&pos!=c.id)println("pos id",pos,x,y);
        if(x>=0&&y>=0&&pos<grid.size()&&
        i>-1&&j>-1&&
        pos>0&&!visiteds(pos)&&
        pos!=c.id&&!visitedBy(c,pos)
          &&!visited(pos)){
          //println("pos id",pos,x/,y);
          cell c2 = grid.get(pos);
          //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos,"c2 id",c2.id);
          temp.add(c2);
        }
        //else 
        //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos);
      }
    }
    
    if(temp.size()>1){
      cell d = temp.get(0);
      int dx = abs(b.xpos-d.xpos);
      int dy = abs(b.ypos-d.ypos);
      ArrayList<cell> temp2 = new ArrayList<cell>();
      for (int i=1;i<temp.size();i++){
        cell d2 = temp.get(i);
        
        
        int d2x = abs(b.xpos-d2.xpos);
        int d2y = abs(b.ypos-d2.ypos);
        
        if(d2x+d2y>dx+dy)d = d2;
      }
      next = d;
      
      
      
      println("cellferst ");
    }else if(temp.size()>0)next = temp.get(0);
    return next;
  };
  
  cell findNearestDGN(cell c,cell b){
    cell next = null;
    ArrayList<cell> temp = new ArrayList<cell>();
    for(int i=c.xpos-1;i<c.xpos+2;i++){
      for(int j=c.ypos-1;j<c.ypos+2;j++){
        int x = i;
        int y = j;
        int pos = (x)+(y)*(cols);
        cell c1 = null;
        //if(x>=0&&y>=0&&pos>=0&&pos!=c.id)println("pos id",pos,x,y);
        if(x>=0&&y>=0&&pos<grid.size()&&
        i>-1&&j>-1&&
        pos>0&&!visiteds(pos)&&
        pos!=c.id&&!visitedBy(c,pos)
          &&!visited(pos)){
          //println("pos id",pos,x/,y);
          cell c2 = grid.get(pos);
          //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos,"c2 id",c2.id);
          temp.add(c2);
        }
        //else 
        //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos);
      }
    }
    
    if(temp.size()>1){
      cell d = temp.get(0);
      ArrayList<cell> temp2 = new ArrayList<cell>();
      for (int i=1;i<temp.size();i++){
        cell d2 = temp.get(i);
        int dx = abs(c.xpos-d.xpos);
        int dy = abs(c.ypos-d.ypos);
        
        int d2x = abs(c.xpos-d2.xpos);
        int d2y = abs(c.ypos-d2.ypos);
        
        if(d2x+d2y>dx+dy)d = d2;
      }
      next = d;
      println("cellnerst ",next);
    }else if(temp.size()>0)next = temp.get(0);
    return next;
  };
  
  cell findNearestUPDN(cell c,cell b){
    cell next = null;
    ArrayList<cell> temp = new ArrayList<cell>();
    for(int i=c.xpos-1;i<c.xpos+2;i++){
      for(int j=c.ypos-1;j<c.ypos+2;j++){
        int x = i;
        int y = j;
        int pos = (x)+(y)*(cols);
        cell c1 = null;
        //if(x>=0&&y>=0&&pos>=0&&pos!=c.id)println("pos id",pos,x,y);
        if(x>=0&&y>=0&&pos<grid.size()&&
        i>-1&&j>-1&&
        pos>0&&!visiteds(pos)&&
        pos!=c.id&&!visitedBy(c,pos)
          &&!visited(pos)){
          //println("pos id",pos,x/,y);
          cell c2 = grid.get(pos);
          //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos,"c2 id",c2.id);
          temp.add(c2);
        }
        //else 
        //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos);
      }
    }
    
    if(temp.size()>1){
      cell d = temp.get(0);
      ArrayList<cell> temp2 = new ArrayList<cell>();
      for (int i=1;i<temp.size();i++){
        cell d2 = temp.get(i);
        int dx = abs(c.xpos-d.xpos);
        int dy = abs(c.ypos-d.ypos);
        
        int d2x = abs(c.xpos-d2.xpos);
        int d2y = abs(c.ypos-d2.ypos);
        
        if(d2x*d2x+d2y*d2y<dx*dx+dy*dy)d = d2;
      }
      next = d;
      println("cellnerst ",next);
    }else if(temp.size()>0)next = temp.get(0);
    return next;
  };
  
  cell findNext2(cell c){
    cell next = null;
    ArrayList<cell> temp = new ArrayList<cell>();
    for(int i=c.xpos-1;i<c.xpos+2;i++){
      for(int j=c.ypos-1;j<c.ypos+2;j++){
        int x = i;
        int y = j;
        int pos = (x)+(y)*(cols);
        cell c1 = null;
        //if(x>=0&&y>=0&&pos>=0&&pos!=c.id)println("pos id",pos,x,y);
        if(x>=0&&y>=0&&pos<grid.size()&&
        i>-1&&j>-1&&
        pos>0&&!visiteds(pos)&&
        pos!=c.id&&!visitedBy(c,pos)
          &&!visited(pos)){
          //println("pos id",pos,x/,y);
          cell c2 = grid.get(pos);
          //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos,"c2 id",c2.id);
          temp.add(c2);
        }
        //else 
        //println("pos id",c.id,"yp",c.ypos,"xp",c.xpos,"i",i,"j",j,"pos",pos);
      }
    }
    int r = floor(random(temp.size()));
    //grid.get(r).visitedBy.add(c);
    if(temp.size()>0)
    next = temp.get(r);
    println("cellfn",r,next);
    return next;
  };
  
  //boolean visitedBy(cell c,cell b){
  //  boolean k = false;
  //  for(int i=0;i<b.visitedBy.size();i++){
  //      cell c1 = b.visitedBy.get(i);
  //      if(c1!=c){
  //        k = true;
  //        break; 
  //      }
  //  }
  //  return k;
  //};
  
  boolean visited2(int pos){
     return pos<grid.size()&&grid.get(pos).visited2;
  };
  
  boolean visiteds(int pos){
     return pos<grid.size()&&grid.get(pos).visiteds;
  };
  
  boolean visited(int pos){
     return pos<grid.size()&&grid.get(pos).visited;
  };
  
  boolean toggle(int pos){
    return pos<grid.size()&&grid.get(pos).toggle;
  }
  
  boolean visitedBy(cell c,int pos){
    boolean k = false;
    if(pos<grid.size()&&grid.get(pos).visitedBy.get(c)==null);
    else k = true;
    //println("visitedBy",pos,c,k);
    return k;
  }
  
  void trimStack(ArrayList<cell> a){
    
    for(int i=a.size()-1;i>-1;i--){
    cell next = null;
    next = findNext2(a.get(i));
    cell d = next;
    //if(d==null)println("trimstckkgfggflg index",i,null);
    if(next!=null){
      //println("trimstck brk",i,a.size(),next.id);
      //a.get(i).pcol2 = color(0,0,0,150);
      break;
    }
    if(next==null){
      a.get(i).visited3 = true;
      //a.get(i).col = color(0,255,0,0);
      a.remove(i);
      //println("remove from stck",i,a.size());
      //a.remove(i);
      
    }}
    //println("trimmed",a.size());
  };
  
  void trimStackN(ArrayList<cell> a,cell b){
    
    for(int i=a.size()-1;i>-1;i--){
    cell next = null;
    next = findNearest(a.get(i),b);
    cell d = next;
    //if(d==null)println("trimstckkgfggflg index",i,null);
    if(next!=null){
      //if(next==b)
      //println("trimstck brk",i,a.size(),next.id);
      //a.get(i).pcol2 = color(0,0,0,150);
      break;
    }
    if(next==null){
      a.get(i).visited3 = true;
      //a.get(i).col = color(0,255,0,0);
      a.get(i).visiteds = false;
      a.remove(i);
      println("remove from stck",i,a.size());
      //a.remove(i);
      
    }}
    //println("trimmed",a.size());
  };
  cell cell(int pos){
    //println("cell",pos,grid.size());
    if(pos<grid.size()-1&&pos>0)return  grid.get(pos);
    else return null;
  }
  
  boolean verify(int x,int y,int pos,cell c){
    int dx = (x-c.xpos);
    int dy = (y-c.ypos);
    boolean b = x>-1&&y>-1&&x<rows&&y<cols&&pos<grid.size();
    boolean b2 = dx>-1&&dy>-1&&x>-1&&y>-1&&x<rows&&y<cols&&pos<grid.size();
    boolean b3 = dx>-1&&dy>-1;
    //println("verify",b);
    //println("verify2",b2);
    //=0&&y>=0&&pos>0&&pos<grid.size()-1);
    return b;
  };
  
  void resit(){
    if(mousePressed&&mouseButton==LEFT&&keyPressed&&keyCode==17)reInit();
  };
  
  
};
