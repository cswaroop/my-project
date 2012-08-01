ALTER TABLE ORD_OVERALL_REALIZED_PNL_DAILY ADD   alloc_group_name VARCHAR2(100);

ALTER TABLE IS_INVOICE_SUMMARY ADD 
(IS_PLEDGE CHAR(1),
IS_RECEIVE_MATERIAL CHAR(1), 
PAYABLE_RECEIVABLE VARCHAR2 (30),
INVOICED_QTY_UNIT_ID VARCHAR2 (15),
FREIGHT_ALLOWANCE_AMT NUMBER (25,10));

-- Add/modify columns 
alter table TDC_TRADE_DATE_CLOSURE add PROCESS_RUN_COUNT number default 1;