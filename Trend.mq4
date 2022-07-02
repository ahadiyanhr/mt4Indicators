//+------------------------------------------------------------------+
//|                                                        Trend.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

string Trends[3] = { "Buy", "Sell", "Range" };
color Colors[3] = { clrBlue, clrRed, clrDimGray };
enum Trend
      {
      Buy=0,
      Sell=1,
      Range=2,  
      };
input Trend MNT; // MN Trend
input Trend W1T; // W1 Trend
input Trend D1T; // D1 Trend
input Trend H4T; // H4 Trend
input Trend H1T; // H1 Trend
input Trend M15T; // M15 Trend
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
  
   ObjectCreate(0,"M15TF", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("M15TF","M15: ",11, "Calibri Bold", clrDarkOrange); 
        ObjectSetInteger(0,"M15TF",OBJPROP_XDISTANCE,220);
        ObjectSetInteger(0,"M15TF",OBJPROP_YDISTANCE,0);
        ObjectSet("M15TF", OBJPROP_FONTSIZE, 10);
        ObjectSet("M15TF", OBJPROP_BACK, False);
        ObjectSet("M15TF", OBJPROP_READONLY, true);
        ObjectSet("M15TF", OBJPROP_SELECTABLE, false);
        ObjectSet("M15TF", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"M15TND", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("M15TND",Trends[M15T],11, "Calibri Bold", Colors[M15T]);
        ObjectSetInteger(0,"M15TND",OBJPROP_XDISTANCE,255);
        ObjectSetInteger(0,"M15TND",OBJPROP_YDISTANCE,0);
        ObjectSet("M15TND", OBJPROP_FONTSIZE, 10);
        ObjectSet("M15TND", OBJPROP_BACK, False);
        ObjectSet("M15TND", OBJPROP_READONLY, true);
        ObjectSet("M15TND", OBJPROP_SELECTABLE, false);
        ObjectSet("M15TND", OBJPROP_HIDDEN, true);
   
   ObjectCreate(0,"H1TF", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("H1TF","H1: ",11, "Calibri Bold", clrDarkGreen); 
        ObjectSetInteger(0,"H1TF",OBJPROP_XDISTANCE,335);
        ObjectSetInteger(0,"H1TF",OBJPROP_YDISTANCE,0);
        ObjectSet("H1TF", OBJPROP_FONTSIZE, 10);
        ObjectSet("H1TF", OBJPROP_BACK, False);
        ObjectSet("H1TF", OBJPROP_READONLY, true);
        ObjectSet("H1TF", OBJPROP_SELECTABLE, false);
        ObjectSet("H1TF", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"H1TND", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("H1TND",Trends[H1T],11, "Calibri Bold", Colors[H1T]);
        ObjectSetInteger(0,"H1TND",OBJPROP_XDISTANCE,358);
        ObjectSetInteger(0,"H1TND",OBJPROP_YDISTANCE,0);
        ObjectSet("H1TND", OBJPROP_FONTSIZE, 10);
        ObjectSet("H1TND", OBJPROP_BACK, False);
        ObjectSet("H1TND", OBJPROP_READONLY, true);
        ObjectSet("H1TND", OBJPROP_SELECTABLE, false);
        ObjectSet("H1TND", OBJPROP_HIDDEN, true);
        
   ObjectCreate(0,"H4TF", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("H4TF","H4: ",11, "Calibri Bold", clrMaroon); 
        ObjectSetInteger(0,"H4TF",OBJPROP_XDISTANCE,438);
        ObjectSetInteger(0,"H4TF",OBJPROP_YDISTANCE,0);
        ObjectSet("H4TF", OBJPROP_FONTSIZE, 10);
        ObjectSet("H4TF", OBJPROP_BACK, False);
        ObjectSet("H4TF", OBJPROP_READONLY, true);
        ObjectSet("H4TF", OBJPROP_SELECTABLE, false);
        ObjectSet("H4TF", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"H4TND", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("H4TND",Trends[H4T],11, "Calibri Bold", Colors[H4T]);
        ObjectSetInteger(0,"H4TND",OBJPROP_XDISTANCE,461);
        ObjectSetInteger(0,"H4TND",OBJPROP_YDISTANCE,0);
        ObjectSet("H4TND", OBJPROP_FONTSIZE, 10);
        ObjectSet("H4TND", OBJPROP_BACK, False);
        ObjectSet("H4TND", OBJPROP_READONLY, true);
        ObjectSet("H4TND", OBJPROP_SELECTABLE, false);
        ObjectSet("H4TND", OBJPROP_HIDDEN, true);
        
   ObjectCreate(0,"D1TF", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("D1TF","D1: ",11, "Calibri Bold", clrDarkBlue); 
        ObjectSetInteger(0,"D1TF",OBJPROP_XDISTANCE,541);
        ObjectSetInteger(0,"D1TF",OBJPROP_YDISTANCE,0);
        ObjectSet("D1TF", OBJPROP_FONTSIZE, 10);
        ObjectSet("D1TF", OBJPROP_BACK, False);
        ObjectSet("D1TF", OBJPROP_READONLY, true);
        ObjectSet("D1TF", OBJPROP_SELECTABLE, false);
        ObjectSet("D1TF", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"D1TND", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("D1TND",Trends[D1T],11, "Calibri Bold", Colors[D1T]);
        ObjectSetInteger(0,"D1TND",OBJPROP_XDISTANCE,564);
        ObjectSetInteger(0,"D1TND",OBJPROP_YDISTANCE,0);
        ObjectSet("D1TND", OBJPROP_FONTSIZE, 10);
        ObjectSet("D1TND", OBJPROP_BACK, False);
        ObjectSet("D1TND", OBJPROP_READONLY, true);
        ObjectSet("D1TND", OBJPROP_SELECTABLE, false);
        ObjectSet("D1TND", OBJPROP_HIDDEN, true);
        
      ObjectCreate(0,"W1TF", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("W1TF","W1: ",11, "Calibri Bold", clrPurple); 
        ObjectSetInteger(0,"W1TF",OBJPROP_XDISTANCE,644);
        ObjectSetInteger(0,"W1TF",OBJPROP_YDISTANCE,0);
        ObjectSet("W1TF", OBJPROP_FONTSIZE, 10);
        ObjectSet("W1TF", OBJPROP_BACK, False);
        ObjectSet("W1TF", OBJPROP_READONLY, true);
        ObjectSet("W1TF", OBJPROP_SELECTABLE, false);
        ObjectSet("W1TF", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"W1TND", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("W1TND",Trends[W1T],11, "Calibri Bold", Colors[W1T]);
        ObjectSetInteger(0,"W1TND",OBJPROP_XDISTANCE,671);
        ObjectSetInteger(0,"W1TND",OBJPROP_YDISTANCE,0);
        ObjectSet("W1TND", OBJPROP_FONTSIZE, 10);
        ObjectSet("W1TND", OBJPROP_BACK, False);
        ObjectSet("W1TND", OBJPROP_READONLY, true);
        ObjectSet("W1TND", OBJPROP_SELECTABLE, false);
        ObjectSet("W1TND", OBJPROP_HIDDEN, true);
        
   ObjectCreate(0,"MNTF", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("MNTF","MN: ",11, "Calibri Bold", clrBlack); 
        ObjectSetInteger(0,"MNTF",OBJPROP_XDISTANCE,751);
        ObjectSetInteger(0,"MNTF",OBJPROP_YDISTANCE,0);
        ObjectSet("MNTF", OBJPROP_FONTSIZE, 10);
        ObjectSet("MNTF", OBJPROP_BACK, False);
        ObjectSet("MNTF", OBJPROP_READONLY, true);
        ObjectSet("MNTF", OBJPROP_SELECTABLE, false);
        ObjectSet("MNTF", OBJPROP_HIDDEN, true);
   ObjectCreate(0,"MNTND", OBJ_LABEL ,0, 0, 10);
        ObjectSetText("MNTND",Trends[MNT],11, "Calibri Bold", Colors[MNT]);
        ObjectSetInteger(0,"MNTND",OBJPROP_XDISTANCE,778);
        ObjectSetInteger(0,"MNTND",OBJPROP_YDISTANCE,0);
        ObjectSet("MNTND", OBJPROP_FONTSIZE, 10);
        ObjectSet("MNTND", OBJPROP_BACK, False);
        ObjectSet("MNTND", OBJPROP_READONLY, true);
        ObjectSet("MNTND", OBJPROP_SELECTABLE, false);
        ObjectSet("MNTND", OBJPROP_HIDDEN, true);
  }
//+------------------------------------------------------------------+
