//+------------------------------------------------------------------+
//|                                                    Copyright 2024 Sahibnoor Singh |
//|                                             EA based on SMMA and RSI strategy |
//+------------------------------------------------------------------+
#property copyright "2024 Sahibnoor Singh (username: hashtagunknown)"
#property version   "1.00"
#property strict
// Input parameters
input int    smmaPeriod_21 = 21;
input int    smmaPeriod_50 = 50;
input int    smmaPeriod_200 = 200;
input double lotSize = 0.1; // Trading lot size
input double stopLossRatio = 1.0; // Stop loss as a multiple of ATR
input double takeProfitRatio = 1.75; // Take profit as a multiple of stop loss
input int    rsiPeriod = 14; // RSI period
input int    rsiLevel = 50; // RSI level for entry
// Global variables
double       smma_21, smma_50, smma_200;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                            |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Calculate SMMA values
   smma_21 = iMA(NULL, 0, smmaPeriod_21, 0, MODE_SMMA, PRICE_CLOSE, 0);
   smma_50 = iMA(NULL, 0, smmaPeriod_50, 0, MODE_SMMA, PRICE_CLOSE, 0);
   smma_200 = iMA(NULL, 0, smmaPeriod_200, 0, MODE_SMMA, PRICE_CLOSE, 0);
   // Check for buy condition
   if (Close[1] > smma_21 && Low[1] <= smma_21 && Close[0] > Open[0] && Close[0] > smma_21 && Close[0] > smma_50 && Close[0] > smma_200 && iRSI(NULL, 0, rsiPeriod, PRICE_CLOSE, 0) > rsiLevel)
     {
      // Place buy order
      double stopLoss = smma_50;
      double takeProfit = Ask + stopLoss * takeProfitRatio;
      OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, takeProfit, "Bullish Engulfing", 0, clrNONE);
     }
   // Check for sell condition
   else if (Close[1] < smma_21 && High[1] >= smma_21 && Close[0] < Open[0] && Close[0] < smma_21 && Close[0] < smma_50 && Close[0] < smma_200 && iRSI(NULL, 0, rsiPeriod, PRICE_CLOSE, 0) < rsiLevel)
     {
      // Place sell order
      double stopLoss = smma_50;
      double takeProfit = Bid - stopLoss * takeProfitRatio;
      OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLoss, takeProfit, "Bearish Engulfing", 0, clrNONE);
     }
  }
//+------------------------------------------------------------------+
