//+------------------------------------------------------------------+
//|                                                   HRA Expert.mq4 |
//|                            Copyright 2021, ahadiyan.hr@gmail.com |
//|                                            ahadiyan.hr@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, ahadiyan.hr@gmail.com"
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

double multiplier;
double lots;
double TR[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
double SD[9] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int Periods[9] = { 1, 5, 15, 30, 60, 240, 1440, 10080, 43200 };
const string Timeframes[9] = { "M1", "M5", "M15", "M30", "H1", "H4", "D1", "W1", "MN" };
int L1[9] = { 10, 80, 150, 220, 300, 370, 440, 510, 600 };
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   //--- Texts:
  ObjectCreate("Roles1", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles1","storngSD with CHOCH S/D  >  LQ  >  CP  >  LQBAR",10, "Calibri Bold", clrMidnightBlue); 
     ObjectSet("Roles1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Roles1",OBJPROP_XDISTANCE,110);
     ObjectSetInteger(0,"Roles1",OBJPROP_YDISTANCE,0);
     ObjectSet("Roles1", OBJPROP_BACK, true);
     ObjectSet("Roles1", OBJPROP_READONLY, true);
     ObjectSet("Roles1", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles1", OBJPROP_HIDDEN, true);
   ObjectCreate("Roles2", OBJ_LABEL ,0, 0, 10);
     ObjectSetText("Roles2","Ignore first-back  >  Free-risk  >  tp on %% or SD",10, "Calibri Bold", clrMidnightBlue); 
     ObjectSet("Roles2",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"Roles2",OBJPROP_XDISTANCE,110);
     ObjectSetInteger(0,"Roles2",OBJPROP_YDISTANCE,10);
     ObjectSet("Roles2", OBJPROP_BACK, true);
     ObjectSet("Roles2", OBJPROP_READONLY, true);
     ObjectSet("Roles2", OBJPROP_SELECTABLE, false);
     ObjectSet("Roles2", OBJPROP_HIDDEN, true);
       
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
     ObjectSetInteger(0,"Spread",OBJPROP_YDISTANCE,51);
     ObjectSet("Spread", OBJPROP_BACK, False);
     ObjectSet("Spread", OBJPROP_READONLY, true);
     ObjectSet("Spread", OBJPROP_SELECTABLE, false);
     ObjectSet("Spread", OBJPROP_HIDDEN, true);
   ObjectCreate("SpreadValue", OBJ_LABEL ,0, 0, 10);
     ObjectSet("SpreadValue",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
     ObjectSetInteger(0,"SpreadValue",OBJPROP_XDISTANCE,7);
     ObjectSetInteger(0,"SpreadValue",OBJPROP_YDISTANCE,30);
     ObjectSet("SpreadValue", OBJPROP_BACK, False);
     ObjectSet("SpreadValue", OBJPROP_READONLY, true);
     ObjectSet("SpreadValue", OBJPROP_SELECTABLE, false);
     ObjectSet("SpreadValue", OBJPROP_HIDDEN, true);

//--- Time_Remaining Indicator:     
   ObjectCreate("Time_Remaining",OBJ_LABEL,0,0,10);
      ObjectSet("Time_Remaining",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSet("Time_Remaining",OBJPROP_XDISTANCE,4);
      ObjectSet("Time_Remaining",OBJPROP_YDISTANCE,15);
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
      ObjectCreate("LotsNum", OBJ_LABEL ,0, 0, 10);
         ObjectSet("LotsNum",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"LotsNum",OBJPROP_XDISTANCE,340);
         ObjectSetInteger(0,"LotsNum",OBJPROP_YDISTANCE,2);
         ObjectSet("LotsNum", OBJPROP_BACK, False);
         ObjectSet("LotsNum", OBJPROP_READONLY, true);
         ObjectSet("LotsNum", OBJPROP_SELECTABLE, false);
         ObjectSet("LotsNum", OBJPROP_HIDDEN, true);
      
      
        
      ObjectCreate(0,"StopButton",OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,"StopButton",OBJPROP_CORNER,1);
         ObjectSetInteger(0,"StopButton",OBJPROP_XDISTANCE,75);
         ObjectSetInteger(0,"StopButton",OBJPROP_XSIZE,70);
         ObjectSetInteger(0,"StopButton",OBJPROP_YDISTANCE,70);
         ObjectSetInteger(0,"StopButton",OBJPROP_YSIZE,20);
         ObjectSetInteger(0,"StopButton",OBJPROP_COLOR,clrRed);
         ObjectSetInteger(0,"StopButton",OBJPROP_BGCOLOR,clrSilver);
         ObjectSetInteger(0,"StopButton",OBJPROP_STATE,false);
         ObjectSetString(0,"StopButton",OBJPROP_TEXT, "StopLine");
         
      ObjectCreate(0,"Buy/Sell",OBJ_BUTTON,0,0,0);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_CORNER,3);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_XDISTANCE,35);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_XSIZE,30);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_YDISTANCE,30);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_YSIZE,20);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_BGCOLOR,clrSilver);
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_STATE,false);
         ObjectSetString(0,"Buy/Sell",OBJPROP_TEXT, "B/S");


         
      
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
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ObjectDelete("Roles1");
   ObjectDelete("Roles2");
   ObjectDelete("StopButton");
   ObjectDelete("Buy/Sell");
   ObjectDelete("Balance");
   ObjectDelete("Spread");
   ObjectDelete("SpreadValue");
   ObjectDelete("Time_Remaining");
   ObjectDelete("Risk");
   ObjectDelete("LotSize");
   ObjectDelete("LotsNum");
   for (i = 0; i <= 8; i++)
      {
      ObjectDelete("TR "+Timeframes[i]);
      }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
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
      TicksValFlag = 1;
      }

   if ((ObjectGet(SLObj, OBJPROP_PRICE1) > Bid) && (TicksValFlag == 1))
      {
      lots = NormalizeDouble((((((RiskPercent/100)*(OutCap+AccountBalance()))/(TicksVal)))/((ObjectGet(SLObj, OBJPROP_PRICE1) - Bid)*multiplier*10)),2);
      ObjectSetText("LotsNum", "Sell_Lot: "+lots,8, "Calibri Bold", clrMaroon);
      }
   else if ((ObjectGet(SLObj, OBJPROP_PRICE1) < Ask) && (TicksValFlag == 1))
      {
      lots = NormalizeDouble((((((RiskPercent/100)*(OutCap+AccountBalance()))/(TicksVal)))/((Ask - ObjectGet(SLObj, OBJPROP_PRICE1))*multiplier*10)),2);
      ObjectSetText("LotsNum", "Buy_Lot: "+lots,8, "Calibri Bold", clrDarkBlue);
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
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
   
   {
   if ( id == CHARTEVENT_OBJECT_CLICK)
      {   
      if (sparam == "StopButton")
         {
         ObjectCreate(0,"STOP", OBJ_HLINE ,0, 0, (Ask+Bid)/2);
         ObjectSetInteger(0,"STOP",OBJPROP_WIDTH,2);
         ObjectSetString(0,"STOP",OBJPROP_TEXT,"STOP");
         ObjectSetInteger(0,"STOP",OBJPROP_SELECTED,true);
         ObjectSetInteger(0,"StopButton",OBJPROP_STATE,false);
         }
         
      if (sparam == "Buy/Sell")
         {
         ObjectSetInteger(0,"Buy/Sell",OBJPROP_STATE,false);
         if (ObjectFind(0,"STOP") == 0)
            {
            if (Ask < ObjectGetDouble(0, "STOP", OBJPROP_PRICE, 0))
               {
               int order=OrderSend(Symbol(),OP_SELL,lots,Bid,3,ObjectGetDouble(0, "STOP", OBJPROP_PRICE, 0),Bid-3000*Point,NULL,0,0,clrGreen);
               }
            if (Bid > ObjectGetDouble(0, "STOP", OBJPROP_PRICE, 0))
               {
               int order=OrderSend(Symbol(),OP_BUY,lots,Ask,3,ObjectGetDouble(0, "STOP", OBJPROP_PRICE, 0),Ask+3000*Point,NULL,0,0,clrGreen);
               }
            if ((Bid < ObjectGetDouble(0, "STOP", OBJPROP_PRICE, 0)) & (Ask > ObjectGetDouble(0, "STOP", OBJPROP_PRICE, 0)))
               {
               Comment("Stoploss line is between Ask-Bid price!");
               }
            }
         if (ObjectFind(0,"STOP") == -1)
            {
            Comment("Stoploss Line in not exist on chart!");
            }
         }
      }
   }