import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;
import java.util.*;
enum State {
  GAME,
  PAUSE,
  INIT,
  END;
}
Capture cam;
CVImage img;
PImage bird;
boolean justOnce;
State state;
int anchoMayor,altoMayor;
CascadeClassifier face;
String faceFile;
int pipeHeight = 1500;
int contador;
List<Pipe> pipeList;
PVector posBird;
void setup() {
  size(640, 480);
  //Cámara
  contador=0;
  state = State.INIT;
  cam = new Capture(this, width , height);
  cam.start(); 
  bird = loadImage("./imgs/flappy-bird.png");
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  img = new CVImage(cam.width, cam.height);
  posBird = new PVector();
  //Detectores
  faceFile = "haarcascade_frontalface_default.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  pipeList = new ArrayList();
  Pipe pipe= new Pipe(2);
  pipeList.add(pipe);
  
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();
    textSize(20);
    
    //Obtiene la imagen de la cámara
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    
    //Imagen de grises
    Mat gris = img.getGrey();
    
    //Imagen de entrada
    image(img,0,0);
    text(contador,width/2,height/8);
    if(state == State.GAME){
      if(!pipeList.isEmpty()){
        if(pipeList.size()==5)pipeList.remove(0);
        int tam = pipeList.size()-1;
        if(pipeList.get(tam).getPosition()< 3*(width/4)){
          generatePipes();
        }
      }
      //Detección y pintado de contenedores
      FaceDetect(gris);
      for(Pipe pip : pipeList){
        if(pip.getPosition()+5> posBird.x && pip.getPosition()-5<posBird.x){
          if(pip.getColision().x<posBird.y && pip.getColision().y>posBird.y){
            contador++;  
          }else{
            state = State.END;
          }
        }
        
        pip.drawPipe();
        pip.update();
      }
      gris.release();
    }
  }
  if(state == State.PAUSE){
    textSize(30);
    text("Pulsa ESPACIO para volver a jugar",100,height/2);
  }
  if(state == State.END){
    textSize(30);
    text("Pulsa ESPACIO para volver a la\n            pantalla inicial",100,height/2);
    inicializa();
  }
  if(state == State.INIT){
    textSize(30);
    text("Pulsa ESPACIO para empezar a jugar",70,height/2);
  }
}
void generatePipes(){
  Pipe pipe;
  int numero = (int)(Math.random()*3+1);
  pipe = new Pipe(numero);
  pipeList.add(pipe);
}

void FaceDetect(Mat grey)
{
  
  //Detección de rostros
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale(grey, faces, 1.15, 3, 
    Objdetect.CASCADE_SCALE_IMAGE, 
    new Size(60, 60), new Size(200, 200));
  Rect [] facesArr = faces.toArray();
  
   //Dibuja contenedores
  noFill();
  stroke(255,0,0);
  strokeWeight(4);
  for (Rect r : facesArr) { 
    bird.resize(0,60);
    
    image(bird,r.x+r.width/3,r.y);
    posBird.x = r.x;
    posBird.y = r.y;
   }
  
 
  faces.release();
}
void inicializa(){
  pipeList = new ArrayList();
  Pipe pipe = new Pipe(2);
  pipeList.add(pipe);
  contador=0;
}

void keyPressed() {
  if(key == ' ' ){
    justOnce = true;
      if(state == State.PAUSE && justOnce){
        state = State.GAME;
        justOnce = false;
      }
      if(state == State.INIT && justOnce){
        state = State.GAME;
        justOnce = false;
      }
      if(state == State.END && justOnce){
        state = State.INIT;
        justOnce = false;
      }
      if(state == State.GAME && justOnce){
        state = State.PAUSE;
        justOnce = false;
      }
  }
}
