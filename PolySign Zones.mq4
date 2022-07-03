//+------------------------------------------------------------------+
//|                                               PolySign Zones.mq4 |
//|                          Copyright 2020, SinaShaabaz (PolySign). |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz (PolySign)."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

//-- INPUTS:
double HighRange; // High Price of Range
double LowRange; // Low Price of Range
double Price;
datetime DT1; // Start Datetime
datetime DT2; // End Datetime
string Name; // Name of Level
bool backflag;

enum TypesList
      {
      Supply=0,
      Demand=1,
      Invert=2
      };
input TypesList Type; // Zone Type
enum RespectList
      {
      Virgin=0,
      First=1,
      Second=2,
      Third=3,
      NotEng=4,  
      };
input RespectList Respect; // Number of Tounch
input string Notes = "Your Notes ..."; // Your Notes:
string Notes1;
color ColorBox;
color ColorLine;

//-- INITIAL NUMERATOR:
int i = 0; // Level Numerator
int ii = 0; // Level Numerator
int j = 1; // LevelFind Numerator
int width = 2;
int style = 0;

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
      
      
      string Respects[5] = { "0", "1", "2", "3", "NotEng" };
      datetime Datetime1 =  DT1;
      datetime Datetime2 =  D'2030.01.01 00:00:00';
   
      // Find Color of Level:
      while(Respect != i)
            {
            i++;
            }
            
      if(Type == 0)
         {
         Name = "SUP ["+Respects[i]+"]";
         ColorBox = C'128,213,166';
         ColorLine = clrMediumSeaGreen;
         }
      else if(Type == 1)
         {
         Name = "DEM ["+Respects[i]+"]";
         ColorBox = C'128,213,166';
         ColorLine = clrMediumSeaGreen;
         }
      else if(Type == 2)
         {
         Name = "Invert Trend";
         ColorBox = clrDarkTurquoise;
         ColorLine = clrLightSeaGreen;
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
                                  
      
      ObjectCreate(Name+"-"+string(j)+"-Up", OBJ_HLINE , 0, Time[0], HighRange);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_STYLE, 1);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_COLOR, ColorLine);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_WIDTH, 1);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_BACK, false);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-Up", OBJPROP_SELECTABLE, false);
                 
                
      ObjectCreate(Name+"-"+string(j)+"-Down", OBJ_HLINE , 0, Time[0], LowRange);
                 ObjectSetString(0,Name+"-"+string(j)+"-Down", OBJPROP_TEXT, Name+Notes1);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_STYLE, 1);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_COLOR, ColorLine);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_WIDTH, 1);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_BACK, false);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_READONLY, true);
                 ObjectSet(Name+"-"+string(j)+"-Down", OBJPROP_SELECTABLE, false);
                 
                 
      }
   else if(ObjectFind(0,"SSH")!=0)
      {
      Alert("First draw a 'RECTANGLE' with the name of 'SSH'.");
      }
                
  }
//+------------------------------------------------------------------+
