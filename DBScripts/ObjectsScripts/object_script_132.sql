alter table IS_INVOICE_SUMMARY add VAT_PARENT_REF_NO varchar2(30);
alter table POFH_PRICE_OPT_FIXATION_HEADER add DELTA_PRICED_QTY NUMBER(25,10);
alter table PFD_PRICE_FIXATION_DETAILS add IS_DELTA_PRICING CHAR(1);
alter table vat_d add VAT_PARENT_REF_NO VARCHAR2 (30);