
update DGM_DOCUMENT_GENERATION_MASTER set FETCH_QUERY=
    'INSERT INTO AS_ASSAY_D(
INTERNAL_CONTRACT_ITEM_REF_NO,
ASSAY_REFNO,
INTERNAL_GMR_REF_NO ,
CONTRACT_TYPE       ,
ACTIVITY_DATE      ,
ship_land_date ,
BUYER               ,
SELLER            ,
OUR_CONTRACT_REF_NO ,
CP_CONTRACT_REF_NO ,
GMR_REF_NO         ,
SHIPMENT_DATE      ,
WEIGHING_AND_SAMPLING_REF_NO  ,
PRODUCT_AND_QUALITY ,
ASSAYER      ,
ASSAY_TYPE     ,
EXCHANGE_OF_ASSAYS ,
LOT_NO      ,
NO_OF_SUBLOTS,
INTERNAL_DOC_REF_NO 
)
SELECT VPCI.INTERNAL_CONTRACT_ITEM_REF_NO AS INTERNAL_CONTRACT_ITEM_REF_NO,
       ASH.ASSAY_REF_NO AS ASSAY_REFNO,
       ASH.INTERNAL_GMR_REF_NO AS INTERNAL_GMR_REF_NO,
       GMR.CONTRACT_TYPE AS CONTRACT_TYPE,AXS.EFF_DATE AS ACTIVITY_DATE,
       (CASE
           WHEN ash.assay_type = ''Provisional Assay''
              THEN (SELECT vd.loading_date
                      FROM vd_voyage_detail vd
                     WHERE vd.internal_gmr_ref_no = gmr.internal_gmr_ref_no)
           ELSE (CASE
                    WHEN (SELECT agmr.action_no AS actionno
                            FROM agmr_action_gmr agmr
                           WHERE agmr.internal_gmr_ref_no =
                                                       gmr.internal_gmr_ref_no
                             AND agmr.is_deleted = ''N''
                             AND agmr.is_final_weight = ''Y'') = 1
                       THEN (SELECT vd.loading_date
                               FROM vd_voyage_detail vd
                              WHERE vd.internal_gmr_ref_no =
                                                       gmr.internal_gmr_ref_no)
                    ELSE (SELECT wrd.storage_date
                            FROM wrd_warehouse_receipt_detail wrd
                           WHERE wrd.internal_gmr_ref_no =
                                                       gmr.internal_gmr_ref_no)
                 END
                )
        END
       ) ship_land_date,
       (CASE
           WHEN GMR.CONTRACT_TYPE = ''Sales''
              THEN VPCI.CP_NAME
           ELSE VPCI.CORPORATE_NAME
        END
       ) BUYER,
       (CASE
           WHEN GMR.CONTRACT_TYPE = ''Purchase''
              THEN VPCI.CP_NAME
           ELSE VPCI.CORPORATE_NAME
        END
       ) SELLER,
       VPCI.CONTRACT_REF_NO AS OUR_CONTRACT_REF_NO,
       VPCI.CP_CONTRACT_REF_NO AS CP_CONTRACT_REF_NO,
       GMR.GMR_REF_NO AS GMR_REF_NO, GMR.EFF_DATE AS SHIPMENT_DATE,
       (SELECT ASH1.ASSAY_REF_NO
          FROM ASH_ASSAY_HEADER ASH1
         WHERE ASH1.ASSAY_TYPE =
                   ''Weighing and Sampling Assay''
           AND ASH1.IS_ACTIVE = ''Y''
           AND ASH1.IS_DELETE = ''N''
           AND ASH1.INTERNAL_CONTRACT_REF_NO = VPCI.INTERNAL_CONTRACT_REF_NO
           AND ASH1.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
           AND ASH1.INTERNAL_GRD_REF_NO = ASH.INTERNAL_GRD_REF_NO)
                                                 WEIGHING_AND_SAMPLING_REF_NO,
        (VPCI.PRODUCT_NAME
           || '' , ''
           || VPCI.QUALITY_NAME
       ) PRODUCT_AND_QUALITY,
       BGM.BP_GROUP_NAME as ASSAYER,
       ASH.ASSAY_TYPE AS ASSAY_TYPE,
       ASH.USE_FOR_FINALIZATION AS EXCHANGE_OF_ASSAYS, ASH.LOT_NO AS LOT_NO,
       ASH.NO_OF_SUBLOTS AS NO_OF_SUBLOTS,?
  FROM ASH_ASSAY_HEADER ASH,
       AXS_ACTION_SUMMARY AXS,
       V_PCI VPCI,
       GMR_GOODS_MOVEMENT_RECORD GMR,
       BGM_BP_GROUP_MASTER bgm
 WHERE ASH.INTERNAL_ACTION_REF_NO = AXS.INTERNAL_ACTION_REF_NO
   AND ASH.INTERNAL_CONTRACT_REF_NO = VPCI.INTERNAL_CONTRACT_REF_NO
   AND GMR.INTERNAL_CONTRACT_REF_NO = VPCI.INTERNAL_CONTRACT_REF_NO
   AND ASH.INTERNAL_GMR_REF_NO = GMR.INTERNAL_GMR_REF_NO
   AND BGM.BP_GROUP_ID(+) = ASH.ASSAYER
  AND ASH.ASH_ID = ?'
  where DGM_ID='DGM-AS' and DOC_ID='CREATE_ASSAY';