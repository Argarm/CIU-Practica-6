class Pipe{
  int pipeHeight = 1500;
  PImage pipeUp,pipeDown;
  int position,yUp,yDown;
  
  Pipe(int choose){
    pipeUp = loadImage("pipeUp.png");
    pipeDown = loadImage("pipeDown.png");
    position = width*2;
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
  void update(){
    position-=10;
  }
}
