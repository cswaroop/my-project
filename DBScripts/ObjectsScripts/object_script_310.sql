ALTER TABLE GRD_GOODS_RECORD_DETAIL ADD
(
CONSTRAINT FK_GRD_SOURCE_INT_POOL_REF_NO FOREIGN KEY (SOURCE_INT_POOL_REF_NO) REFERENCES PM_POOL_MASTER (POOL_ID)
);

ALTER TABLE AGRD_ACTION_GRD ADD
(
CONSTRAINT FK_AGRD_SOURCE_INT_POOL_NO FOREIGN KEY (SOURCE_INT_POOL_REF_NO) REFERENCES PM_POOL_MASTER (POOL_ID)
);

ALTER TABLE GRD_GOODS_RECORD_DETAIL ADD
(
POOL_ID VARCHAR2(15),
CONSTRAINT FK_GRD_POOL_ID FOREIGN KEY (POOL_ID) REFERENCES PM_POOL_MASTER (POOL_ID)
);

ALTER TABLE GRDUL_GOODS_RECORD_DETAIL_UL ADD
(
POOL_ID VARCHAR2(15)
);