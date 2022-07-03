//+------------------------------------------------------------------+
//|                                     TREX Position Management.mq4 |
//|                           Copyright 2020, ZIZO TREX SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, TREX , By Sina Shaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "2.00"
#property strict
#property show_inputs

input double TP1 = 0; // Order TP1
input double TP2 = 0; // Order TP2
input double TP3 = 0; // Order TP3
input int FreeLots = 50; // % of Free LotSize Steps

enum TimeframesList
      {
      M1=1,
      M5=5,
      M15=15,
      H1=60,
      H4=240,
      D1=1440  
      };
input TimeframesList Timeframe; // Timeframe
input double TrillTP = 0.7; // SL Trilling Target
input double TrillSL = 0.1; // SL Trilling Factor

double Target; // Order Target
double Lot1; // Free LotSize 1
double Lot2; // Free LotSize 2
double Lot3; // Free LotSize 3
double RemainLot; // For Lot Calc.
int typeFlag = 0; // Flag for Type Order Declaration
int Steps; // Trilling Steps
int iSteps = 0; // Numerator for Trilling Steps



int mainFlag = 0; // Expert Main Flag
string TriggerFrame = ""; // Trigger Timeframe and Exit Period
string TriggerFlag = ""; // Trigger Timeframe Flag
int TriggerTime = 15; // Trigger Timeframe
int myPeriod = 5; // Exit Period
 
double oldSL = 0; // Old Stoploss for Iterations
double newSL = 1; // New Stoploss for Iterations
double StopLoss = 0; // SL of Order
int noTP = 0; // Number of TP's
int closeFlag = 0; // Flag for Declaration of Closing Order
int slFlag = 0; // Flag for Declaration of Modifying Stoploss of Order

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(TP3 != 0)
      {
      Target[3] = {TP1, TP2, TP3};
      Steps = 3;
      }
   else if(TP2 != 0)
      {
      Target[2] = {TP1, TP2};
      Steps = 2;
      }
   else if(TP1 != 0)
      {
      Target = TP1;
      Steps = 1;
      }
   else if(TP1 == 0)
      {
      mainFlag == -1; // TP's NOT set!
      } 
   if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(OrderStopLoss() == 0)
         {
         mainFlag = -2; // SL NOT set!
         }
      else if(OrderStopLoss() != 0)
         {
         StopLoss = OrderStopLoss(); // Order SL
         }
      
      
      }
   
   // Lot1 = NormalizeDouble(floor((FreeLots/100)*OrderLots()),2);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(mainFlag == 0) // First Time Checking Order
         {
         if((OrderType()==0) || (OrderType()==1))
            {
            //bool removeTP = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),Target,0,clrRed);
            ObjectDelete("TARGET-Line");
            ObjectCreate("TARGET-Line", OBJ_HLINE , 0, Time[0], Target[iSteps]);
               ObjectSet("TARGET-Line", OBJPROP_STYLE, STYLE_DASH);
               ObjectSet("TARGET-Line", OBJPROP_COLOR, clrLimeGreen);
               ObjectSet("TARGET-Line", OBJPROP_WIDTH, 1);
               ObjectSet("TARGET-Line", OBJPROP_BACK, false);
               ObjectSet("TARGET-Line", OBJPROP_READONLY, true);
               ObjectSet("TARGET-Line", OBJPROP_SELECTABLE, false);            
            if(OrderType() == 0)
               {
               typeFlag = 1; // Buy Order is Selected
               }
            else if(OrderType() == 1)
               {
               typeFlag = -1; // Sell Order is Selected
               }
            }
         }
      
      //--- TRILLING STOPLOSS IN BUY ORDER!
      if((TrillTP != 0) && (TrillSL != 0) && (typeFlag == 1) && (slFlag == 0) && (Bid>(OrderOpenPrice()+TrillTP*(Target[iSteps]-OrderOpenPrice()))))
         {
         slFlag = 1; // Trilling Stoploss is Done!
         bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()+TrillSL*(Target[iSteps]-OrderOpenPrice())),0,0,clrRed);
         }
      //--- TRILLING STOPLOSS IN SELL ORDER!
      if((TrillTP != 0) && (TrillSL != 0) && (typeFlag == -1) && (slFlag == 0) && (Ask<(OrderOpenPrice()-TrillTP*(OrderOpenPrice()-Target[iSteps]))))
         {
         slFlag = 1; // Trilling Stoploss is Done!
         bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()-TrillSL*(OrderOpenPrice()-Target[iSteps])),0,0,clrRed);
         }
      
      //--- EXIT STERATEGY IS ON, IF TARGET HAS BEEN TOUCHED IN BUY ORDER!
      if((typeFlag==1) && (Bid > Target[iSteps]))
         {
         typeFlag = 2; // TARGET HAS BEEN TOUCHED IN BUY ORDER!
         iSteps = iSteps+1;
         // Taaaa Innnjaaaaaaaaaa
         newSL = (iLow(NULL,TriggerTime,iLowest(NULL,TriggerTime,MODE_LOW,myPeriod+1,0)));
         ObjectDelete("TP-Line");
         }
      //--- EXIT STERATEGY IS ON, IF TARGET HAS BEEN TOUCHED IN BUY ORDER!
      else if((typeFlag == -1) && (iClose(NULL,TriggerTime,0) < Target))
         {
         typeFlag = -2; // TARGET HAS BEEN TOUCHED IN BUY ORDER!
         newSL = (iHigh(NULL,TriggerTime,iHighest(NULL,TriggerTime,MODE_HIGH,myPeriod+1,0)));
         ObjectDelete("TP-Line");
         }
      //--- IF STOPLOSS HAS BEEN TOUCHED IN BUY ORDER!
      if(typeFlag == 2)
         {
         if((newSL > (iClose(NULL,TriggerTime,0))))
            {
            bool Exit = OrderClose(OrderTicket(),OrderLots(),Bid,1000,clrDeepPink);
            ObjectDelete("SL-Line");
            closeFlag = 1;
            mainFlag = 0;
            typeFlag = 0;
            }
         newSL = (iLow(NULL,TriggerTime,iLowest(NULL,TriggerTime,MODE_LOW,myPeriod+1,0)));
         if((closeFlag == 0) && (oldSL != newSL))
            {
            ObjectDelete("SL-Line");
            ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], newSL);
                    ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                    ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                    ObjectSet("SL-Line", OBJPROP_WIDTH, 1);
                    ObjectSet("SL-Line", OBJPROP_BACK, true);
                    ObjectSet("SL-Line", OBJPROP_READONLY, true);
                    ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
            oldSL = newSL;
            }
         }
      //--- IF STOPLOSS HAS BEEN TOUCHED IN SELL ORDER!
      else if(typeFlag == -2)
         {
         if(newSL < (iClose(NULL,TriggerTime,0)))
            {
            bool Exit = OrderClose(OrderTicket(),OrderLots(),Ask,1000,clrDeepPink);
            ObjectDelete("SL-Line");
            closeFlag = 1;
            mainFlag = 0;
            typeFlag = 0;
            }
         newSL = (iHigh(NULL,TriggerTime,iHighest(NULL,TriggerTime,MODE_HIGH,myPeriod+1,0)));
         if((closeFlag == 0) && (oldSL != newSL))
            {
            ObjectDelete("SL-Line");
            ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], newSL);
                    ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                    ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                    ObjectSet("SL-Line", OBJPROP_WIDTH, 1);
                    ObjectSet("SL-Line", OBJPROP_BACK, true);
                    ObjectSet("SL-Line", OBJPROP_READONLY, true);
                    ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
            oldSL = newSL;
            }
         }
       else if(mainFlag == -2)
         {
         ObjectDelete("TP-Line");
         ObjectDelete("SL-Line");
         Alert("Please Enter STOPLOSS for Order.");
         ExpertRemove();
         }
       else if(mainFlag == -1)
         {
         ObjectDelete("TP-Line");
         ObjectDelete("SL-Line");
         Alert("Please Enter at least ONE TP for Order.");
         ExpertRemove();
         }
      }
   else if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)==false)
      {
      ObjectDelete("TP-Line");
      ObjectDelete("SL-Line");
      closeFlag = 1;
      mainFlag = 0;
      typeFlag = 0;
      }      
  }
//---END
