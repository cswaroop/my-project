update DGM_DOCUMENT_GENERATION_MASTER set FETCH_QUERY=
    'INSERT INTO WNS_ASSAY_CHILD_D (
SUBLOTORDERING,
SUBLOT_REF_NO ,
NET_WET_WEIGHT,
DEDUCTIBLE_CONTENT,
DEDUCTIBLE_CONTENT_UOM,
DEDUCTIBLE_CONTENT_WEIGHT,
NET_DRY_WEIGHT,
WEIGHT_UNIT_NAME,
DEDUCTIBLE_CONTENT_DETALS,
REMARK1,
REMARK2,
INTERNAL_DOC_REF_NO            
)
select  tt.SUBLOTORDERING,
  tt.SUBLOT_REF_NO,
  tt.NET_WET_WEIGHT,
  tt.DEDUCTIBLE_CONTENT,
  tt.DEDUCTIBLE_CONTENT_UOM,
  tt.DEDUCTIBLE_CONTENT_WEIGHT,
  tt.NET_DRY_WEIGHT,
  tt.WEIGHT_UNIT_NAME,
  tt.DEDUCTIBLE_CONTENT_DETALS,
  tt.REMARK1,
  tt.REMARK2,
   tt.INTERNAL_DOC_REF_NO 
from
(select 
  rank() OVER (partition by t.SUBLOT_REF_NO ORDER BY t.DEDUCTIBLE_CONTENT desc,t.deductible_content_uom)rank,
  t.SUBLOTORDERING,
  t.SUBLOT_REF_NO,
  t.NET_WET_WEIGHT,
  t.DEDUCTIBLE_CONTENT,
  t.DEDUCTIBLE_CONTENT_UOM,
  t.DEDUCTIBLE_CONTENT_WEIGHT,
  t.NET_DRY_WEIGHT,
  t.WEIGHT_UNIT_NAME,
  t.DEDUCTIBLE_CONTENT_DETALS,
  t.REMARK1,
  t.REMARK2,
  t.INTERNAL_DOC_REF_NO 
from
(SELECT 
       ASM.ORDERING AS SUBLOTORDERING,
       ASM.SUB_LOT_NO AS SUBLOT_REF_NO,
       ASM.NET_WEIGHT AS NET_WET_WEIGHT,
       SUM((CASE
             WHEN NVL(PQCA.IS_DEDUCTIBLE, ''N'') = ''Y'' THEN
              PQCA.TYPICAL
             ELSE
              0
           END)) DEDUCTIBLE_CONTENT,
       RM.RATIO_NAME AS DEDUCTIBLE_CONTENT_UOM,
       (SUM((CASE
              WHEN NVL(PQCA.IS_DEDUCTIBLE, ''N'') = ''Y'' THEN
               PQCA.TYPICAL
              ELSE
               0
            END)) * (CASE
         WHEN RM.RATIO_NAME = ''%'' THEN
          (ASM.NET_WEIGHT / 100)
         ELSE
          0
       END)) DEDUCTIBLE_CONTENT_WEIGHT,
       ASM.DRY_WEIGHT AS NET_DRY_WEIGHT,
       QUM.QTY_UNIT AS WEIGHT_UNIT_NAME,
       STRAGG(((CASE
                WHEN NVL(PQCA.IS_DEDUCTIBLE, ''N'') = ''Y'' THEN
                 PQCA.TYPICAL || '''' || RM.RATIO_NAME || '''' || AML.ATTRIBUTE_DESC
                ELSE
                 NULL
              END))) DEDUCTIBLE_CONTENT_DETALS,
         ASM.REMARK_ONE as REMARK1,
         ASM.REMARK_TWO as REMARK2,           
       ? as INTERNAL_DOC_REF_NO
  FROM ASM_ASSAY_SUBLOT_MAPPING    ASM,
       QUM_QUANTITY_UNIT_MASTER    QUM,
       RM_RATIO_MASTER             RM,
       PQCA_PQ_CHEMICAL_ATTRIBUTES PQCA,
       AML_ATTRIBUTE_MASTER_LIST   AML
 WHERE ASM.NET_WEIGHT_UNIT = QUM.QTY_UNIT_ID(+)
   AND ASM.ASM_ID = PQCA.ASM_ID
   AND PQCA.UNIT_OF_MEASURE = RM.RATIO_ID
   AND PQCA.ELEMENT_ID = AML.ATTRIBUTE_ID
   AND ASM.ASH_ID = ?
 GROUP BY ASM.ORDERING,
          ASM.SUB_LOT_NO,
          ASM.NET_WEIGHT,
          RM.RATIO_NAME,
          ASM.DRY_WEIGHT,
          QUM.QTY_UNIT,
          ASM.REMARK_ONE,
          ASM.REMARK_TWO)t
           )tt
where tt.rank =1'
where DGM_ID='DGM-WNSC' and DOC_ID='CREATE_WNS_ASSAY';
