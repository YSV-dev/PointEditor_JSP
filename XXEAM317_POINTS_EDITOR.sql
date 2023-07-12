CREATE OR REPLACE PACKAGE XXEAM.XXEAM317_POINTS_EDITOR IS

  -- Author  : YANISHEN_SV
  -- Created : 29.03.2023 15:44:42
  
	PROCEDURE save_points(P_JSON_REQ CLOB, p_techcard_id NUMBER, p_user_id NUMBER);
  
  PROCEDURE LOG(p_type VARCHAR2, p_msg CLOB, p_user_id NUMBER);
  
END XXEAM317_POINTS_EDITOR;
/
CREATE OR REPLACE PACKAGE BODY XXEAM.XXEAM317_POINTS_EDITOR IS

	PROCEDURE save_points(P_JSON_REQ CLOB, p_techcard_id NUMBER, p_user_id NUMBER) IS
		CURSOR JSON_DATA(P_JSON_REQ CLOB) IS
			SELECT techcard,
						 point_name,
						 x,
						 y,
						 size_
			FROM   JSON_TABLE(P_JSON_REQ, '$.data[*]'
												 COLUMNS(techcard VARCHAR2(256) PATH
																 '$.techcard', point_name
																	VARCHAR2(256) PATH
																	'$.name', x VARCHAR2(256) PATH
																	'$.x', y VARCHAR2(256) PATH '$.y', size_
																	VARCHAR2(256) PATH
																	'$.size')) jh
			WHERE  JSON_EXISTS(P_JSON_REQ, '$.data');
	BEGIN
	
		--очищение всех меток от информации о размещении на схеме
		UPDATE apps.bom_operation_sequences bos
		SET    bos.ATTRIBUTE3 = NULL
		WHERE  bos.routing_sequence_id = p_techcard_id
					 AND bos.ATTRIBUTE_CATEGORY = 'XXEAM_OPROS';
	
		FOR p IN JSON_DATA(P_JSON_REQ)
		LOOP
			UPDATE apps.bom_operation_sequences bos
			SET    bos.ATTRIBUTE2 = to_char(SYSDATE, 'dd.mm.yyyy hh24:mi:ss'),
             bos.ATTRIBUTE3 = p.x || ':' || p.y || 'x' || p.size_,
             bos.ATTRIBUTE4 = p_user_id
			WHERE  bos.routing_sequence_id = p.techcard
						 AND bos.ATTRIBUTE1 = p.point_name
						 AND bos.ATTRIBUTE1 IS NOT NULL;
		END LOOP;
	
		COMMIT;
	END;  
  
  PROCEDURE LOG(p_type VARCHAR2, p_msg CLOB, p_user_id NUMBER) IS
  BEGIN
    INSERT INTO xxeam.xxeam317_fetch_log
    (package_id, type_name, message, user_id)
    VALUES
    (xxeam.xxeam317_fetch_seq.nextval, p_type, p_msg, p_user_id);
    
    DELETE FROM xxeam.xxeam317_fetch_log
    WHERE send_date<SYSDATE-24*7;
    
    COMMIT;
  END;
END XXEAM317_POINTS_EDITOR;
/
