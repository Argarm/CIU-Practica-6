import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;
import java.util.*;
int x,x1,x2;
Capture cam;
CVImage img;
PImage bird,pipeUp,pipeDown;

CascadeClassifier face,leye,reye;
String faceFile, leyeFile,reyeFile;
int pipeHeight = 1500;

List<Pipe> pipeList;
void setup() {
  size(640, 480);
  //Cámara
  cam = new Capture(this, width , height);
  cam.start(); 
  bird = loadImage("flappy-bird1.png");
  pipeUp = loadImage("pipeUp.png");
  pipeDown = loadImage("pipeDown.png");
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
  println(Core.VERSION);
  img = new CVImage(cam.width, cam.height);
  
  //Detectores
  faceFile = "haarcascade_frontalface_default.xml";
  leyeFile = "haarcascade_mcs_lefteye.xml";
  reyeFile = "haarcascade_mcs_righteye.xml";
  face = new CascadeClassifier(dataPath(faceFile));
  pipeList = new ArrayList();
  Pipe pipe= new Pipe(2);
  pipeList.add(pipe);
}

void draw() {  
  if (cam.available()) {
    background(0);
    cam.read();
    
    //Obtiene la imagen de la cámara
    img.copy(cam, 0, 0, cam.width, cam.height, 
    0, 0, img.width, img.height);
    img.copyTo();
    
    //Imagen de grises
    Mat gris = img.getGrey();
    
    //Imagen de entrada
    image(img,0,0);
    if(!pipeList.isEmpty()){

      int tam = pipeList.size()-1;
      if(pipeList.get(tam).getPosition()< 3*(width/4)){
        generatePipes();
      }
    }
    //Detección y pintado de contenedores
    FaceDetect(gris);
    for(Pipe pip : pipeList){
      pip.drawPipe();
      pip.update();
    }
    gris.release();
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
    bird.resize(0,50);
    image(bird,r.x+r.width/4,r.y);
   }
  
 
  faces.release();
}
