
   
Insert into SLV_STATIC_LIST_VALUE
   (VALUE_ID, VALUE_TEXT)
 Values
   ('CREATE_RETURN_MATERIAL', 'Return Material');


Insert into SLS_STATIC_LIST_SETUP
   (LIST_TYPE, VALUE_ID, IS_DEFAULT, DISPLAY_ORDER)
 Values
   ('TollingInputOutputActivity', 'MARK_FOR_TOLLING', 'N', 1);
Insert into SLS_STATIC_LIST_SETUP
   (LIST_TYPE, VALUE_ID, IS_DEFAULT, DISPLAY_ORDER)
 Values
   ('TollingInputOutputActivity', 'RECORD_OUT_PUT_TOLLING', 'N', 2);
Insert into SLS_STATIC_LIST_SETUP
   (LIST_TYPE, VALUE_ID, IS_DEFAULT, DISPLAY_ORDER)
 Values
   ('TollingInputOutputActivity', 'CREATE_RETURN_MATERIAL', 'N', 3);