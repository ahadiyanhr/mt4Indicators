//+------------------------------------------------------------------+
//|                                                     SD Zones.mq4 |
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
double Price;
double SLPrice1;
double SLPrice2;
datetime DT1; // Start Datetime
datetime DT2; // End Datetime
string Name; // Name of Level
bool backflag;

enum TypesList
      {
      Supply=0,
      Demand=1,
      };
input TypesList Type; // Zone Type
enum TimeList
      {
      MN=0,
      W1=1,
      D1=2,
      H4=3,
      H1=4,
      M30=5,
      M15=6,
      M5=7,  
      };
input TimeList Timeframe = D1; // TimeFrame
input TimeList Visualization = W1; // Visualization (Show on Timeframes)
input string Notes = "Your Notes ..."; // Your Notes:
string Notes1;
string Notes2;
color ColorBox;
color SLColorBox = C'245,160,177';

//-- INITIAL NUMERATOR:
int j = 1; // LevelFind Numerator


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   
   if(ObjectFind(0,"SSH")==0)
      {
      if(ObjectFind(0,"SSH1")==0)
         {
         SLPrice1 = ObjectGet("SSH1", OBJPROP_PRICE1); // Price of SL
         }      
      HighRange = ObjectGet("SSH", OBJPROP_PRICE1); // New High Price of Range
      LowRange = ObjectGet("SSH", OBJPROP_PRICE2); // New Low Price of Range
      DT1 = ObjectGet("SSH", OBJPROP_TIME1); // New Start Datetime
      DT2 = ObjectGet("SSH", OBJPROP_TIME2); // New End Datetime
      if(HighRange < LowRange)
         {
         Price = HighRange;
         HighRange = LowRange;
         LowRange = Price;
         }
      if(DT2 < DT1)
         {
         DT1 = DT2;
         }
      
      
      string Timeframes[8] = { "MN", "W1", "D1", "H4", "H1", "M30", "M15", "M5" };
      datetime Datetime1 =  DT1;
      datetime Datetime2 =  D'2032.01.01 00:00:00';
            
      if(Type == 0)
         {
         Name = Timeframes[Timeframe]+" SUP";
         ColorBox = C'245,160,177';
         if(ObjectFind(0,"SSH1")==0)
            {
            SLPrice2 = HighRange;
            }
         Notes2 = "-Down";
         }
      else if(Type == 1)
         {
         Name = Timeframes[Timeframe]+" DEM";
         ColorBox = C'170,170,213';
         if(ObjectFind(0,"SSH1")==0)
            {
            SLPrice2 = LowRange;
            }
         Notes2 = "-Up";
         }
         
      if(Notes == "Your Notes ...")
         {
         Notes1 = "";
         }
      else if(Notes != "Your Notes ...")
         {
         Notes1 = ", "+Notes;
         }
   
         
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
   
      // Draw Level Object:    
      ObjectCreate(0,Name+"-"+string(j), OBJ_RECTANGLE , 0, Datetime1, HighRange, Datetime2, LowRange);
                 ObjectSet(Name+"-"+string(j), OBJPROP_COLOR, ColorBox);
                 ObjectSet(Name+"-"+string(j), OBJPROP_FILL, True);
                 ObjectSet(Name+"-"+string(j), OBJPROP_BACK, True);
                 ObjectSet(Name+"-"+string(j), OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j), OBJPROP_SELECTABLE, false);
      
      if(ObjectFind(0,"SSH1")==0)
         {
         ObjectCreate(0,Name+"-"+string(j)+"-SL", OBJ_RECTANGLE , 0, Datetime1, SLPrice1, Datetime2, SLPrice2);
                 ObjectSet(Name+"-"+string(j)+"-SL", OBJPROP_COLOR, SLColorBox);
                 ObjectSet(Name+"-"+string(j)+"-SL", OBJPROP_FILL, True);
                 ObjectSet(Name+"-"+string(j)+"-SL", OBJPROP_BACK, True);
                 ObjectSet(Name+"-"+string(j)+"-SL", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-SL", OBJPROP_SELECTABLE, false);
         }               
                                  
      ObjectCreate(Name+"-"+string(j)+"-Up", OBJ_HLINE , 0, Time[0], HighRange);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_STYLE, 1);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_COLOR, clrBlack);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_WIDTH, 1);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_BACK, false);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_SELECTABLE, false);
                 
                
      ObjectCreate(Name+"-"+string(j)+"-Down", OBJ_HLINE , 0, Time[0], LowRange);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_STYLE, 1);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_COLOR, clrBlack);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_WIDTH, 1);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_BACK, false);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_SELECTABLE, false);
                 
      ObjectSetString(0,Name+"-"+string(j)+Notes2, OBJPROP_TEXT, Name+Notes1);
      
      if(ObjectFind(0,"SSH1")==0)
         {
         ObjectCreate(Name+"-"+string(j)+"-SL-Line", OBJ_HLINE , 0, Time[0], SLPrice1);
                 ObjectSetString(0,Name+"-"+string(j)+"-SL-Line", OBJPROP_TEXT, "StopLoss");
                 ObjectSet(Name+"-"+string(j)+"-SL-Line", OBJPROP_STYLE, 1);
                 ObjectSet(Name+"-"+string(j)+"-SL-Line", OBJPROP_COLOR, clrRed);
                 ObjectSet(Name+"-"+string(j)+"-SL-Line", OBJPROP_WIDTH, 1);
                 ObjectSet(Name+"-"+string(j)+"-SL-Line", OBJPROP_BACK, false);
                 ObjectSet(Name+"-"+string(j)+"-SL-Line", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-SL-Line", OBJPROP_SELECTABLE, false);
         }
      
      if(Visualization == 0)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
            }
         }
         
      if(Visualization == 1)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1|OBJ_PERIOD_W1);
            }
         }               
      
      if(Visualization == 2)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4|OBJ_PERIOD_D1);
            }
         }
      
      if(Visualization == 3)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1|OBJ_PERIOD_H4);
            }
         }
      
      if(Visualization == 4)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30|OBJ_PERIOD_H1);
            }
         }
      
      if(Visualization == 5)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15|OBJ_PERIOD_M30);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
            }
         }
      
      if(Visualization == 6)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5|OBJ_PERIOD_M15);
            }
         }
      
      if(Visualization == 7)
         {
         ObjectSetInteger(0,Name+"-"+string(j),OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Up",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5);
         ObjectSetInteger(0,Name+"-"+string(j)+"-Down",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5);
         if(ObjectFind(0,"SSH1")==0)
            {
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5);
            ObjectSetInteger(0,Name+"-"+string(j)+"-SL-Line",OBJPROP_TIMEFRAMES,OBJ_PERIOD_M1|OBJ_PERIOD_M5);
            }
         }         
      }
   else if(ObjectFind(0,"SSH")!=0)
      {
      Alert("First draw a 'RECTANGLE' with the name of 'SSH'.");
      }
                
  }
//+------------------------------------------------------------------+
