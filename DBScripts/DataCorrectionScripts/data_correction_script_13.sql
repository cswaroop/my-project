UPDATE GRD_GOODS_RECORD_DETAIL GRD 
SET GRD.TRADING_MINING_COMB_TYPE = 'Mining',
GRD.BASE_CONC_TYPE = 'CONCENTRATES'
WHERE GRD.TOLLING_STOCK_TYPE = 'Clone Stock';

UPDATE GRD_GOODS_RECORD_DETAIL GRD 
SET GRD.TRADING_MINING_COMB_TYPE = 'Mining'
WHERE GRD.TOLLING_STOCK_TYPE = 'RM Out Process Stock';

UPDATE GMR_GOODS_MOVEMENT_RECORD GMR 
SET GMR.TRADING_MINING_COMB_TYPE = 'Mining'
WHERE GMR.TOLLING_GMR_TYPE IN ('Mark For Tolling','Received Materials');