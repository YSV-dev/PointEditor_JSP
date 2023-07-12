CREATE TABLE xxeam.xxeam317_fetch_log
( 
  package_id NUMBER NOT NULL,
  type_name VARCHAR2(50),
  message CLOB,
  send_date DATE DEFAULT SYSDATE,
  user_id NUMBER 
);

CREATE SEQUENCE xxeam.xxeam317_fetch_seq
  MINVALUE 0
  MAXVALUE 999999999999999999999999999
  START WITH 0
  INCREMENT BY 1
  CACHE 20;

DECLARE
BEGIN
  AD_ZD_TABLE.UPGRADE( 'XXEAM', 'XXEAM317_FETCH_LOG');
END;
/