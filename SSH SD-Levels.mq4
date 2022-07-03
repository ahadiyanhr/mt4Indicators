//+------------------------------------------------------------------+
//|                                                    SSH Zones.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

//-- INPUTS:
double HighRange; // High Price of Range
double LowRange; // Low Price of Range
datetime DT1; // Start Datetime
datetime DT2; // End Datetime
string Name; // Name of Level

enum TimeframesList
      {
      MN=0,
      W1=1,
      D1=2,
      H4=3,
      H1=4,
      M15=5,
      M5=6,
      M1=7,
      MN6=8   
      };
input TimeframesList Timeframe; // Timeframes
input string Notes = "Your Notes ..."; // Your Notes:
string Notes1;

//-- INITIAL NUMERATOR:
int i = 0; // Level Numerator
int j = 1; // LevelFind Numerator

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   if(ObjectFind(0,"SSH")==0)
      {
      Print(ObjectGet("SSH", OBJPROP_TIME1));
      HighRange = ObjectGet("SSH", OBJPROP_PRICE1); // New High Price of Range
      LowRange = ObjectGet("SSH", OBJPROP_PRICE2); // New Low Price of Range
      DT1 = ObjectGet("SSH", OBJPROP_TIME1); // New Start Datetime
      DT2 = ObjectGet("SSH", OBJPROP_TIME2); // New End Datetime
      
      
      string Timeframes[9] = { "MN", "W1", "D1", "H4", "H1", "M15", "M5", "M1", "MN6" };
      datetime Datetime1 =  DT1;
      datetime Datetime2 =  D'2030.01.01 00:00:00';
   
      // Find Color of Level:
      while(Timeframe != i)
            {
            i++;
            }
            
      Name = Timeframes[i];
         
      // Find Last Levels in the Chart:
      if(j < 10)
         {
         while(ObjectFind(0,Name+"-"+string(j))==false)
            {
            j++;
            }
         }
      if(j >= 10)
         {
         while(ObjectFind(0,Name+"-"+string(j))==false)
            {
            j++;
            }
         }
      
      if(Notes == "Your Notes ...")
         {
         Notes1 = "";
         }
      else if(Notes != "Your Notes ...")
         {
         Notes1 = ", "+Notes;
         }
   
      // Draw Level Object:    
      ObjectCreate(0,Name+"-"+string(j), OBJ_RECTANGLE , 0, Datetime1, HighRange, Datetime2, LowRange);
                 ObjectSet(Name+"-"+string(j), OBJPROP_COLOR, C'140,140,255');
                 ObjectSet(Name+"-"+string(j), OBJPROP_FILL, True);
                 ObjectSet(Name+"-"+string(j), OBJPROP_BACK, True);
                 ObjectSet(Name+"-"+string(j), OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j), OBJPROP_SELECTABLE, false);
                                  
      
      ObjectCreate(Name+"-"+string(j)+"-Up", OBJ_HLINE , 0, Time[0], HighRange);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_STYLE, 0);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_COLOR, clrDarkBlue);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_WIDTH, 2);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_BACK, true);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_SELECTABLE, false);
                 
                
      ObjectCreate(Name+"-"+string(j)+"-Down", OBJ_HLINE , 0, Time[0], LowRange);
                 ObjectSetString(0,Name+"-"+string(j)+"-Down", OBJPROP_TEXT, Name+Notes1);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_STYLE, 0);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_COLOR, clrDarkBlue);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_WIDTH, 2);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_BACK, true);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_SELECTABLE, false);
                 
                 
                 if(i == 2)
                  {
                  ObjectSet(Name+"-"+string(j), OBJPROP_TIMEFRAMES, OBJ_PERIOD_W1|OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_TIMEFRAMES, OBJ_PERIOD_W1|OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_TIMEFRAMES, OBJ_PERIOD_W1|OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Text", OBJPROP_TIMEFRAMES, OBJ_PERIOD_W1|OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  }
                 else if(i == 3)
                  {
                  ObjectSet(Name+"-"+string(j), OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Text", OBJPROP_TIMEFRAMES, OBJ_PERIOD_D1|OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  }
                 else if(i == 4)
                  {
                  ObjectSet(Name+"-"+string(j), OBJPROP_TIMEFRAMES, OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_TIMEFRAMES, OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_TIMEFRAMES, OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Text", OBJPROP_TIMEFRAMES, OBJ_PERIOD_H4|OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  }
                 else if(i == 5)
                  {
                  ObjectSet(Name+"-"+string(j), OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Text", OBJPROP_TIMEFRAMES, OBJ_PERIOD_H1|OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  }
                 else if(i == 6)
                  {
                  ObjectSet(Name+"-"+string(j), OBJPROP_TIMEFRAMES, OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_TIMEFRAMES, OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_TIMEFRAMES, OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Text", OBJPROP_TIMEFRAMES, OBJ_PERIOD_M15|OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  }
                  else if(i == 7)
                  {
                  ObjectSet(Name+"-"+string(j), OBJPROP_TIMEFRAMES, OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_TIMEFRAMES, OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_TIMEFRAMES, OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  ObjectSet(Name+"-"+string(j)+"-Text", OBJPROP_TIMEFRAMES, OBJ_PERIOD_M5|OBJ_PERIOD_M1);
                  }
      }
   else if(ObjectFind(0,"SSH")!=0)
      {
      Alert("First draw a 'RECTANGLE' with the name of 'SSH'.");
      }
                
  }
//+------------------------------------------------------------------+
