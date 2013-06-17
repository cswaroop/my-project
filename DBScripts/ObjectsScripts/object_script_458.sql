-- Bulk Pricing document


CREATE TABLE BPFD_BULK_PFD_D 
    ( 
     INTERNAL_DOC_REF_NO VARCHAR2 (30 CHAR)  NOT NULL , 
     DOC_ISSUE_DATE VARCHAR2 (50 CHAR) , 
     CORPORATE_NAME VARCHAR2 (100 CHAR) , 
     CP_ADDRESS VARCHAR2 (100 CHAR) , 
     CP_CITY VARCHAR2 (100 CHAR) , 
     CP_COUNTRY VARCHAR2 (100 CHAR) , 
     CP_ZIP VARCHAR2 (100 CHAR) , 
     CP_STATE VARCHAR2 (100 CHAR) , 
     CP_NAME VARCHAR2 (100 CHAR) , 
     CP_PERSON_IN_CHARGE VARCHAR2 (100 CHAR) , 
     CONTRACT_TYPE VARCHAR2 (30 CHAR) , 
     PURCHASE_SALES VARCHAR2 (30 CHAR) , 
     CONTRACT_REF_NO VARCHAR2 (30 CHAR) , 
     DELIVERY_ITEM_REF_NO VARCHAR2 (80 CHAR) , 
     PAY_IN_CURRENCY VARCHAR2 (15 CHAR) , 
     PRODUCT VARCHAR2 (100 CHAR) , 
     QUALITY VARCHAR2 (200 CHAR) , 
     GMR_REF_NO VARCHAR2 (30 CHAR) , 
     QUOTA_PERIOD VARCHAR2 (50 CHAR) 
    ) 
;



COMMENT ON COLUMN BPFD_BULK_PFD_D.CONTRACT_TYPE IS 'Contains Contract type details
like CONCENTRATES , BASEMETALS' 
;

COMMENT ON COLUMN BPFD_BULK_PFD_D.PURCHASE_SALES IS 'Sell Tolling / Buy Tolling in case of Tolling contract
Purchase / Sales in case of Non-tolling contract' 
;

ALTER TABLE BPFD_BULK_PFD_D 
    ADD CONSTRAINT BPFD_BULK_PFD_D_PK PRIMARY KEY ( INTERNAL_DOC_REF_NO ) ;




CREATE TABLE BPFDE_ELMT_DTS_D 
    ( 
     INTERNAL_DOC_REF_NO VARCHAR2 (30 CHAR)  NOT NULL , 
     PFD_ID VARCHAR2 (15 CHAR) , 
     ELEMENT_NAME VARCHAR2 (30 CHAR) , 
     PRICE_FIXATION_REF_NO VARCHAR2 (30 CHAR) , 
     PRICE_FIXATION_DATE DATE , 
     PRICE NUMBER (25,10) , 
     PRICE_UNIT VARCHAR2 (30 CHAR) , 
     PRICED_QUANTITY NUMBER (25,10) , 
     PRICED_QTY_UNIT VARCHAR2 (15 CHAR) , 
     FX_RATE NUMBER (25,10) , 
	 PRICE_UNIT_IN_PAYIN_CCY VARCHAR2 (30 CHAR) , 
     PRICE_TYPE VARCHAR2 (100 CHAR) , 
     PRICING_FORMULA VARCHAR2 (500 CHAR) , 
     QP VARCHAR2 (50 CHAR) 
    ) 
;



COMMENT ON COLUMN BPFDE_ELMT_DTS_D.PRICE_TYPE IS 'Contains price type details.
Event Based - Average
Event Based - Any Day
DI Based - Average
DI Based - Anyday/Spot - Weighted Average
DI Based - Any Day/Spot - Price allocation' 
;

COMMENT ON COLUMN BPFDE_ELMT_DTS_D.PRICING_FORMULA IS 'Contains Pricing formula details
Eg : 100% of LME Zinc, 1 Month After Month Of Arrival' 
;

COMMENT ON COLUMN BPFDE_ELMT_DTS_D.QP IS 'Contains Quotation period details ' 
;



ALTER TABLE BPFDE_ELMT_DTS_D 
    ADD CONSTRAINT BPFDE_BPFD_FK FOREIGN KEY 
    ( 
     INTERNAL_DOC_REF_NO
    ) 
    REFERENCES BPFD_BULK_PFD_D 
    ( 
     INTERNAL_DOC_REF_NO
    ) 
;

