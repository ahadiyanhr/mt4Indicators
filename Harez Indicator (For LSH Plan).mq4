//+------------------------------------------------------------------+
//|                                              Harez Indicator.mq4 |
//|                                        Copyright 2020, Harezian. |
//|                                            ahadiyan.hr@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Harezian."
#property link      "ahadiyan.hr@gmail.com"
#property version   "2.00"
#property strict
#property indicator_chart_window
#property show_inputs

input double RiskPercent = 0.85; // Risk in %

double maxLots;
double lotStep;
double TicksVal;
string Dscrp;

int i = 0; // Numerator
int j = 0; // Numerator
int TicksValFlag = 0;

double multiplier;
double TR[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int Periods[9] = { 1, 5, 15, 30, 60, 240, 1440, 10080, 43200 };
const string Timeframes[9] = { "M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN" };
int L1[9] = { 10, 80, 150, 220, 300, 370, 440, 510, 580 };

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- Trademark Text:
   ObjectCreate("Trademark", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Trademark","Harezian",20, "Impact", C'181,203,180'); 
     ObjectSet("Trademark",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Trademark",OBJPROP_XDISTANCE,10);
     ObjectSetInteger(0,"Trademark",OBJPROP_YDISTANCE,25);
     ObjectSet("Trademark", OBJPROP_BACK, true);
     ObjectSet("Trademark", OBJPROP_READONLY, true);
     ObjectSet("Trademark", OBJPROP_SELECTABLE, false);
     ObjectSet("Trademark", OBJPROP_HIDDEN, true);

//--- Trade Rules:
   ObjectCreate("Traderules1", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules1","Near Marker/SD in TimFrm .1",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules1",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules1",OBJPROP_YDISTANCE,50);
     ObjectSet("Traderules1", OBJPROP_BACK, false);
     ObjectSet("Traderules1", OBJPROP_READONLY, true);
     ObjectSet("Traderules1", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules1", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules11", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules11","NO Oppst Spikes! Only CP/Side .2",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules11",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules11",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules11",OBJPROP_YDISTANCE,63);
     ObjectSet("Traderules11", OBJPROP_BACK, false);
     ObjectSet("Traderules11", OBJPROP_READONLY, true);
     ObjectSet("Traderules11", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules11", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules2", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules2","Virgin FTR in lower TimFrm .3",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules2",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules2",OBJPROP_YDISTANCE,76);
     ObjectSet("Traderules2", OBJPROP_BACK, false);
     ObjectSet("Traderules2", OBJPROP_READONLY, true);
     ObjectSet("Traderules2", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules2", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules22", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules22","Trnd Fllw Hgh TimFrm .4",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules22",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules22",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules22",OBJPROP_YDISTANCE,89);
     ObjectSet("Traderules22", OBJPROP_BACK, false);
     ObjectSet("Traderules22", OBJPROP_READONLY, true);
     ObjectSet("Traderules22", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules22", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules3", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules3","Break SR @ M15/M30 .5",9, "Calibri Bold", clrRoyalBlue); 
     ObjectSet("Traderules3",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules3",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules3",OBJPROP_YDISTANCE,102);
     ObjectSet("Traderules3", OBJPROP_BACK, false);
     ObjectSet("Traderules3", OBJPROP_READONLY, true);
     ObjectSet("Traderules3", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules3", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules33", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules33","NO Same Cross .6",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules33",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules33",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules33",OBJPROP_YDISTANCE,115);
     ObjectSet("Traderules33", OBJPROP_BACK, false);
     ObjectSet("Traderules33", OBJPROP_READONLY, true);
     ObjectSet("Traderules33", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules33", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules4", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules4","NO after 8:30 .7",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules4",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules4",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules4",OBJPROP_YDISTANCE,128);
     ObjectSet("Traderules4", OBJPROP_BACK, false);
     ObjectSet("Traderules4", OBJPROP_READONLY, true);
     ObjectSet("Traderules4", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules4", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules44", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules44","Clsic SL for M15/M30 .8",9, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Traderules44",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules44",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules44",OBJPROP_YDISTANCE,141);
     ObjectSet("Traderules44", OBJPROP_BACK, false);
     ObjectSet("Traderules44", OBJPROP_READONLY, true);
     ObjectSet("Traderules44", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules44", OBJPROP_HIDDEN, true);
   ObjectCreate("Traderules5", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Traderules5","Quickly Free Risk .9",9, "Calibri Bold", clrFireBrick); 
     ObjectSet("Traderules5",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Traderules5",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Traderules5",OBJPROP_YDISTANCE,154);
     ObjectSet("Traderules5", OBJPROP_BACK, false);
     ObjectSet("Traderules5", OBJPROP_READONLY, true);
     ObjectSet("Traderules5", OBJPROP_SELECTABLE, false);
     ObjectSet("Traderules5", OBJPROP_HIDDEN, true);
  
//--- Slogan Text:
   ObjectCreate("Slogan1", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Slogan1","Focus on Future with Consistency, Discipline, and Patience",11, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Slogan1",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Slogan1",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Slogan1",OBJPROP_YDISTANCE,0);
     ObjectSet("Slogan1", OBJPROP_BACK, false);
     ObjectSet("Slogan1", OBJPROP_READONLY, true);
     ObjectSet("Slogan1", OBJPROP_SELECTABLE, false);
     ObjectSet("Slogan1", OBJPROP_HIDDEN, true);
   ObjectCreate("Slogan2", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Slogan2","Control the inherent Fear, Greed, and Ego",11, "Calibri Bold", clrDarkBlue); 
     ObjectSet("Slogan2",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Slogan2",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Slogan2",OBJPROP_YDISTANCE,12);
     ObjectSet("Slogan2", OBJPROP_BACK, false);
     ObjectSet("Slogan2", OBJPROP_READONLY, true);
     ObjectSet("Slogan2", OBJPROP_SELECTABLE, false);
     ObjectSet("Slogan2", OBJPROP_HIDDEN, true);
    
//--- LotSize Indicator:     
   ObjectCreate(0,"Lots", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("Lots","freeLOTS: ",7, "Arial", clrDarkBlue); 
        ObjectSetInteger(0,"Lots",OBJPROP_XDISTANCE,140);
        ObjectSetInteger(0,"Lots",OBJPROP_YDISTANCE,2);
        ObjectSet("Lots", OBJPROP_BACK, False);
        ObjectSet("Lots", OBJPROP_READONLY, true);
        ObjectSet("Lots", OBJPROP_SELECTABLE, false);
        ObjectSet("Lots", OBJPROP_HIDDEN, true);    
   ObjectCreate(0,"MaxLots", OBJ_LABEL ,0, 0, 10);
        ObjectSetInteger(0,"MaxLots",OBJPROP_XDISTANCE,188);
        ObjectSetInteger(0,"MaxLots",OBJPROP_YDISTANCE,2);
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

//--- Risk Calculation:      
      ObjectCreate("Risk", OBJ_LABEL ,0, 0, 10);
         ObjectSetText("Risk","RISK: ",7, "Arial", clrDarkBlue);
         ObjectSet("Risk",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"Risk",OBJPROP_XDISTANCE,250);
         ObjectSetInteger(0,"Risk",OBJPROP_YDISTANCE,2);
         ObjectSet("Risk", OBJPROP_BACK, False);
         ObjectSet("Risk", OBJPROP_READONLY, true);
         ObjectSet("Risk", OBJPROP_SELECTABLE, false);
         ObjectSet("Risk", OBJPROP_HIDDEN, true);
      ObjectCreate("RiskVal", OBJ_LABEL ,0, 0, 10);
         ObjectSetText("RiskVal",DoubleToString((RiskPercent/100) * AccountBalance(),2)+" $",7, "Arial", clrDarkBlue);
         ObjectSet("RiskVal",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"RiskVal",OBJPROP_XDISTANCE,280);
         ObjectSetInteger(0,"RiskVal",OBJPROP_YDISTANCE,2);
         ObjectSet("RiskVal", OBJPROP_BACK, False);
         ObjectSet("RiskVal", OBJPROP_READONLY, true);
         ObjectSet("RiskVal", OBJPROP_SELECTABLE, false);
         ObjectSet("RiskVal", OBJPROP_HIDDEN, true);

//--- Steps LotSize Calculation:      
      ObjectCreate("Lots1", OBJ_LABEL ,0, 0, 10);
         ObjectSetText("Lots1","minLOT: ",7, "Arial", clrDarkBlue);
         ObjectSet("Lots1",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"Lots1",OBJPROP_XDISTANCE,340);
         ObjectSetInteger(0,"Lots1",OBJPROP_YDISTANCE,2);
         ObjectSet("Lots1", OBJPROP_BACK, False);
         ObjectSet("Lots1", OBJPROP_READONLY, true);
         ObjectSet("Lots1", OBJPROP_SELECTABLE, false);
         ObjectSet("Lots1", OBJPROP_HIDDEN, true);
      ObjectCreate("Lots1Val", OBJ_LABEL ,0, 0, 10);
         ObjectSet("Lots1Val",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"Lots1Val",OBJPROP_XDISTANCE,380);
         ObjectSetInteger(0,"Lots1Val",OBJPROP_YDISTANCE,2);
         ObjectSet("Lots1Val", OBJPROP_BACK, False);
         ObjectSet("Lots1Val", OBJPROP_READONLY, true);
         ObjectSet("Lots1Val", OBJPROP_SELECTABLE, false);
         ObjectSet("Lots1Val", OBJPROP_HIDDEN, true);        
         
      
//--- ATR Indicator:
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
   
   for (i = 0; i <= 8; i++)
      {
      ObjectCreate("TR "+Timeframes[i], OBJ_LABEL ,0, 0, 10);
         ObjectSet("TR "+Timeframes[i],OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,"TR "+Timeframes[i],OBJPROP_XDISTANCE,L1[i]);
         ObjectSetInteger(0,"TR "+Timeframes[i],OBJPROP_YDISTANCE,2);
         ObjectSet("TR "+Timeframes[i], OBJPROP_BACK, False);
         ObjectSet("TR "+Timeframes[i], OBJPROP_READONLY, true);
         ObjectSet("TR "+Timeframes[i], OBJPROP_SELECTABLE, false);
         ObjectSet("TR "+Timeframes[i], OBJPROP_HIDDEN, true);
         TR[i] = MathRound(iATR(0, Periods[i], 63, 0)*multiplier);
         ObjectSetText("TR "+Timeframes[i],Timeframes[i]+": "+string(TR[i]),10, "Calibri Bold", clrDarkBlue);
      }
      
//---
   return(INIT_SUCCEEDED);
  }


//---  
void OnDeinit(const int reason)
  {
   ObjectDelete("Trademark");
   ObjectDelete("Slogan1");
   ObjectDelete("Slogan2");
   ObjectDelete(0,"TradeTime");
   ObjectDelete(0,"Lots");
   ObjectDelete(0,"MaxLots");
   ObjectDelete(0,"Ticks");
   ObjectDelete(0,"TicksVal");
   ObjectDelete("Spread");
   ObjectDelete("SpreadValue");
   ObjectDelete("Time_Remaining");
   ObjectDelete("Lots1");
   ObjectDelete("Lots1Val");
   ObjectDelete("Risk");
   ObjectDelete("RiskVal");
   for (i = 0; i <= 8; i++)
      {
      ObjectDelete("TR "+Timeframes[i]);
      }
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

//--- Steps LotSize Calculation:          
   if((MarketInfo(Symbol(),MODE_TICKVALUE) == 0) && (TicksValFlag == 0))
      {
      TicksVal = 0;
      }
   else if((MarketInfo(Symbol(),MODE_TICKVALUE) != 0) && (TicksValFlag == 0))
      {
      TicksVal = MarketInfo(Symbol(),MODE_TICKVALUE);
      if((Symbol() == "BRENT") || (Symbol() == "WTI"))
         {
         TicksVal = TicksVal*10;
         }
      ObjectSetText("Lots1Val",IntegerToString((((RiskPercent/100) * AccountBalance())/(TicksVal*0.01)))+" pips",7, "Arial", clrDarkBlue);
      TicksValFlag = 1;
      }

//--- LotSize Indicator:
   lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   if(MarketInfo(Symbol(), MODE_LOTSTEP) == 0)
      {
      lotStep = 1;
      }
   if(MarketInfo(Symbol(), MODE_MARGINREQUIRED) == 0)
      {
      maxLots = 1;
      }
   else if(MarketInfo(Symbol(), MODE_MARGINREQUIRED) != 0)
      {
      maxLots = AccountFreeMargin() / MarketInfo(Symbol(),MODE_MARGINREQUIRED);
      }
   maxLots = floor(((maxLots / lotStep) * lotStep) * 100) / 100;
   maxLots = NormalizeDouble(maxLots, 2);
   ObjectSetText("MaxLots",DoubleToString(maxLots,2),7, "Arial", clrDarkBlue);

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
          
//--- return value of prev_calculated for next call
   return(0);
  }
//+------------------------------------------------------------------+
