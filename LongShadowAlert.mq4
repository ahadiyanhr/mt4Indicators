//+------------------------------------------------------------------+
//|                                              LongShadowAlert.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict

int i;
int j;
int shift = 0;
string AlertWords = "";
string Alerts = "";
int Periods[7] = { 15, 30, 60, 240, 1440, 10080, 43200 };
string PeriodsName[7] = { "M15", "M30", "H1", "H4", "D1", "W1", "MN"};
double multiple[7] = { 1.5, 1.3, 1.1, 1.05, 1.0, 0.95, 0.9 };
datetime NewCandleTime[7] = { D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00' };
string Symbols[38] = { "AUDCAD", "AUDCHF", "AUDJPY", "AUDNZD", "AUDUSD",
                       "CADCHF", "CADJPY",
                       "CHFJPY",
                       "EURAUD", "EURCHF", "EURCAD", "EURGBP", "EURJPY", "EURNZD", "EURUSD",
                       "GBPAUD", "GBPCHF", "GBPCAD", "GBPJPY", "GBPNZD", "GBPUSD",
                       "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD",
                       "USDCAD", "USDCHF", "USDJPY",
                       "XAUUSD", "XAGUSD",
                       "WTI", "BRENT"
                       "BTCUSD", "DSHUSD", "EOSUSD", "ETHUSD", "LTCUSD", "XRPUSD" };
bool IsNewCandle;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   for(i=0 ; i < ArraySize(Periods); i++)
      {
      NewCandleTime[i]=iTime("EURUSD",Periods[i],0);
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
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   for(i=0 ; i < ArraySize(Periods); i++)
      {
      if ((NewCandleTime[i] != iTime("EURUSD",Periods[i],0)) && (Seconds() >= 10))
         {
         for(j=0 ; j < ArraySize(Symbols); j++)
           {
            // Check for a Long Shadow pattern
            if (((iHigh(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)) > multiple[i] * iATR(Symbols[j], Periods[i], 63, shift)) // Bigger than Master Candle
               && (MathAbs(iClose(Symbols[j], Periods[i], shift) - iOpen(Symbols[j], Periods[i], shift)) <= 0.3*(iHigh(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)))) // Have a Big Shadows and Little Body
               {
               if ((iClose(Symbols[j], Periods[i], shift) > iOpen(Symbols[j], Periods[i], shift)) // Is a Bull
                  && ((iOpen(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)) >= 0.6*(iHigh(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)))) // Have a Long Lower Shadow
                  {
                  AlertWords = AlertWords+"St-Bull "+Symbols[j]+" ";
                  }
               else if ((iClose(Symbols[j], Periods[i], shift) < iOpen(Symbols[j], Periods[i], shift)) // Is a Bear
                       && ((iClose(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)) >= 0.6*(iHigh(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)))) // Have a Long Lower Shadow
                  {
                  AlertWords = AlertWords+"Wk-Bull "+Symbols[j]+" ";
                  }
               else if ((iClose(Symbols[j], Periods[i], shift) > iOpen(Symbols[j], Periods[i], shift)) // Is a Bull
                       && ((iHigh(Symbols[j], Periods[i], shift)-iClose(Symbols[j], Periods[i], shift)) >= 0.6*(iHigh(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)))) // Have a Long Upper Shadow
                  {
                  AlertWords = AlertWords+"St-Bear "+Symbols[j]+" ";
                  }
               else if ((iClose(Symbols[j], Periods[i], shift) < iOpen(Symbols[j], Periods[i], shift)) // Is a Bear
                       && ((iHigh(Symbols[j], Periods[i], shift)-iOpen(Symbols[j], Periods[i], shift)) >= 0.6*(iHigh(Symbols[j], Periods[i], shift)-iLow(Symbols[j], Periods[i], shift)))) // Have a Long Upper Shadow
                  {
                  AlertWords = AlertWords+"Wk-Bear "+Symbols[j]+" ";
                  }
               }
            } // End of for loop 2
            if( AlertWords != "" )
               {
               Print(AlertWords+" in "+PeriodsName[i]);
               bool Notif =  SendNotification( AlertWords+"in "+PeriodsName[i] );
               AlertWords = "";
               }
         NewCandleTime[i]=iTime("EURUSD",Periods[i],0);
         }
      }  // End of for loop 1
  }
//+------------------------------------------------------------------+
