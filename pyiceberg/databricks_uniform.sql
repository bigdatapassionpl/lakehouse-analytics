
ALTER TABLE radek.default.customer
SET TBLPROPERTIES ('delta.enableDeletionVectors' = 'false');

REORG TABLE radek.default.customer APPLY (PURGE);

ALTER TABLE radek.default.customer
SET TBLPROPERTIES (
  'delta.columnMapping.mode' = 'name',
  'delta.enableIcebergCompatV2' = 'true',
  'delta.universalFormat.enabledFormats' = 'iceberg'
);

OPTIMIZE radek.default.customer;

-- DESCRIBE EXTENDED radek.default.customer;

SHOW TBLPROPERTIES radek.default.customer;
