//+------------------------------------------------------------------+
//|                                          SSH Long-term Trend.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

string Trends[2] = { "Buy", "Sell"};
color Colors[2] = { clrBlue, clrRed };
string TimeFrames[5] = { "H1", "H4", "D1", "W1", "MN" };
enum TrendTime
      {
      H1=0,
      H4=2,
      D1=3,
      W1=4,
      MN=5,
      };
input TrendTime TimeFrame; // Long-term TimeFrame
enum TrendList
      {
      Buy=0,
      Sell=1  
      };
input TrendList Trend; // Long-term Trend
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
   ObjectCreate(0,"Trends", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("Trends","Long-term Trend: ",11, "Calibri Bold", clrBlack); 
        ObjectSetInteger(0,"Trends",OBJPROP_XDISTANCE,300);
        ObjectSetInteger(0,"Trends",OBJPROP_YDISTANCE,0);
        ObjectSet("Trends", OBJPROP_FONTSIZE, 10);
        ObjectSet("Trends", OBJPROP_BACK, False);
        ObjectSet("Trends", OBJPROP_READONLY, true);
        ObjectSet("Trends", OBJPROP_SELECTABLE, false);
        ObjectSet("Trends", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"BS", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("BS",Trends[Trend],11, "Calibri Bold", Colors[Trend]);
        ObjectSetInteger(0,"BS",OBJPROP_XDISTANCE,400);
        ObjectSetInteger(0,"BS",OBJPROP_YDISTANCE,0);
        ObjectSet("BS", OBJPROP_FONTSIZE, 10);
        ObjectSet("BS", OBJPROP_BACK, False);
        ObjectSet("BS", OBJPROP_READONLY, true);
        ObjectSet("BS", OBJPROP_SELECTABLE, false);
        ObjectSet("BS", OBJPROP_HIDDEN, true);
    ObjectCreate(0,"BS", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("BS","in "+TimeFrames[TimeFrame],11, "Calibri Bold", clrBlack);
        ObjectSetInteger(0,"BS",OBJPROP_XDISTANCE,500);
        ObjectSetInteger(0,"BS",OBJPROP_YDISTANCE,0);
        ObjectSet("BS", OBJPROP_FONTSIZE, 10);
        ObjectSet("BS", OBJPROP_BACK, False);
        ObjectSet("BS", OBJPROP_READONLY, true);
        ObjectSet("BS", OBJPROP_SELECTABLE, false);
        ObjectSet("BS", OBJPROP_HIDDEN, true);
  }
//+------------------------------------------------------------------+
