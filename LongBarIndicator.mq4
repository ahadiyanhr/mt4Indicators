//+------------------------------------------------------------------+
//|                                                    Harez LSH.mq4 |
//|                                        Copyright 2020, Harezian. |
//|                                            ahadiyan.hr@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2020, Harezian."
#property link      "ahadiyan.hr@gmail.co"
//----
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Blue

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW, EMPTY);
   SetIndexArrow(0,242);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_ARROW, EMPTY);
   SetIndexArrow(1,241);
   SetIndexBuffer(1, ExtMapBuffer2);
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
  int deinit()
  {
   ObjectsDeleteAll(0, OBJ_TEXT);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
  int start()
  {
//----
   int shift;
   int shift1;
   int arrowShift;

//----
   // Code to determine a good place to put the text and arrow
   switch(Period())
     {
      case 5:
         arrowShift=15;
         break;
      case 15:
         arrowShift=20;
         break;
      case 30:
         arrowShift=30;
         break;
      case 60:
         arrowShift=35;
         break;
      case 240:
         arrowShift=70;
         break;
      case 1440:
         arrowShift=120;
         break;
      case 10080:
         arrowShift=200;
         break;
      case 43200:
         arrowShift=400;
         break;
     }
     
   for(shift=0; shift < 1000; shift++)
     {
      shift1=shift + 1;     
      // Check for a Long Bar pattern
      if ((MathAbs(Close[shift1] - Open[shift1]) >= 1.2 * iATR(Symbol(), PERIOD_CURRENT, 63, shift1)) && Period() > 4) // Have a Big Shadows and Little Body
         {
         if ((Close[shift1] > Open[shift1])) // Is a Bull
            {
            ExtMapBuffer2[shift1]=Low[shift1] - (Point * arrowShift);
            }
         if ((Close[shift1] < Open[shift1])) // Is a Bear
            {
            ExtMapBuffer1[shift1]=High[shift1] + (Point * arrowShift);
            }
         continue;
         }       
     } // End of for loop
     
   return(0);
  }
//+------------------------------------------------------------------+