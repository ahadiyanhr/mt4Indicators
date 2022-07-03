//+------------------------------------------------------------------+
//|                                     PolySign Long-term Trend.mq4 |
//|                          Copyright 2020, SinaShaabaz (PolySign). |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz (PolySign)."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

string trend;
color colors;
enum BSList
      {
      Buy=0,
      Sell=1,
      Neutral=2,
      Nothing=3   
      };
input BSList BS; // Long-term Trend
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {

   if(BS == 0)
      {
      trend = "Buy";
      colors = clrBlue;
      }
   else if(BS == 1)
      {
      trend = "Sell";
      colors = clrRed;
      }
   else if(BS == 2)
      {
      trend = "Neutral";
      colors = clrDimGray;
      }   
   ObjectCreate(0,"Trends", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("Trends","Long-term Trend: ",11, "Calibri Bold", clrBlack); 
        ObjectSetInteger(0,"Trends",OBJPROP_XDISTANCE,220);
        ObjectSetInteger(0,"Trends",OBJPROP_YDISTANCE,0);
        ObjectSet("Trends", OBJPROP_FONTSIZE, 10);
        ObjectSet("Trends", OBJPROP_BACK, False);
        ObjectSet("Trends", OBJPROP_READONLY, true);
        ObjectSet("Trends", OBJPROP_SELECTABLE, false);
        ObjectSet("Trends", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"BS", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("BS",trend,11, "Calibri Bold", colors);
        ObjectSetInteger(0,"BS",OBJPROP_XDISTANCE,320);
        ObjectSetInteger(0,"BS",OBJPROP_YDISTANCE,0);
        ObjectSet("BS", OBJPROP_FONTSIZE, 10);
        ObjectSet("BS", OBJPROP_BACK, False);
        ObjectSet("BS", OBJPROP_READONLY, true);
        ObjectSet("BS", OBJPROP_SELECTABLE, false);
        ObjectSet("BS", OBJPROP_HIDDEN, true);
    if(BS == 3)
      {
      ObjectDelete("Trends");
      ObjectDelete("BS");
      }
  }
//+------------------------------------------------------------------+
