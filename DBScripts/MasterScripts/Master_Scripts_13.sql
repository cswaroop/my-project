SET DEFINE OFF;
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('LOC_1_2', 'PHY_LOC', 'Modify Contract', 4, 2, 
    NULL, 'function(){modifyContract();}', NULL, 'LOC_1', NULL);
COMMIT;

SET DEFINE OFF;
Insert into GMC_GRID_MENU_CONFIGURATION
   (MENU_ID, GRID_ID, MENU_DISPLAY_NAME, DISPLAY_SEQ_NO, MENU_LEVEL_NO, 
    FEATURE_ID, LINK_CALLED, ICON_CLASS, MENU_PARENT_ID, ACL_ID)
 Values
   ('LOC_1_3', 'PHY_LOC', 'Amend Contract', 4, 2, 
    NULL, 'function(){amendContract();}', NULL, 'LOC_1', NULL);
COMMIT;