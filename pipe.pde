class Pipe{
  int pipeHeight = 1500;
  PImage pipeUp,pipeDown;
  int choose,position,yUp,yDown;
  
  Pipe(int choose){
    pipeUp = loadImage("./imgs/pipeUp.png");
    pipeDown = loadImage("./imgs/pipeDown.png");
    position = width*2;
    this.choose = choose;
    if(choose==1){
      yUp=-pipeHeight+500;
      yDown=pipeHeight-500;
    }
    if(choose==2){
      yUp=-pipeHeight+1000;
      yDown=pipeHeight;
    }
    if(choose==3){
      yUp=0;
      yDown=pipeHeight+500;
    }
  }
  
  void drawPipe(){
    rectMode(CENTER);
    pushMatrix();
    scale(0.3,0.2);
    image(pipeUp,position,yUp);
    popMatrix();
    pushMatrix();
    scale(0.3,0.2);
    image(pipeDown,position,yDown);
    popMatrix();
  }
  
  int getPosition(){
    return position;
  }
  
  PVector getColision(){
    if(choose==1)return new PVector(height/3-60,height/3+40);
    if(choose==2)return new PVector(height/2-40,height/2+80);
    if(choose==3)return new PVector(2*height/3-35,2*height/3+80);
    return new PVector();
    
  }
  
  int getYDown(){
    return yDown;
  }
  
  void update(){
    position-=12;
  }
}
