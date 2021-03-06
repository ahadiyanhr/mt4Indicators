//+------------------------------------------------------------------+
//|                                                 My Indicator.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "2.00"
#property strict
#property indicator_chart_window

int i = 0; // Numerator
double multiplier;
double TR[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
double Live[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int Periods[8] = { 1, 5, 15, 60, 240, 1440, 10080, 43200 };
const string Timeframes[9] = { "M1", "M5", "M15", "H1", "H4", "D1", "W1", "MN", "MN6" };
int L1[9] = { 100, 180, 260, 350, 440, 530, 630, 730, 830 };

double maxLots;
double lotStep;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
  
//--- Trademark Text:
   ObjectCreate("Trademark", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Trademark","Sina Shaabaz",20, "Impact", clrLightGray); 
     ObjectSet("Trademark",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Trademark",OBJPROP_XDISTANCE,10);
     ObjectSetInteger(0,"Trademark",OBJPROP_YDISTANCE,0);
     ObjectSet("Trademark", OBJPROP_BACK, true);
     ObjectSet("Trademark", OBJPROP_READONLY, true);
     ObjectSet("Trademark", OBJPROP_SELECTABLE, false);
     ObjectSet("Trademark", OBJPROP_HIDDEN, true);

//--- LotSize Indicator:
   lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);     
   ObjectCreate(0,"Lots", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("Lots","FreeLots: ",11, "Calibri Bold", clrBlack); 
        ObjectSetInteger(0,"Lots",OBJPROP_XDISTANCE,102);
        ObjectSetInteger(0,"Lots",OBJPROP_YDISTANCE,0);
        ObjectSet("Lots", OBJPROP_FONTSIZE, 10);
        ObjectSet("Lots", OBJPROP_BACK, False);
        ObjectSet("Lots", OBJPROP_READONLY, true);
        ObjectSet("Lots", OBJPROP_SELECTABLE, false);
        ObjectSet("Lots", OBJPROP_HIDDEN, true);    
   ObjectCreate(0,"MaxLots", OBJ_LABEL ,0, 0, 10);
        ObjectSetInteger(0,"MaxLots",OBJPROP_XDISTANCE,157);
        ObjectSetInteger(0,"MaxLots",OBJPROP_YDISTANCE,0);
        ObjectSet("MaxLots", OBJPROP_FONTSIZE, 10);
        ObjectSet("MaxLots", OBJPROP_BACK, False);
        ObjectSet("MaxLots", OBJPROP_READONLY, true);
        ObjectSet("MaxLots", OBJPROP_SELECTABLE, false);
        ObjectSet("MaxLots", OBJPROP_HIDDEN, true);

//--- Spread Indicator:        
   ObjectCreate("Spread", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Spread","Spread ",8, "Calibri Bold", clrMaroon); 
     ObjectSet("Spread",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Spread",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Spread",OBJPROP_YDISTANCE,36);
     ObjectSet("Spread", OBJPROP_BACK, False);
     ObjectSet("Spread", OBJPROP_READONLY, true);
     ObjectSet("Spread", OBJPROP_SELECTABLE, false);
     ObjectSet("Spread", OBJPROP_HIDDEN, true);
   ObjectCreate("SpreadValue", OBJ_LABEL ,0, 0, 10);
     ObjectSet("SpreadValue",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"SpreadValue",OBJPROP_XDISTANCE,7);
     ObjectSetInteger(0,"SpreadValue",OBJPROP_YDISTANCE,15);
     ObjectSet("SpreadValue", OBJPROP_BACK, False);
     ObjectSet("SpreadValue", OBJPROP_READONLY, true);
     ObjectSet("SpreadValue", OBJPROP_SELECTABLE, false);
     ObjectSet("SpreadValue", OBJPROP_HIDDEN, true);

//--- Time_Remaining Indicator:     
   ObjectCreate("Time_Remaining",OBJ_LABEL,0,0,10);
      ObjectSet("Time_Remaining",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSet("Time_Remaining",OBJPROP_XDISTANCE,4);
      ObjectSet("Time_Remaining",OBJPROP_YDISTANCE,0);
      ObjectSet("Time_Remaining",OBJPROP_BACK,False);
      ObjectSet("Time_Remaining", OBJPROP_READONLY, true);
      ObjectSet("Time_Remaining", OBJPROP_SELECTABLE, false);
      ObjectSet("Time_Remaining", OBJPROP_HIDDEN, true);

//--- TH-TR-Live True Range Indicator:
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
      
      ObjectCreate("ATR - Live", OBJ_LABEL ,0, 0, 10);
      ObjectSetText("ATR - Live", "ATR - Live", 10, "Calibri Bold", clrBlack);
      ObjectSet("ATR - Live", OBJPROP_CORNER, CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"ATR - Live", OBJPROP_XDISTANCE, 15);
      ObjectSetInteger(0,"ATR - Live", OBJPROP_YDISTANCE, 5);
      ObjectSet("ATR - Live", OBJPROP_BACK, False);
      ObjectSet("ATR - Live", OBJPROP_READONLY, true);
      ObjectSet("ATR - Live", OBJPROP_SELECTABLE, false);
      ObjectSet("ATR - Live", OBJPROP_HIDDEN, true);      
   
   for (i=0; i<=8; i++)
      {
      ObjectCreate("TR "+Timeframes[i], OBJ_LABEL ,0, 0, 10);
         ObjectSet("TR "+Timeframes[i],OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,"TR "+Timeframes[i],OBJPROP_XDISTANCE,L1[i]);
         ObjectSetInteger(0,"TR "+Timeframes[i],OBJPROP_YDISTANCE,5);
         ObjectSet("TR "+Timeframes[i], OBJPROP_BACK, False);
         ObjectSet("TR "+Timeframes[i], OBJPROP_READONLY, true);
         ObjectSet("TR "+Timeframes[i], OBJPROP_SELECTABLE, false);
         ObjectSet("TR "+Timeframes[i], OBJPROP_HIDDEN, true);
      }
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
           
//--- LotSize Indicator:
   maxLots = AccountFreeMargin() / MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   maxLots = floor(((maxLots / lotStep) * lotStep) * 100) / 100;
   maxLots = NormalizeDouble(maxLots, 2);
   ObjectSetText("MaxLots",DoubleToString(maxLots,2),10, "Calibri Bold", clrBlack);

//--- Spread Indicator:
   ObjectSetText("SpreadValue",DoubleToString(MarketInfo(0,MODE_SPREAD)/10,1),17, "Calibri Bold", clrMaroon);
                 
//--- Time_Remaining Indicator:
   int thisbarminutes=Period();
   double thisbarseconds=thisbarminutes*60;
   double seconds=thisbarseconds -(TimeCurrent()-Time[0]); // seconds left in bar 

   double minutes = MathFloor(seconds/60);
   double hours = MathFloor(seconds/3600);
   double days = MathFloor(seconds/86400);

   hours = hours - days*24;
   minutes = minutes-  hours*60 - days*24*60;
   seconds = seconds - minutes*60 - hours*3600 - days*24*3600;

   string sText=DoubleToStr(seconds,0);
   if(StringLen(sText)<2) sText="0"+sText;
   string mText=DoubleToStr(minutes,0);
   if(StringLen(mText)<2) mText="0"+mText;
   string hText=DoubleToStr(hours,0);
   if(StringLen(hText)<2) hText="0"+hText;
   string dText=DoubleToStr(days,0);

   if(Period()<5) ObjectSetText("Time_Remaining","Close in "+sText+" sec",11,"Calibri Bold",clrMidnightBlue);
   else if(Period()<240) ObjectSetText("Time_Remaining","Close in "+mText+":"+sText,11,"Calibri Bold",clrMidnightBlue);
   else if (Period()<10080) ObjectSetText("Time_Remaining","Close in "+hText+":"+mText+":"+sText,11,"Calibri Bold",clrMidnightBlue);
   else ObjectSetText("Time_Remaining","Close in "+dText+"d "+hText+":"+mText+":"+sText,11,"Calibri Bold",clrMidnightBlue);

   
//--- TH-TR-Live True Range Indicator:
   for (i=0; i<=7; i++)
      {
      TR[i] = MathRound(iATR(0, Periods[i], 63, 0)*multiplier);
      Live[i] = MathRound(iATR(0, Periods[i], 3, 0)*multiplier);
      ObjectSetText("TR "+Timeframes[i],Timeframes[i]+": "+string(TR[i])+" - "+string(Live[i]),10, "Calibri Bold", clrBlack);
      }
      ObjectSetText("TR "+Timeframes[8],Timeframes[8]+" ~ "+string(TR[7]*2)+" - "+string(Live[7]*2),10, "Calibri Bold", clrBlack);
          
//--- return value of prev_calculated for next call
   return(0);
  }
//+------------------------------------------------------------------+
