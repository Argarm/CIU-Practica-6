import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
//Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;
int x,x1,x2;
Capture cam;
CVImage img;
PImage bird,pipeUp,pipeDown;
//Cascadas para detección
CascadeClassifier face,leye,reye;
//Nombres de modelos
String faceFile, leyeFile,reyeFile;
int pipeHeight = 1500;
void setup() {
  size(640, 480);
  //Cámara
  cam = new Capture(this, width , height);
  cam.start(); 
  bird = loadImage("flappy-bird1.jpg");
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
  leye = new CascadeClassifier(dataPath(leyeFile));
  reye = new CascadeClassifier(dataPath(reyeFile));
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
    printPipes();
    //Detección y pintado de contenedores
    FaceDetect(gris);
    
    gris.release();
  }
}
void printPipes(){
  
  alto();
  
  medio();

  bajo();
  
  
  x+=5;
  x1+=5;
  x2+=5;
}

void alto(){
  pushMatrix();
  scale(0.3,0.2);
  image(pipeUp,width*2-x,-pipeHeight+500);
  popMatrix();
  pushMatrix();
  scale(0.3,0.2);
  image(pipeDown,width*2-x,pipeHeight-500);
  popMatrix();
}

void medio(){
  pushMatrix();
  scale(0.3,0.2);
  image(pipeUp,width*2-x1,-pipeHeight+1000);
  popMatrix();
  pushMatrix();
  scale(0.3,0.2);
  image(pipeDown,width*2-x1,pipeHeight);
  popMatrix();
}

void bajo(){
  pushMatrix();
  scale(0.3,0.2);
  image(pipeUp,width*2-x2,0);
  popMatrix();
  pushMatrix();
  scale(0.3,0.2);
  image(pipeDown,width*2-x2,pipeHeight+500);
  popMatrix();
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
