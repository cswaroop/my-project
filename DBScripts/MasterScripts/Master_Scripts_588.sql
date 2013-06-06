SET DEFINE OFF;
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('MLOCI_2_2', 'MLOCI', 'Mark as Fulfilled', 2, 2, 
    'APP-PFL-N-221', 'function(){markAsFullfilled()}', NULL, 'MLOCI_2', 'APP-ACL-N1363');
COMMIT;

SET DEFINE OFF;
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('MLOCI_2_3', 'MLOCI', 'Cancel Fulfillment', 3, 2, 
    'APP-PFL-N-221', 'function(){cancelFulfillment()}', NULL, 'MLOCI_2', 'APP-ACL-N1364');
COMMIT;