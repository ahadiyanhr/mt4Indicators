//+------------------------------------------------------------------+
//|                                              PolySign Expert.mq4 |
//|                          Copyright 2020, SinaShaabaz (PolySign). |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz (PolySign)."
#property link      "sinashaabaz@gmail.com"
#property version   "2.00"
#property strict
#property show_inputs

input double TP1; // Order TP1
input double Lot1; // 1st Close LotSize
input double TP2; // Order TP2
input double Lot2; // 2nd Close LotSize
input double TP3; // Order TP3
input double Lot3; // 3rd Close LotSize
input double TrillTP = 70; // % Trilling TP
input double TrillSL1 = 15; // % 1st Trilling SL
input double TrillSL2 = 50; // % 2nd Trilling SL

double OpenPrice; // Order Open Price
double Target[3] = { 0, 0, 0 }; // Order Target
double LotSizes[3] = { 0, 0, 0 }; // Order Lotsize
double StopLoss; // Order SL
int mainFlag = 0; // Flag for Type Order Declaration
int iSteps = 0; // Numerator for Trilling Steps
int slFlag = 0; // Flag for SL Trilling

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Target[0] = TP1;
   Target[1] = TP2;
   Target[2] = TP3;
   LotSizes[0] = Lot1;
   LotSizes[1] = Lot2;
   LotSizes[2] = Lot3;
    
   if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)==true)
      {
      if(TP1 == 0)
         {
         mainFlag = -10; // TP's NOT set!
         }  
      if(OrderStopLoss() == 0)
         {
         mainFlag = -20; // SL NOT set!
         }
      else if(OrderStopLoss() != 0)
         {
         StopLoss = OrderStopLoss(); // Order SL
         }

      }
   
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
            ObjectDelete("TARGET-Line");
            ObjectCreate("TARGET-Line", OBJ_HLINE , 0, Time[0], Target[iSteps]);
               ObjectSetString(0,"TARGET-Line", OBJPROP_TEXT, "Target-Line");
               ObjectSet("TARGET-Line", OBJPROP_STYLE, STYLE_DASH);
               ObjectSet("TARGET-Line", OBJPROP_COLOR, clrLimeGreen);
               ObjectSet("TARGET-Line", OBJPROP_WIDTH, 1);
               ObjectSet("TARGET-Line", OBJPROP_BACK, false);
               ObjectSet("TARGET-Line", OBJPROP_READONLY, true);
               ObjectSet("TARGET-Line", OBJPROP_SELECTABLE, false);
            OpenPrice = OrderOpenPrice();       
            if(OrderType() == 0)
               {
               mainFlag = 1; // Buy Order is Selected
               }
            else if(OrderType() == 1)
               {
               mainFlag = -1; // Sell Order is Selected
               }
            }
         }
      
      //--- TRILLING STOPLOSS IN BUY ORDER!
      if((slFlag == 0) && (mainFlag == 1) && (Bid > (OpenPrice+(TrillTP/100)*(Target[iSteps]-OpenPrice))))
         {
         slFlag = 1; // Trilling Stoploss is Done!
         bool Modify = OrderModify(OrderTicket(),OrderOpenPrice(),(OpenPrice+(TrillSL1/100)*(Target[iSteps]-OpenPrice)),0,0,clrRed);
         }
      //--- TRILLING STOPLOSS IN SELL ORDER!
      if((slFlag == 0) && (mainFlag == -1) && (Ask < (OpenPrice-(TrillTP/100)*(OpenPrice-Target[iSteps]))))
         {
         slFlag = 1; // Trilling Stoploss is Done!
         bool ModifySL = OrderModify(OrderTicket(),OrderOpenPrice(),(OpenPrice-(TrillSL1/100)*(OpenPrice-Target[iSteps])),0,0,clrRed);
         }
      
      //--- EXIT STERATEGY IS ON, IF TARGET HAS BEEN TOUCHED IN BUY ORDER!
      if((slFlag == 1) && (mainFlag == 1) && (Bid > Target[iSteps]))
         {
         bool ModifySL = OrderModify(OrderTicket(),OrderOpenPrice(),(OpenPrice-(TrillSL2/100)*(OpenPrice-Target[iSteps])),0,0,clrRed);
         OpenPrice = Target[iSteps];
         bool CloseOrders = OrderClose(OrderTicket(),LotSizes[iSteps],Bid,1000,clrDarkBlue);
         iSteps = iSteps+1;
         bool  moving = ObjectMove( "TARGET-Line",0,Time[0],Target[iSteps] );
         slFlag = 0;
         }
       
      //--- EXIT STERATEGY IS ON, IF TARGET HAS BEEN TOUCHED IN SELL ORDER!
      if((slFlag == 1) && (mainFlag == -1) && (Ask < Target[iSteps]))
         {
         bool ModifySL = OrderModify(OrderTicket(),OrderOpenPrice(),(OpenPrice-(TrillSL2/100)*(OpenPrice-Target[iSteps])),0,0,clrRed);
         OpenPrice = Target[iSteps];
         bool CloseOrders = OrderClose(OrderTicket(),LotSizes[iSteps],Ask,1000,clrDarkBlue);
         iSteps = iSteps+1;
         bool  moving = ObjectMove( "TARGET-Line",0,Time[0],Target[iSteps] );
         slFlag = 0;
         }
         
       if(mainFlag == -20)
         {
         ObjectDelete("TP-Line");
         Alert("Please Enter STOPLOSS for Order.");
         ExpertRemove();
         }
       if(mainFlag == -10)
         {
         ObjectDelete("TP-Line");
         Alert("Please Enter at least ONE TP for Order.");
         ExpertRemove();
         }
      }
   else if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)==false)
      {
      ObjectDelete("TARGET-Line");
      Print("There is NOT any Order!");
      ExpertRemove();
      }      
  }
//---END
