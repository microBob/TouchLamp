#include "pins.h"
//Init
const int ppins[] = {11, 5, 10, 3, 9}; //the different pins and their #s

//Global Var
boolean onoff = false;

int mode = 0;

int fv = 0;// analog output value in flow application

boolean ext = false;// exit flow application [?]

//Developer : Kenneth Y
//kenneth.yang@is88.com

void setup() {//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Serial.begin(9600);
  pinMode(five, OUTPUT);
  pinMode(four, OUTPUT);
  pinMode(three, OUTPUT);
  pinMode(two, OUTPUT);
  pinMode(one, OUTPUT);

}//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

void loop() {//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  // put your main code here, to run repeatedly:
  int pressOn = readCap(oo);
  int pressPh = readCap(ph);
  int pressFlo = readCap(flo);
  //Serial.println(String(pressOn) + "," + String(pressPh) + "," + String(pressFlo));

//check wich pad was pressed  V
  if (pressOn > 1) {
    mode = 1;
  }
  else if (pressPh > 2) {
    mode = 2;
  }
  else if (pressFlo > 1) {
    mode = 3;
  }
// ^

  if (mode == 1) {//on/off
    if (pressOn > 1) {
      if (onoff) {
        offAll();
      }
      else if (!onoff) {
        onAll();
      }
    }

    delay(250);
  }
  else if (mode == 2) {//use photo resistor to make "perfect" brightness
    long brightness = analogRead(ph);
    int bright = map(brightness, 0, 1023, 0, 255);

    if (1023 - bright > 0) {
      onoff = true;
    }
    else {
      onoff = false;
    }

    analogWrite(five, 1023 - bright);
    off(four);
    analogWrite(three, 1023 - bright);
    off(two);
    analogWrite(one, 1023 - bright);
  }
  else if (mode == 3) {//flo
    offAll();
    fv = 0;


    for (int l = 0; l < 5; l++) { //flowing up the lights
      for (int ll = 0; ll < 52; ll++) {
        analogWrite(ppins[l], 5 * ll);
        delay(20);
        endFlo();
        if (ext) {
          break;
        }
      }
      on(ppins[l]);
      if (ext) {
        ext = false;
        offAll();
        onoff=false;
        break;
      }
    }
    onAll();
    onoff=true;
    for (int l = 4; l > -1; l--) {  //flowing down the lights
      for (int ll = 52; ll > 0; ll--) {
        analogWrite(ppins[l], 5 * ll);
        delay(20);
        endFlo();
        if (ext) {
          break;
        }
      }
      off(ppins[l]);
      if (ext) {
        ext = false;
        offAll();
        onoff=false;
        break;
      }
    }
    delay(500);
  }
}//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//Functions
//New~~~~~~~~~~~~~~~~
void endFlo() { //end the flowing pattern application
  if (readCap(oo) > 1 || readCap(ph) > 2){
    ext = true;
    offAll();
    fv = 0;
  }
}
void offAll() { //function to turn off all lights
  off(one);
  off(two);
  off(three);
  off(four);
  off(five);
  onoff = false;
}
void onAll() {  //function to turn on all lights
  on(one);
  on(two);
  on(three);
  on(four);
  on(five);
  onoff = true;
}

//Back~~~~~~~~~~~~~~~~~~
void on(int pin) {  //function to turn on the inputted pin
  digitalWrite(pin, HIGH);
}
void off(int pin) { //function to turn off the inputted pin
  digitalWrite(pin, LOW);
}

//capacitive sensor code Credit:
//Mario Becker for original code
//Paul Stoffregen for updates on the code
uint8_t readCap(int pinToMeasure) { //Capacitive sensor reading function
  volatile uint8_t* port;
  volatile uint8_t* ddr;
  volatile uint8_t* pin;
  byte bitmask;
  port = portOutputRegister(digitalPinToPort(pinToMeasure));
  ddr = portModeRegister(digitalPinToPort(pinToMeasure));
  bitmask = digitalPinToBitMask(pinToMeasure);
  pin = portInputRegister(digitalPinToPort(pinToMeasure));
  *port &= ~(bitmask);
  *ddr  |= bitmask;
  delay(1);
  uint8_t SREG_old = SREG;
  noInterrupts();
  *ddr &= ~(bitmask);
  *port |= bitmask;
  uint8_t cycles = 17;
  if (*pin & bitmask) {
    cycles =  0;
  } else if (*pin & bitmask) {
    cycles =  1;
  } else if (*pin & bitmask) {
    cycles =  2;
  } else if (*pin & bitmask) {
    cycles =  3;
  } else if (*pin & bitmask) {
    cycles =  4;
  } else if (*pin & bitmask) {
    cycles =  5;
  } else if (*pin & bitmask) {
    cycles =  6;
  } else if (*pin & bitmask) {
    cycles =  7;
  } else if (*pin & bitmask) {
    cycles =  8;
  } else if (*pin & bitmask) {
    cycles =  9;
  } else if (*pin & bitmask) {
    cycles = 10;
  } else if (*pin & bitmask) {
    cycles = 11;
  } else if (*pin & bitmask) {
    cycles = 12;
  } else if (*pin & bitmask) {
    cycles = 13;
  } else if (*pin & bitmask) {
    cycles = 14;
  } else if (*pin & bitmask) {
    cycles = 15;
  } else if (*pin & bitmask) {
    cycles = 16;
  }
  SREG = SREG_old;
  *port &= ~(bitmask);
  *ddr  |= bitmask;
  return cycles;
}
