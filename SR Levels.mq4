//+------------------------------------------------------------------+
//|                                                    SR Levels.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

//-- INPUTS:
input double MidPrice0; // Mid Price
input double Ranges0; // Currency Pip Range
input int LevelNO; // Number of Level
enum RemoveFlag
      {
      NO=0,
      YES=1,
      };
input RemoveFlag Remove = NO; // Remove SR Levels?

int i; // Numerator
int multiplier;
double HighPrice;
double LowPrice;
double MidPrice;
double Ranges;



//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   if(MarketInfo(0,MODE_DIGITS) == 2)
      {
      multiplier = 10;
      }
   else if(MarketInfo(0,MODE_DIGITS) == 3)
      {
      multiplier = 100;
      }
   else if(MarketInfo(0,MODE_DIGITS) == 4)
      {
      multiplier = 1000;
      }
   else if(MarketInfo(0,MODE_DIGITS) == 5)
      {
      multiplier = 10000;
      }
      
      
   Ranges = (Ranges0/multiplier);
   for( i=-LevelNO; i<=LevelNO; i++ )
      {
      MidPrice = MidPrice0+(i*Ranges);
      HighPrice = MidPrice+Ranges/8;
      LowPrice = MidPrice-Ranges/8;
      ObjectCreate(0,"Classic-SD ["+string(MidPrice)+"]", OBJ_RECTANGLE , 0, D'2010.01.01 00:00:00', HighPrice, D'2032.01.01 00:00:00', LowPrice);
                 ObjectSet("Classic-SD ["+string(MidPrice)+"]", OBJPROP_COLOR, clrLavender);
                 ObjectSet("Classic-SD ["+string(MidPrice)+"]", OBJPROP_FILL, True);
                 ObjectSet("Classic-SD ["+string(MidPrice)+"]", OBJPROP_BACK, True);
                 ObjectSet("Classic-SD ["+string(MidPrice)+"]", OBJPROP_READONLY, true);
                 ObjectSet("Classic-SD ["+string(MidPrice)+"]", OBJPROP_SELECTABLE, false);
                 ObjectSet("Classic-SD ["+string(MidPrice)+"]", OBJPROP_HIDDEN, true);
      }
        
   if(Remove == 1)
      {
      for( i=-LevelNO; i<=LevelNO; i++ )
         {
         MidPrice = MidPrice0+(i*Ranges);
         HighPrice = MidPrice+Ranges/8;
         LowPrice = MidPrice-Ranges/8;
         ObjectDelete(0,"Classic-SD ["+string(MidPrice)+"]");
         }
      }        
  }
//+------------------------------------------------------------------+
