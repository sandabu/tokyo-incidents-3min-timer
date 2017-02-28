import ddf.minim.*;  //<>//

Minim minim; 
AudioPlayer player;

int[] sideH = {10, 15, 21, 23};
int sideM;
int sideS;
int sideMS;

int m = 59 - 56;
int s = 59 - 53;
int ms = 0;

int countDownMillis;
int tmpMillis;

PFont segmentFont;
PFont segmentSmallFont;
int scene = 0;
PImage logo;
PImage charLogo;

float firstPosition;
float secondPosition;
float thirdPosition;
float fourthPosition;
float center;

boolean willStop = false;

ArrayList scripts = new ArrayList();

void setup() {
  //Frame Settings
  //size(1280, 800);
  fullScreen();
  frameRate(20);

  //Player Settings
  minim = new Minim(this);
  player = minim.loadFile("noudou-master.mp3");

  //Position Settings
  firstPosition    = (height / 8) + 2.5;
  secondPosition   = firstPosition * 3;
  thirdPosition    = firstPosition * 5;
  fourthPosition   = firstPosition * 7;
  center           = width / 2;

  //Font Settings
  fill(255, 0, 0);
  segmentFont = loadFont("DSEG7Modern-BoldItalic-48.vlw");
  segmentSmallFont = loadFont("DSEG7Modern-BoldItalic-12.vlw");
  textFont(segmentFont, 72);
  textAlign(CENTER);

  logo = loadImage("jihen-logo.png");
  charLogo = loadImage("jihen-char-logo.png");
  imageMode(CENTER);
  
  noLoop();
}

void draw() {
  background(0); 
  
  switch(scene) {
  case 0:
    image(charLogo, center, height / 2, 690, 223.5);
    break;
  case 1: 
    countDownWatch();
    renderInitial();
    if (sideS == 1) {
      //シーン2の初期化
      scene = 2;
      m = 2;
      s = 58;
      ms = 99;
    }
    break;
  case 2: 
    if (willStop) {
      delay(2000);
      scene = 3;
      tmpMillis = millis();
    } else {
      //renderCaption();
      countDownWatch();
    }
    renderCountDownWatch();
    break;
  case 3:
    countDownWatch();
    renderEnding();
    break;
  default: 
    return;
  }
}

void countDownWatch() {

  ms = floor((countDownMillis - millis()) / 10);
  if (ms <= 0) {
    countDownMillis = millis() + 1000;
    if (s == 0 && m == 0) {
      //タイマー終了
      willStop = true;
    }
    s -= 1;
    ms = 0;
  }
  if (s < 0) {
    s = 59;
    m -= 1;
  }

  sideM = 59 - m;
  sideS =  59 - s;
  sideMS = ms <= 0 ? 0 : 100 - ms;

  if (sideS == 0 && !player.isPlaying()) {
    player.play();
  }
}

void renderInitial() {
  textFont(segmentFont, 72);
  fill(0, 255, 0);
  if (sideS >= 53 && sideS < 57) {
    renderSideTimer(0);
    image(logo, width / 2, firstPosition, width / 6, width / 6);
  }
  if (sideS >= 54 && sideS < 58) {
    renderSideTimer(1);
    image(logo, width / 2, secondPosition, width / 6, width / 6);
  }
  if (sideS >= 55 && sideS < 59) {
    renderSideTimer(2);
    image(logo, width / 2, thirdPosition, width / 6, width / 6);
  }
  if (sideS >= 56 && sideS < 60) {
    renderSideTimer(3);
    image(logo, width / 2, fourthPosition, width / 6, width / 6);
  }

  if (sideS >= 57 || sideS == 0) {
    renderSideTimer(0);
    textFont(segmentFont, 72);
    text (sideH[0] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, firstPosition);
  }
  if (sideS >= 58 || sideS == 0) {
    renderSideTimer(1);
    textFont(segmentFont, 72);
    text (sideH[1] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, secondPosition);
  }
  if (sideS >= 59 || sideS == 0) {
    renderSideTimer(2);
    textFont(segmentFont, 72);
    text (sideH[2] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, thirdPosition);
  }
  if (sideS == 0) {
    renderSideTimer(3);
    textFont(segmentFont, 72);
    text (sideH[3] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, fourthPosition);
  }
}

void renderSideTimer(int i){
    float[] positions = {firstPosition, secondPosition, thirdPosition, fourthPosition};
    float char_w = height * 2 / 9;
    float char_h = width / 20;
  
    textFont(segmentSmallFont, 12);
    fill(255, 0, 0);
    pushMatrix();
    float ratio = - PI / 2; //30
    translate(char_h, positions[i]);
    rotate(ratio);
    text (sideH[i] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), - char_w / 2, - char_h / 2, char_w, char_h);
    popMatrix();
}

void renderCaption(String right, String left){
  textFont(cinecapFont, 42);
  fill(255, 255, 255);
  text (right, width - 150, height / 10, 50, height * 9 / 10);
  text (left,  width - 200, height / 5,  50, height * 9 / 10);
}

void renderEnding() {
  textFont(segmentFont, 72);
  fill(255, 0, 0);
  int diffMS = millis() - tmpMillis;
  
  if (diffMS <= 300) {
    text (sideH[0] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, firstPosition);
    text (sideH[1] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, secondPosition);
    text (sideH[2] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, thirdPosition);
    text (sideH[3] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, fourthPosition);
    for(int i = 0; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if (diffMS > 300 && diffMS <= 600) {
    image(logo, width / 2, firstPosition, width / 6, width / 6);
    text (sideH[1] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, secondPosition);
    text (sideH[2] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, thirdPosition);
    text (sideH[3] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, fourthPosition);
    for(int i = 0; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if (diffMS > 600 && diffMS <= 900) {
    image(logo, width / 2, firstPosition, width / 6, width / 6);
    image(logo, width / 2, secondPosition, width / 6, width / 6);
    text (sideH[2] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, thirdPosition);
    text (sideH[3] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, fourthPosition);
    for(int i = 0; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if (diffMS > 900 && diffMS <= 1200) {
    image(logo, width / 2, firstPosition, width / 6, width / 6);
    image(logo, width / 2, secondPosition, width / 6, width / 6);
    image(logo, width / 2, thirdPosition, width / 6, width / 6);
    text (sideH[3] + " : " +  nf(sideM, 2) + " : " + nf(sideS, 2) + " : " +nf(sideMS, 2), width / 2, fourthPosition);
    for(int i = 0; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if(diffMS > 1200 && diffMS <= 1500){
    image(logo, width / 2, firstPosition, width / 6, width / 6);
    image(logo, width / 2, secondPosition, width / 6, width / 6);
    image(logo, width / 2, thirdPosition, width / 6, width / 6);
    image(logo, width / 2, fourthPosition, width / 6, width / 6);
    for(int i = 0; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if(diffMS > 1500 && diffMS <= 1800){
    image(logo, width / 2, firstPosition, width / 6, width / 6);
    image(logo, width / 2, secondPosition, width / 6, width / 6);
    image(logo, width / 2, thirdPosition, width / 6, width / 6);
    image(logo, width / 2, fourthPosition, width / 6, width / 6);
    for(int i = 0; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if(diffMS > 1800 && diffMS <= 2100){
    image(logo, width / 2, secondPosition, width / 6, width / 6);
    image(logo, width / 2, thirdPosition, width / 6, width / 6);
    image(logo, width / 2, fourthPosition, width / 6, width / 6);
    for(int i = 1; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if(diffMS > 2100 && diffMS <= 2400){
    image(logo, width / 2, thirdPosition, width / 6, width / 6);
    image(logo, width / 2, fourthPosition, width / 6, width / 6);
    for(int i = 2; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if(diffMS > 2400 && diffMS <= 2700){
    image(logo, width / 2, fourthPosition, width / 6, width / 6);
    for(int i = 3; i < 4; i++) {
      renderSideTimer(i);
    }
  } else if(diffMS > 3500){
    image(charLogo, center, height / 2, 690, 223.5);
    for(int i = 4; i < 4; i++) {
      renderSideTimer(i);
    }
  }

}

void renderCountDownWatch() {
  textFont(segmentFont, 72);
  fill(0, 255, 0);
  if (willStop) {
    fill(255, 0, 0);
    text ("-00 : 00 : 00", width / 2, firstPosition);
    text ("-00 : 00 : 00", width / 2, secondPosition);
    text ("-00 : 00 : 00", width / 2, thirdPosition);
    text ("-00 : 00 : 00", width / 2, fourthPosition);
  } else {
    text ("-" + nf(m, 2) + " : " + nf(s, 2) + " : " +nf(ms, 2), width / 2, firstPosition);
    text ("-" + nf(m, 2) + " : " + nf(s, 2) + " : " +nf(ms, 2), width / 2, secondPosition);
    text ("-" + nf(m, 2) + " : " + nf(s, 2) + " : " +nf(ms, 2), width / 2, thirdPosition);
    text ("-" + nf(m, 2) + " : " + nf(s, 2) + " : " +nf(ms, 2), width / 2, fourthPosition);
  }
  for(int i = 0; i < 4; i++) {
    renderSideTimer(i);
  }
}

void keyPressed() {
  if (key == ' ') {
    loop();
    scene = 1;
    countDownMillis = millis() + 1000;
  }
  if (key == '+') {
    float gain = player.getGain();
    player.setGain(gain + 1.0f);
  }
  if (key == '-') {
    float gain = player.getGain();
    player.setGain(gain - 1.0f);
  }
  if (key == 't') {
    if(!player.isPlaying()){
      player.play(90000);
    }else{
      player.pause();
      player.rewind();
    }
  }
}

void stop() {
  player.close();  //サウンドデータを終了
  minim.stop();
  super.stop();
}