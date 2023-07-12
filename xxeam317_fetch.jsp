<%@ page import='java.sql.ResultSet'%>
<%@ page import='java.sql.Statement'%>
<%@ page import='java.sql.Connection'%>
<%@ page import='java.sql.SQLException'%>
<%@ page import='java.util.*'%>
<%@ page import='java.text.*'%>
<%@ page import='java.io.*'%>
<%@ page import='java.nio.charset.*'%>

<%@ page import='javax.servlet.http.HttpServletRequest'%>
<%@ page import='oracle.apps.fnd.sso.Utils'%>


<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%
    
    //--Подключение к БД
    Connection conn = null;
    Statement cStmt = null;
    String tcfHost = null;
    ResultSet resultSet = null;
    ResultSet resultRouting = null;
	
	try{
        conn = Utils.getConnection();
        cStmt = conn.createStatement();
        //out.println("<h1>"+Utils.getConnection()+"</h1>");
    } catch(Exception e){
        out.println("</h1>Ошибка при попытке подключения: "+e+"<h1>");
    }
    
    //Подключение для разработки
    /*String jdbcUrl = "jdbc:oracle:thin:@dprod.local.uralkali.com:1561:dprod";
    String userid = "xxeam";
    String password = "xxeam";
	*/
    /*
    String jdbcUrl = "jdbc:oracle:thin:@t8-clone-06.uralkali.com:1521/ebs_plan";
    String userid = "apps";
    String password = "apps";
	
    try {
          OracleDataSource ds;
          ds = new OracleDataSource();
          ds.setURL(jdbcUrl);
          conn = ds.getConnection(userid, password);
    }catch ( SQLException ex )  {
          System.out.println("Invalid user credentials");
    }
    cStmt = conn.createStatement();
	*/
    
    String type = request.getParameter("type").toString();
    String user_id = null;
    
    if (request.getParameter("user_id") != null){
        user_id = request.getParameter("user_id").toString();
    }
    
    System.out.println(type);
	
    StringBuilder sb = new StringBuilder();
    BufferedReader reader = request.getReader();
    String line;
    while ((line = reader.readLine()) != null) {
      sb.append(line);
    }
	
    String requestBody = sb.toString();
    
//    try {
//        byte[] utf8Bytes = requestBody.getBytes("iso-8859-5");
//        byte[] defaultBytes = requestBody.getBytes();
//    
//        requestBody = new String(utf8Bytes, "utf-8");
//    } 
//    catch (UnsupportedEncodingException e) {
//        
//    }
    
	//--------------------------
	try{
		requestBody = requestBody.substring(1, requestBody.length() - 1);
        System.out.println("req: " + requestBody);
		
		String[] arr = requestBody.split(",");
		int[] reqNumArray = new int[arr.length];
                
		for (int i = 0; i < arr.length; i++) {
			reqNumArray[i] = Integer.parseInt(arr[i].trim());
		}
		
		byte[] utf8bytes = new byte[reqNumArray.length];
		for(int i = 0; i < reqNumArray.length; i++)
		{
			utf8bytes[i] = (byte) reqNumArray[i];
		}
		
		requestBody = new String(utf8bytes, "UTF-8");
				
		System.out.println(requestBody);
	} catch(Exception e) {
		e.printStackTrace();
	}
    //------------------------
    
    //Получение списка организаций
    if(type.equals("organizations")) {
        String query = "SELECT "+
           "'['||LISTAGG('{\"code\":' || ORGANIZATION_ID || ', \"name\":\"'|| code||' '||alias||' '||DECODE(ORG_TYPE, 'M', 'Рудник', 'Поверхность')||'\"}', ',\n') "+
           "WITHIN GROUP (ORDER BY CODE)||']' AS DATA "+
           "FROM xxeam.XXMOBILE_ORGANIZATIONS_V";
        try {
            ResultSet rs = cStmt.executeQuery(query);
            rs.next();
            out.println("{\"data\":"+rs.getString("data")+"}");
        } catch (Exception e){
            out.println("{'data': 'error_"+e+"'}");
        }
    }
    
    //Получение списка техкарт
    if(type.equals("techcards")) {
        String org_id = request.getParameter("org_id").toString();
        
        String query = "SELECT msi.segment1 AS NAME, ROUTING_SEQUENCE_ID AS ID "+
        "FROM apps.BOM_OPERATIONAL_ROUTINGS bor "+
        "INNER JOIN apps.mtl_system_items msi ON "+
        "           bor.assembly_item_id = msi.inventory_item_id "+
        "       and bor.ORGANIZATION_ID  = msi.ORGANIZATION_ID "+
        "       and msi.attribute9       = 'Опросный лист' "+
        "WHERE msi.ORGANIZATION_ID = " + org_id +
        " ORDER BY msi.segment1";
        
        
        String result = "[";
        try {
            ResultSet rs = cStmt.executeQuery(query);
            
            while (rs.next()) {
                if (!result.equals("[")){
                    result += ", ";
                }
                result += "{\"ID\": " + rs.getString("ID") + ", \"NAME\": \"" + rs.getString("NAME") + "\"}";
            }
            
            result += "]";
            
            out.println("{\"data\":" + result + "}");
        } catch (Exception e){
            out.println("{'data': 'error_"+e+"'}");
        }
    }
	
	//Получение организации техкарты
    if(type.equals("get_org_id_by_techcard_id")) {
        String techcard_id = request.getParameter("techcard_id").toString();
        
        String query = "SELECT msi.ORGANIZATION_ID AS ID "+
        "FROM apps.BOM_OPERATIONAL_ROUTINGS bor "+
        "INNER JOIN apps.mtl_system_items msi ON "+
        "           bor.assembly_item_id = msi.inventory_item_id "+
        "       and bor.ORGANIZATION_ID  = msi.ORGANIZATION_ID "+
        "       and msi.attribute9       = 'Опросный лист' "+
        "WHERE ROUTING_SEQUENCE_ID = " + techcard_id +
        "  AND rownum = 1 "+
		"ORDER BY msi.segment1";
        
        
        String result = "[";
        try {
            ResultSet rs = cStmt.executeQuery(query);
            
            while (rs.next()) {
                result = "{\"ID\": " + rs.getString("ID") + "}";
            }
            
            out.println("{\"data\":" + result + "}");
        } catch (Exception e){
            out.println("{'data': 'error_"+e+"'}");
        }
    }
    
    //Получение схемы
    if(type.equals("scheme")) {
        String techcard_id = request.getParameter("techcard_id").toString();
        byte[] pre_result_bytes = null;
        
        String query = "SELECT TO_CLOB(FILE_DATA) AS DATA " +
        "FROM   fnd_attached_docs_form_vl ad " +
        "INNER JOIN apps.fnd_lobs l ON file_id = media_id " +
        "INNER JOIN FND_DOCUMENT_CATEGORIES_TL DCT ON dct.USER_NAME = 'XXEAM: Схема оборудования для МП' AND dct.LANGUAGE = 'RU' AND dct.CATEGORY_ID = ad.CATEGORY_ID " +
        "WHERE  1=1  " +
        "       AND (security_type = 4 OR publish_flag = 'Y' OR (security_type = 1 AND security_id = 124)) " +
        "       AND PK1_VALUE = '"+techcard_id+"' " +
        "       AND ROWNUM = 1 " +
        "ORDER  BY ad.CREATION_DATE DESC";
        
        
        String query_points = "SELECT JSON_OBJECT('NAME' VALUE NAME, 'DESCRIPTION' VALUE LISTAGG(DESCRIPTION, ',\n') WITHIN GROUP(ORDER BY SEQ_ID ASC), 'SEQ_IDS' VALUE JSON_ARRAYAGG( SEQ_ID ORDER BY SEQ_ID RETURNING VARCHAR2(25)), 'PROPERTIES' VALUE JSON_OBJECT( 'X' VALUE SUBSTR(PROPERTIES, 0, INSTR(PROPERTIES, ':')-1), 'Y' VALUE SUBSTR(PROPERTIES, INSTR(PROPERTIES, ':')+1, INSTR(PROPERTIES, 'x')-INSTR(PROPERTIES, ':')-1), 'SIZE' VALUE SUBSTR(PROPERTIES, INSTR(PROPERTIES, 'x')+1) ) ) AS POINT_BODY FROM   (SELECT bos.ROUTING_SEQUENCE_ID   AS TECHCARD_ID, bos.OPERATION_SEQUENCE_ID AS OPERATION_ID, bos.OPERATION_SEQ_NUM     AS SEQ_ID, bos.ATTRIBUTE1            AS NAME, bos.ATTRIBUTE3            AS PROPERTIES, bos.OPERATION_DESCRIPTION AS DESCRIPTION FROM   bom_operation_sequences bos, bom_departments         bd, bom_standard_operations bso WHERE  bos.department_id = bd.department_id AND bos.standard_operation_id = bso.standard_operation_id(+) AND NVL(bos.disable_date, SYSDATE) >= SYSDATE AND bos.ATTRIBUTE1 IS NOT NULL AND routing_sequence_id = "+techcard_id+" ORDER  BY OPERATION_SEQ_NUM) GROUP  BY NAME, TECHCARD_ID, PROPERTIES";
        
        try {
            ResultSet rs = cStmt.executeQuery(query);
            
            while (rs.next ()) {
                //
                BufferedReader stringReader = new BufferedReader(rs.getClob("data").getCharacterStream());
                String singleLine = null;
                StringBuffer strBuff = new StringBuffer();
                while ((singleLine = stringReader.readLine()) != null) {
                    strBuff.append(singleLine);
                }
                
                String pre_result = strBuff.toString();//.replace("\"","\\\"");
                
                pre_result_bytes = pre_result.getBytes();
            }
            
            ResultSet rs_points = cStmt.executeQuery(query_points);
            
            ArrayList<String> points_json = new ArrayList<String>();
            
            while (rs_points.next()) {
                points_json.add(rs_points.getString("POINT_BODY"));
                System.out.println(rs_points.getString("POINT_BODY"));
            }
            
            //System.out.println("{\"data\": {\"scheme\":"+Arrays.toString(pre_result_bytes)+", \"points\": " + points_json.toString() + "}}");
            
            out.println("{\"data\": {\"scheme\":"+Arrays.toString(pre_result_bytes)+", \"points\": " + points_json.toString() + "}}");
            
        } catch (Exception e){
            out.println("{'data': 'error_"+e+"'}");
        }
    }
    
    if(type.equals("save")) {
		System.out.println(requestBody);
		
        String query = "DECLARE " +
                       "  p_message_clob CLOB := '" + requestBody + "'; " +
                       "BEGIN " +
                       "  XXEAM.XXEAM317_POINTS_EDITOR.save_points(p_message_clob, " + request.getParameter("techcard_id").toString() + ", " + user_id + "); " +
                       "END; ";
					   
		//-------ЛОГ--------------
		String log_query = "DECLARE " +
					   "  p_message_clob CLOB := '" + requestBody + "'; " +
					   "BEGIN " +
					   "  XXEAM.XXEAM317_POINTS_EDITOR.LOG('" + type + "', p_message_clob, " + user_id + "); " +
					   "END; ";
		try {
			cStmt.executeQuery(log_query);
		} catch (Exception e){
			e.printStackTrace(System.out);
		}
		//------------------------
		
        try {
            cStmt.executeQuery(query);
            out.println("{\"data\": \"S\"}");
        } catch (Exception e){
            out.println("{'data': 'error_"+e+"'}");
			e.printStackTrace(System.out);
        }
    }


%>