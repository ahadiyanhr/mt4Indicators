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
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Blue
#property indicator_color5 Green
#property indicator_color6 Green


//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
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
   
   SetIndexStyle(2,DRAW_ARROW, EMPTY);
   SetIndexArrow(2,242);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_ARROW, EMPTY);
   SetIndexArrow(3,241);
   SetIndexBuffer(3, ExtMapBuffer4);
   
   SetIndexStyle(4,DRAW_ARROW, EMPTY);
   SetIndexArrow(4,242);
   SetIndexBuffer(4, ExtMapBuffer5);
   SetIndexStyle(5,DRAW_ARROW, EMPTY);
   SetIndexArrow(5,241);
   SetIndexBuffer(5, ExtMapBuffer6);
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
   int shift2;
   int shift3;
   int arrowShift;
   double multiple;

//----
   // Code to determine a good place to put the text and arrow
   switch(Period())
     {
      case 1:
         arrowShift=1;
         multiple = 2;
         break;
      case 5:
         arrowShift=10;
         multiple = 1.75;
         break;
      case 15:
         arrowShift=13;
         multiple = 1.5;
         break;
      case 30:
         arrowShift=15;
         multiple = 1.3;
         break;
      case 60:
         arrowShift=25;
         multiple = 1.2;
         break;
      case 240:
         arrowShift=60;
         multiple = 1.05;
         break;
      case 1440:
         arrowShift=100;
         multiple = 1;
         break;
      case 10080:
         arrowShift=150;
         multiple = 0.95;
         break;
      case 43200:
         arrowShift=400;
         multiple = 0.9;
         break;
     }
     
   for(shift=0; shift < 10000; shift++)
     {
      shift1=shift + 1;
      shift2=shift1 + 1;
      shift3=shift2 + 1;
      
      // Check for a Long Shadow pattern
      if (((High[shift1]-Low[shift1]) > multiple * iATR(Symbol(), PERIOD_CURRENT, 63, shift1)) // Bigger than Master Candle
         && (MathAbs(Close[shift1] - Open[shift1]) <= 0.3*(High[shift1]-Low[shift1]))) // Have a Big Shadows and Little Body
         {
         if ((Close[shift1] > Open[shift1]) // Is a Bull
            && ((Open[shift1]-Low[shift1]) >= 0.6*(High[shift1]-Low[shift1]))) // Have a Long Lower Shadow
            {
            ExtMapBuffer2[shift1]=Low[shift1] - (Point * arrowShift);
            }
         if ((Close[shift1] < Open[shift1]) // Is a Bear
            && ((Close[shift1]-Low[shift1]) >= 0.6*(High[shift1]-Low[shift1]))) // Have a Long Lower Shadow
            {
            ExtMapBuffer2[shift1]=Low[shift1] - (Point * arrowShift);
            }
         if ((Close[shift1] > Open[shift1]) // Is a Bull
            && ((High[shift1]-Close[shift1]) >= 0.6*(High[shift1]-Low[shift1]))) // Have a Long Upper Shadow
            {
            ExtMapBuffer1[shift1]=High[shift1] + (Point * arrowShift);
            }
         if ((Close[shift1] < Open[shift1]) // Is a Bear
            && ((High[shift1]-Open[shift1]) >= 0.6*(High[shift1]-Low[shift1]))) // Have a Long Upper Shadow
            {
            ExtMapBuffer1[shift1]=High[shift1] + (Point * arrowShift);
            }
         continue;
         }
     
     // Check for a Persian Gulf pattern
      if (((High[shift1] - Low[shift1]) > multiple * iATR(Symbol(), PERIOD_CURRENT, 63, shift1))
         && (MathAbs(Close[shift1] - Open[shift1])/(High[shift1] - Low[shift1]) > 0.75) // LongBar 1
         && (MathAbs(High[shift2] - Low[shift2]) > multiple * iATR(Symbol(), PERIOD_CURRENT, 63, shift1))
         && (MathAbs(Close[shift2] - Open[shift2])/(High[shift2] - Low[shift2]) > 0.75) // LongBar 2
         && ((Close[shift1] - Open[shift1])*(Close[shift2] - Open[shift2]) < 0) // Opposite LongBars
         && (MathAbs(Close[shift1] - Open[shift1])/MathAbs(Close[shift2] - Open[shift2]) > 0.8) // Equal LongBars
         && (MathAbs(Close[shift1] - Open[shift1])/MathAbs(Close[shift2] - Open[shift2]) < 1.2)) // Equal LongBars
         {
         if ((Close[shift1] > Open[shift1])) // Is a Bull
            {
            ExtMapBuffer4[shift1]=Low[shift1] - (Point * arrowShift);
            }
         if ((Close[shift1] < Open[shift1])) // Is a Bear
            {
            ExtMapBuffer3[shift1]=High[shift1] + (Point * arrowShift);
            }
         continue;
         }
         
      // Check for a Star pattern
      if ((MathAbs(High[shift1] - Low[shift1]) > multiple * iATR(Symbol(), PERIOD_CURRENT, 63, shift1))
         && (MathAbs(Close[shift1] - Open[shift1])/(High[shift1] - Low[shift1]) > 0.75) // LongBar 1
         && ((High[shift2] - Low[shift2]) < (multiple/3) * iATR(Symbol(), PERIOD_CURRENT, 63, shift1)) // Star
         && (MathAbs(High[shift3] - Low[shift3]) > multiple * iATR(Symbol(), PERIOD_CURRENT, 63, shift1))
         && (MathAbs(Close[shift3] - Open[shift3])/(High[shift3] - Low[shift3]) > 0.75) // LongBar 3
         && ((Close[shift1] - Open[shift1])*(Close[shift3] - Open[shift3]) < 0) // Opposite LongBars
         && (MathAbs(Close[shift1] - Open[shift1])/MathAbs(Close[shift3] - Open[shift3]) > 0.8) // Equal LongBars
         && (MathAbs(Close[shift1] - Open[shift1])/MathAbs(Close[shift3] - Open[shift3]) < 1.2)) // Equal LongBars
         {
         if ((Close[shift1] > Open[shift1])) // Is a Bull
            {
            ExtMapBuffer6[shift2]=Low[shift2] - (Point * arrowShift);
            }
         if ((Close[shift1] < Open[shift1])) // Is a Bear
            {
            ExtMapBuffer5[shift2]=High[shift2] + (Point * arrowShift);
            }
         continue;
         }
         
     } // End of for loop
   return(0);
  }
//+------------------------------------------------------------------+