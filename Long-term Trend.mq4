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

int i = 0;
string Trends[2] = { "Buy", "Sell"};
color Colors[2] = { clrBlue, clrRed };
string TimeFrames[6] = { "H1", "H4", "D1", "W1", "MN", "General" };
int xDist[5] = { 70, 150, 230, 310, 390};

enum TrendTime
      {
      H1=0,
      H4=1,
      D1=2,
      W1=3,
      MN=4,
      General=5,
      };

enum TrendList
      {
      Buy=0,
      Sell=1, 
      };

enum RemoveFlag
      {
      NO=0,
      YES=1,
      };

input TrendList Trend; // Long-term Trend      
input TrendTime TimeFrame = General; // Long-term TimeFrame
input RemoveFlag Remove; // Remove Script?
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  { 
   while( ObjectFind(0,"TrendsLBL"+i) == 0 )
      {
      i++;
      }
   if( i == 0)
      {
      ObjectCreate(0,"Trends", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("Trends","Trend:",11, "Calibri Bold", clrBlack); 
        ObjectSetInteger(0,"Trends",OBJPROP_XDISTANCE,10);
        ObjectSetInteger(0,"Trends",OBJPROP_YDISTANCE,20);
        ObjectSet("Trends",OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSet("Trends", OBJPROP_FONTSIZE, 8);
        ObjectSet("Trends", OBJPROP_BACK, False);
        ObjectSet("Trends", OBJPROP_READONLY, true);
        ObjectSet("Trends", OBJPROP_SELECTABLE, false);
        ObjectSet("Trends", OBJPROP_HIDDEN, true);
      }
   ObjectCreate(0,"TrendsLBL"+i, OBJ_LABEL ,0, 0, 8);
        ObjectSetText("TrendsLBL"+i,Trends[Trend]+" in "+TimeFrames[TimeFrame],11, "Calibri Bold", Colors[Trend]); 
        ObjectSetInteger(0,"TrendsLBL"+i,OBJPROP_XDISTANCE,xDist[i]);
        ObjectSetInteger(0,"TrendsLBL"+i,OBJPROP_YDISTANCE,20);
        ObjectSet("TrendsLBL"+i,OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSet("TrendsLBL"+i, OBJPROP_FONTSIZE, 8);
        ObjectSet("TrendsLBL"+i, OBJPROP_BACK, False);
        ObjectSet("TrendsLBL"+i, OBJPROP_READONLY, true);
        ObjectSet("TrendsLBL"+i, OBJPROP_SELECTABLE, false);
        ObjectSet("TrendsLBL"+i, OBJPROP_HIDDEN, true);
   
   if(Remove == 1)
      {
      ObjectDelete("Trends");
      for( i = 0; i <= 5; i++)
         {
         ObjectDelete("TrendsLBL"+i);
         }
      }     
     
  }
//+------------------------------------------------------------------+
