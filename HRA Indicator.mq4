//+------------------------------------------------------------------+
//|                                                HRA Indicator.mq4 |
//|                                      Copyright 2021, HRAhadiyan. |
//|                                            ahadiyan.hr@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, HRAhadiyan."
#property link      "ahadiyan.hr@gmail.com"
#property version   "2.00"
#property strict
#property indicator_chart_window
#property show_inputs

input double RiskPercent = 2; // Risk, %
input int OutCap = 0; // Additional Capital, $
input string SLObj = "STOP"; // StopLoss Line 

double TicksVal;

int i = 0; // Numerator
int j = 0; // Numerator
int TicksValFlag = 0;
int DrawCloseFlag = 0;

double multiplier;
double lots;
double TR[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
double SD[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int Periods[9] = { 1, 5, 15, 30, 60, 240, 1440, 10080, 43200 };
const string Timeframes[9] = { "M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN" };
int L1[9] = { 10, 80, 150, 220, 300, 370, 440, 510, 600 };

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- Texts:
  ObjectCreate("Roles1", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles1","1. Strong SD which caused CHOCH", 9, "Calibri", clrMidnightBlue); 
     ObjectSet("Roles1",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Roles1",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Roles1",OBJPROP_YDISTANCE,85);
     ObjectSet("Roles1", OBJPROP_BACK, true);
     ObjectSet("Roles1", OBJPROP_READONLY, true);
     ObjectSet("Roles1", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles1", OBJPROP_HIDDEN, true);
   ObjectCreate("Roles2", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles2","(Hidden | PQ | DailyClose | LongBar)", 9, "Calibri", clrMidnightBlue); 
     ObjectSet("Roles2",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Roles2",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Roles2",OBJPROP_YDISTANCE,70);
     ObjectSet("Roles2", OBJPROP_BACK, true);
     ObjectSet("Roles2", OBJPROP_READONLY, true);
     ObjectSet("Roles2", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles2", OBJPROP_HIDDEN, true);
   ObjectCreate("Roles3", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles3","2. Having a LQ in front", 9, "Calibri", clrMidnightBlue); 
     ObjectSet("Roles3",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Roles3",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Roles3",OBJPROP_YDISTANCE,55);
     ObjectSet("Roles3", OBJPROP_BACK, true);
     ObjectSet("Roles3", OBJPROP_READONLY, true);
     ObjectSet("Roles3", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles3", OBJPROP_HIDDEN, true);
   ObjectCreate("Roles4", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles4","3. Making CP with RSI>70", 9, "Calibri", clrMidnightBlue); 
     ObjectSet("Roles4",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Roles4",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Roles4",OBJPROP_YDISTANCE,40);
     ObjectSet("Roles4", OBJPROP_BACK, true);
     ObjectSet("Roles4", OBJPROP_READONLY, true);
     ObjectSet("Roles4", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles4", OBJPROP_HIDDEN, true);
   ObjectCreate("Roles5", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles5","4. Happening FO the LQ in back with RSI<70", 9, "Calibri", clrMidnightBlue); 
     ObjectSet("Roles5",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Roles5",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Roles5",OBJPROP_YDISTANCE,25);
     ObjectSet("Roles5", OBJPROP_BACK, true);
     ObjectSet("Roles5", OBJPROP_READONLY, true);
     ObjectSet("Roles5", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles5", OBJPROP_HIDDEN, true);
   ObjectCreate("Roles6", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles6","5. Enter at final secs in >M15", 9, "Calibri", clrMidnightBlue); 
     ObjectSet("Roles6",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
     ObjectSetInteger(0,"Roles6",OBJPROP_XDISTANCE,5);
     ObjectSetInteger(0,"Roles6",OBJPROP_YDISTANCE,10);
     ObjectSet("Roles6", OBJPROP_BACK, true);
     ObjectSet("Roles6", OBJPROP_READONLY, true);
     ObjectSet("Roles6", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles6", OBJPROP_HIDDEN, true);
       
//--- Balance Indicator:     
   ObjectCreate(0,"Balance", OBJ_LABEL ,0, 0, 10); 
        ObjectSet("Balance",OBJPROP_CORNER,CORNER_LEFT_UPPER);
        ObjectSetInteger(0,"Balance",OBJPROP_XDISTANCE,140);
        ObjectSetInteger(0,"Balance",OBJPROP_YDISTANCE,2);
        ObjectSet("Balance", OBJPROP_BACK, False);
        ObjectSet("Balance", OBJPROP_READONLY, true);
        ObjectSet("Balance", OBJPROP_SELECTABLE, false);
        ObjectSet("Balance", OBJPROP_HIDDEN, true);    

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
         ObjectSet("Risk",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"Risk",OBJPROP_XDISTANCE,250);
         ObjectSetInteger(0,"Risk",OBJPROP_YDISTANCE,2);
         ObjectSet("Risk", OBJPROP_BACK, False);
         ObjectSet("Risk", OBJPROP_READONLY, true);
         ObjectSet("Risk", OBJPROP_SELECTABLE, false);
         ObjectSet("Risk", OBJPROP_HIDDEN, true);

//--- Steps LotSize Calculation:      
      ObjectCreate("LotSize", OBJ_LABEL ,0, 0, 10);
         ObjectSet("LotSize",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"LotSize",OBJPROP_XDISTANCE,340);
         ObjectSetInteger(0,"LotSize",OBJPROP_YDISTANCE,2);
         ObjectSet("LotSize", OBJPROP_BACK, False);
         ObjectSet("LotSize", OBJPROP_READONLY, true);
         ObjectSet("LotSize", OBJPROP_SELECTABLE, false);
         ObjectSet("LotSize", OBJPROP_HIDDEN, true);
      
    for (int x=1;x<=5; x++)
      {
      ObjectDelete("close "+x);
      }
    
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
      ObjectCreate("TR "+Timeframes[i],OBJ_LABEL ,0, 0, 10);
         ObjectSet("TR "+Timeframes[i],OBJPROP_CORNER,CORNER_LEFT_LOWER);
         ObjectSetInteger(0,"TR "+Timeframes[i],OBJPROP_XDISTANCE,L1[i]);
         ObjectSetInteger(0,"TR "+Timeframes[i],OBJPROP_YDISTANCE,5);
         ObjectSet("TR "+Timeframes[i], OBJPROP_BACK, False);
         ObjectSet("TR "+Timeframes[i], OBJPROP_READONLY, true);
         ObjectSet("TR "+Timeframes[i], OBJPROP_SELECTABLE, false);
         ObjectSet("TR "+Timeframes[i], OBJPROP_HIDDEN, true);
         TR[i] = MathRound(iATR(0, Periods[i], 63, 0)*multiplier);
         SD[i] = MathRound(iStdDev(0,Periods[i],14,0,MODE_EMA,PRICE_CLOSE,0)*multiplier);
         ObjectSetText("TR "+Timeframes[i],Timeframes[i]+": "+string(TR[i])+" ("+string(SD[i])+")",8, "Calibri Bold", clrGray);
      }
      
//---
   return(INIT_SUCCEEDED);
  }


//---  
void OnDeinit(const int reason)
  {
   ObjectDelete("Roles1");
   ObjectDelete("Roles2");
   ObjectDelete("Roles3");
   ObjectDelete("Roles4");
   ObjectDelete("Roles5");
   ObjectDelete("Roles6");
   ObjectDelete("Balance");
   ObjectDelete("Spread");
   ObjectDelete("SpreadValue");
   ObjectDelete("Time_Remaining");
   ObjectDelete("Risk");
   ObjectDelete("LotSize");
   for (int x=1;x<=5; x++)
      {
      ObjectDelete("close "+x);
      }
   ;
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
      if((Symbol() == "ETHUSD") || (Symbol() == "BTCUSD"))
         {
         TicksVal = TicksVal*100;
         }
      ObjectSetText("LotSize","minLOT: "+IntegerToString((((RiskPercent/100)*(OutCap+AccountBalance()))/(TicksVal*0.01)))+" pips",8, "Calibri Bold", clrDarkBlue);
      
      TicksValFlag = 1;
      }

//--- Draw Close of Perior Days:
      
      double Yesterday = TimeToStr(iTime(Symbol(),PERIOD_H1,1),TIME_DATE);
      double Today = TimeToStr(iTime(Symbol(),PERIOD_H1,0),TIME_DATE);
      if((Yesterday < Today) || (DrawCloseFlag == 0))
        {
        for (int x=1;x<=5; x++)
            {
            ObjectDelete("close "+x);
            datetime date1 = iTime(0, PERIOD_D1, x-1);
            double close = iClose(0, PERIOD_D1, x);
            ObjectCreate("close "+x, OBJ_TREND, 0, date1, close, TimeCurrent(), close);
            ObjectSet("close "+x, OBJPROP_BACK, False);
            ObjectSet("close "+x, OBJPROP_READONLY, true);
            ObjectSet("close "+x, OBJPROP_SELECTABLE, false);
            ObjectSetText("close "+x, DoubleToStr(close), 0, NULL, clrRed);
            ObjectSet("close "+x, OBJPROP_COLOR, clrBlueViolet);
            ObjectSet("close "+x, OBJPROP_STYLE, x-1);
            }
        DrawCloseFlag = 1;
        }
     
     
//--- AccountBalance Indicator:
   ObjectSetText("Balance","BALANCE: "+DoubleToString(AccountBalance()+OutCap,2),8, "Calibri Bold", clrDarkBlue);
   
//--- Risk Indicator:   
   ObjectSetText("Risk","RISK: "+DoubleToString((RiskPercent/100)*(OutCap+AccountBalance()),2)+" $",8, "Calibri Bold", clrDarkBlue);

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
   return(rates_total);
  }
//+------------------------------------------------------------------+