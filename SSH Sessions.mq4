//+------------------------------------------------------------------+
//|                                                 SSH Sessions.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"

#property indicator_chart_window

//------- Âíåøíèå ïàðàìåòðû èíäèêàòîðà -------------------------------
extern int    NumberOfDays = 10;        // Êîëè÷åñòâî äíåé
extern string AsiaBegin    = "02:00";   // Îòêðûòèå àçèàòñêîé ñåññèè
extern string AsiaEnd      = "10:00";   // Çàêðûòèå àçèàòñêîé ñåññèè
extern color  AsiaColor    = clrPowderBlue; // Öâåò àçèàòñêîé ñåññèè
extern string EurBegin     = "08:00";   // Îòêðûòèå åâðîïåéñêîé ñåññèè
extern string EurEnd       = "17:00";   // Çàêðûòèå åâðîïåéñêîé ñåññèè
extern color  EurColor     = clrThistle;       // Öâåò åâðîïåéñêîé ñåññèè
extern string USABegin     = "15:00";   // Îòêðûòèå àìåðèêàíñêîé ñåññèè
extern string USAEnd       = "24:00";   // Çàêðûòèå àìåðèêàíñêîé ñåññèè
extern color  USAColor     = C'239,220,211'; // Öâåò àìåðèêàíñêîé ñåññèè


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init() {
  DeleteObjects();
  for (int i=0; i<NumberOfDays; i++) {
    CreateObjects("AS"+i, AsiaColor);
    CreateObjects("EU"+i, EurColor);
    CreateObjects("US"+i, USAColor);
  }
  Comment("");
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() {
  DeleteObjects();
  Comment("");
}

//+------------------------------------------------------------------+
//| Ñîçäàíèå îáúåêòîâ èíäèêàòîðà                                     |
//| Ïàðàìåòðû:                                                       |
//|   no - íàèìåíîâàíèå îáúåêòà                                      |
//|   cl - öâåò îáúåêòà                                              |
//+------------------------------------------------------------------+
void CreateObjects(string no, color cl) {
  ObjectCreate(no, OBJ_RECTANGLE, 0, 0,0, 0,0);
  ObjectSet(no, OBJPROP_STYLE, STYLE_SOLID);
  ObjectSet(no, OBJPROP_COLOR, cl);
  ObjectSet(no, OBJPROP_BACK, true);
  ObjectSet(no, OBJPROP_READONLY, true);
  ObjectSet(no, OBJPROP_SELECTABLE, false);
  ObjectSet(no, OBJPROP_HIDDEN, true);
}

//+------------------------------------------------------------------+
//| Óäàëåíèå îáúåêòîâ èíäèêàòîðà                                     |
//+------------------------------------------------------------------+
void DeleteObjects() {
  for (int i=0; i<NumberOfDays; i++) {
    ObjectDelete("AS"+i);
    ObjectDelete("EU"+i);
    ObjectDelete("US"+i);
  }
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start() {
  datetime dt=CurTime();

  for (int i=0; i<NumberOfDays; i++) {
    DrawObjects(dt, "AS"+i, AsiaBegin, AsiaEnd);
    DrawObjects(dt, "EU"+i, EurBegin, EurEnd);
    DrawObjects(dt, "US"+i, USABegin, USAEnd);
    dt=decDateTradeDay(dt);
    while (TimeDayOfWeek(dt)>5) dt=decDateTradeDay(dt);
  }
}

//+------------------------------------------------------------------+
//| Ïðîðèñîâêà îáúåêòîâ íà ãðàôèêå                                   |
//| Ïàðàìåòðû:                                                       |
//|   dt - äàòà òîðãîâîãî äíÿ                                        |
//|   no - íàèìåíîâàíèå îáúåêòà                                      |
//|   tb - âðåìÿ íà÷àëà ñåññèè                                       |
//|   te - âðåìÿ îêîí÷àíèÿ ñåññèè                                    |
//+------------------------------------------------------------------+
void DrawObjects(datetime dt, string no, string tb, string te) {
  datetime t1, t2;
  double   p1, p2;
  int      b1, b2;

  t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+tb);
  t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+te);
  b1=iBarShift(NULL, 0, t1);
  b2=iBarShift(NULL, 0, t2);
  p1=High[Highest(NULL, 0, MODE_HIGH, b1-b2, b2)];
  p2=Low [Lowest (NULL, 0, MODE_LOW , b1-b2, b2)];
  ObjectSet(no, OBJPROP_TIME1 , t1);
  ObjectSet(no, OBJPROP_PRICE1, p1);
  ObjectSet(no, OBJPROP_TIME2 , t2);
  ObjectSet(no, OBJPROP_PRICE2, p2);
  ObjectSet(no, OBJPROP_BACK, true);
  ObjectSet(no, OBJPROP_READONLY, true);
  ObjectSet(no, OBJPROP_SELECTABLE, false);
  ObjectSet(no, OBJPROP_HIDDEN, true);
}

//+------------------------------------------------------------------+
//| Óìåíüøåíèå äàòû íà îäèí òîðãîâûé äåíü                            |
//| Ïàðàìåòðû:                                                       |
//|   dt - äàòà òîðãîâîãî äíÿ                                        |
//+------------------------------------------------------------------+
datetime decDateTradeDay (datetime dt) {
  int ty=TimeYear(dt);
  int tm=TimeMonth(dt);
  int td=TimeDay(dt);
  int th=TimeHour(dt);
  int ti=TimeMinute(dt);

  td--;
  if (td==0) {
    tm--;
    if (tm==0) {
      ty--;
      tm=12;
    }
    if (tm==1 || tm==3 || tm==5 || tm==7 || tm==8 || tm==10 || tm==12) td=31;
    if (tm==2) if (MathMod(ty, 4)==0) td=29; else td=28;
    if (tm==4 || tm==6 || tm==9 || tm==11) td=30;
  }
  return(StrToTime(ty+"."+tm+"."+td+" "+th+":"+ti));
}
//+------------------------------------------------------------------+

