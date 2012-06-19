BEGIN

for cc in (select AKC.CORPORATE_ID from AK_CORPORATE akc where AKC.IS_ACTIVE='Y' and AKC.IS_INTERNAL_CORPORATE='N') 

loop

Insert into ARF_ACTION_REF_NUMBER_FORMAT
   (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID, PREFIX, MIDDLE_NO_START_VALUE, 
    MIDDLE_NO_LAST_USED_VALUE, SUFFIX, VERSION, IS_DELETED)
 Values
   ('ARF-FMU-&'||CC.CORPORATE_ID, 'FMUtilRefNo', CC.CORPORATE_ID, 'FM-UTIL-', 1, 
    0,  '-'||CC.CORPORATE_ID, 1, 'N');

Insert into ARFM_ACTION_REF_NO_MAPPING
   (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID, ACTION_KEY_ID, IS_DELETED)
 Values
   ('ARFM-FMU-&'||CC.CORPORATE_ID, CC.CORPORATE_ID, 'CREATE_FREEMETAL_UTILITY', 'FMUtilRefNo', 'N');

Insert into ERC_EXTERNAL_REF_NO_CONFIG
   (CORPORATE_ID, EXTERNAL_REF_NO_KEY, PREFIX, MIDDLE_NO_LAST_USED_VALUE, SUFFIX)
 Values
   (CC.CORPORATE_ID, 'CREATE_FREEMETAL_UTILITY', 'FM-UTIL-', 0, '-'||CC.CORPORATE_ID);


Insert into ARF_ACTION_REF_NUMBER_FORMAT
   (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID, PREFIX, MIDDLE_NO_START_VALUE, 
    MIDDLE_NO_LAST_USED_VALUE, SUFFIX, VERSION, IS_DELETED)
 Values
   ('ARF-FP-&'||CC.CORPORATE_ID, 'FMPricefix', CC.CORPORATE_ID, 'FM-PF-', 1, 
    0,  '-'||CC.CORPORATE_ID, 1, 'N');

Insert into ARFM_ACTION_REF_NO_MAPPING
   (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID, ACTION_KEY_ID, IS_DELETED)
 Values
   ('ARFM-FP-&'||CC.CORPORATE_ID, CC.CORPORATE_ID, 'CREATE_FREEMETAL_UTILITY', 'FMPricefix', 'N');

Insert into ERC_EXTERNAL_REF_NO_CONFIG
   (CORPORATE_ID, EXTERNAL_REF_NO_KEY, PREFIX, MIDDLE_NO_LAST_USED_VALUE, SUFFIX)
 Values
   (CC.CORPORATE_ID, 'CREATE_FREEMETAL_UTILITY', 'FM-PF-', 0, '-'||CC.CORPORATE_ID);


Insert into ARF_ACTION_REF_NUMBER_FORMAT
   (ACTION_REF_NUMBER_FORMAT_ID, ACTION_KEY_ID, CORPORATE_ID, PREFIX, MIDDLE_NO_START_VALUE, 
    MIDDLE_NO_LAST_USED_VALUE, SUFFIX, VERSION, IS_DELETED)
 Values
   ('ARF-RU-&'||CC.CORPORATE_ID, 'FMRollback', CC.CORPORATE_ID, 'FM-RU-', 1, 
    0,  '-'||CC.CORPORATE_ID, 1, 'N');

Insert into ARFM_ACTION_REF_NO_MAPPING
   (ACTION_REF_NO_MAPPING_ID, CORPORATE_ID, ACTION_ID, ACTION_KEY_ID, IS_DELETED)
 Values
   ('ARFM-RU-&'||CC.CORPORATE_ID, CC.CORPORATE_ID, 'ROLLBACK_FREEMETAL_UTILITY', 'FMRollback', 'N');

Insert into ERC_EXTERNAL_REF_NO_CONFIG
   (CORPORATE_ID, EXTERNAL_REF_NO_KEY, PREFIX, MIDDLE_NO_LAST_USED_VALUE, SUFFIX)
 Values
   (CC.CORPORATE_ID, 'ROLLBACK_FREEMETAL_UTILITY', 'FM-RU-', 0, '-'||CC.CORPORATE_ID);
 

 end loop;

end;


