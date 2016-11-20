

#include <dht.h>
#define LDR 0 

#define DHT11_PIN 12

dht DHT;



int ledPin[] = {10,9,8,7,6,5,4,3};//3, 4, 5, 6, 7, 8, 9, 10};
int ledPin_2[]={2,11};
 
int temperatura =0;
int humedad =0;
int luminosidad=0;

int valor_sensor;

int estado;



void setup() {
// Colocamos todos los pines del 3 al 10 como salida del bus.
   for (int i = 0; i < 8; i++)
  {
    pinMode(ledPin[i], OUTPUT);
  }

  for (int i = 0; i<2; i++)
  {
    pinMode(ledPin_2[i],OUTPUT);  
  }
  Serial.begin(9600);
  }


void loop() {
 
  // put your main code here, to run repeatedly:
// Leemos sensor de luz...///////

   valor_sensor = analogRead(LDR); 
   int lum_temp = (5.0 * valor_sensor * 100.0)/1024.0;
    if (lum_temp<255){
    luminosidad = (5.0 * valor_sensor * 100.0)/1024.0; 
    Serial.println(luminosidad);                       
    }
    if (lum_temp >255 ){
      luminosidad = 255;
      Serial.println(luminosidad); 
      }
////////////////////////////

// Leemos el sensor de temperatura ///////
int chk = DHT.read11(DHT11_PIN);
float temp = DHT.temperature;
int t;
t=(int)temp;
Serial.println(t);
temperatura = t;

// Leemos el sensor de temperatura ///////
float hume=DHT.humidity;
int h;
h=(int)hume;
Serial.println(h);
humedad = h;
///////////////////////////////////


estado = 1;


  displayBinary_2(estado);
  displayBinary(temperatura);

  delay (1000);
  
  displayBinary_2(estado+1);
  displayBinary(humedad);
  delay (1000);
  
  displayBinary_2(estado+2);
  displayBinary(luminosidad);
  delay (1000); 


}



// Metodo para desplegar binarios en un bus de 8 bits. 
void displayBinary(byte num)
{
  for (int i = 0; i < 8; i++)
  {
    if (bitRead(num, i) == 1)
    {
      digitalWrite(ledPin[i], HIGH);
    }
    else
    {
      digitalWrite(ledPin[i], LOW);
    }
  }
}
void displayBinary_2(byte num_2)
{
  for (int i = 0; i < 2; i++)
  {
    if (bitRead(num_2, i) == 1)
    {
      digitalWrite(ledPin_2[i], HIGH);
      
    }
    else
    {
      digitalWrite(ledPin_2[i], LOW);
   
    }
  }
}


