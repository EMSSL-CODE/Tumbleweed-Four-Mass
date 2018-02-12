
#include <Wire.h>

#define dir1                    (5)      //Direction
#define stp1                    (6)      //Step
//#define EN1                     (28)      //Enable
#define MS1_1                   (2)      //Finer Motor control
#define MS2_1                   (3)      //Finer Motor control
#define MS3_1                   (4)      //Finer Motor control
int num=420;
int x;
void setup() 
{
  pinMode(dir1, OUTPUT);
  pinMode(stp1, OUTPUT);
  //pinMode(EN1, OUTPUT);
  pinMode(MS1_1, OUTPUT);
  pinMode(MS2_1, OUTPUT);
  pinMode(MS3_1, OUTPUT);

  digitalWrite(dir1, HIGH);
  digitalWrite(stp1, LOW);
  //digitalWrite(EN1, OUTPUT);
  digitalWrite(MS1_1, LOW);
  digitalWrite(MS2_1, HIGH);
  digitalWrite(MS3_1, LOW);


  Wire.begin(2); 
  Wire.onReceive(receiveEvent); // Attach a function to trigger when something is received.

}

void receiveEvent(int howmany) 
{
 int x = Wire.read();    // read one character from the I2C
 //int dir = Wire.read();  // Read Direction
// digitalWrite(dir1, dir);
}

void loop() 
{
  if (x<50 && x>0)
  {
    digitalWrite(stp1,HIGH); //Trigger one step forward
     delayMicroseconds(num-x*5);
    digitalWrite(stp1,LOW); //Pull step pin low so it can be triggered again
     delayMicroseconds(num-x*5);
    digitalWrite(stp1,HIGH); //Trigger one step forward
     delayMicroseconds(num-x*5);
    digitalWrite(stp1,LOW); //Pull step pin low so it can be triggered again
     delayMicroseconds(num-x*5);
         digitalWrite(stp1,HIGH); //Trigger one step forward
     delayMicroseconds(num-x*5);
    digitalWrite(stp1,LOW); //Pull step pin low so it can be triggered again
     delayMicroseconds(num-x*5);
         digitalWrite(stp1,HIGH); //Trigger one step forward
     delayMicroseconds(num-x*5);
    digitalWrite(stp1,LOW); //Pull step pin low so it can be triggered again
     delayMicroseconds(num-x*5);
         digitalWrite(stp1,HIGH); //Trigger one step forward
     delayMicroseconds(num-x*5);
    digitalWrite(stp1,LOW); //Pull step pin low so it can be triggered again
     delayMicroseconds(num-x*5);
  }
}













