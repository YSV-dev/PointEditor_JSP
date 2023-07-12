<%@ page import='java.sql.ResultSet'%>
<%@ page import='java.sql.Statement'%>
<%@ page import='java.sql.Connection'%>
<%@ page import='java.sql.SQLException'%>
<%@ page import='java.util.*'%>
<%@ page import='java.text.*'%>

<%@ page import='javax.servlet.http.HttpServletRequest'%>

<%@ page contentType="text/html;charset=iso-8859-5" language="java" pageEncoding="iso-8859-5"%>

<%
    String get_user_id = null;
    String get_techcard_id = null;
    
    if (request.getParameter("user_id") != null){
        get_user_id = request.getParameter("user_id").toString();
    }
	
	if (request.getParameter("techcard_id") != null){
        get_techcard_id = request.getParameter("techcard_id").toString();
    }
%>

<!DOCTYPE HTML>
<html  dir="LTR" lang="ru">
  <head>
    <!--Кодировка для разработки-->
    <!--<meta charset="utf-8">-->
    
    <!--Кодировка документа должна быть UTF-8 с BOM	                                   -->
	<!--Использовать синтаксис не выше es5, на оракле es6 отказывается работать в Edge -->

    <link href="xxeam317_null.css" rel="stylesheet" >
    <link href="xxeam317_style.css" rel="stylesheet" >
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<!--meta charset="iso-8859-5"-->
    <title>Редактор схем МП УК: Техобслуживание</title>
  </head>
  
  <input type='hidden' id='user_id' value='<%=get_user_id%>'>
  <input type='hidden' id='techcard_id' value='<%=get_techcard_id%>'>
  <input type='hidden' id='org_id' value='null'>
  
  <script>
    const loading_gif = '<img src="data:image/gif;base64,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" />';
  </script>
  
  <script src="xxeam317_jQuery.js"></script>
  
  <body>
    <div class="sub-modal-bg" id='modal-frame' style='display: none;'>
        <div class="sub-modal-win">
            <div style='background: gray;'><center><b style='color: red;' id='sub-modal-title'>NONAME</b></center></div>
            <div style='padding: 10px 10px 5px 10px;'>
                <center><p id='sub-modal-info'>NODESCRIPTION</p></center>
                <div class='button-bar' id='sub-modal-btns-yesno'><center><button id='sub-modal-btn-yes'>Да</button><button id='sub-modal-btn-no'>Нет</button></center></div>
                <div class='button-bar' id='sub-modal-btns-ok'><center><button id='sub-modal-btn-ok'>ОК</button></center></div>
            </div>
        </div>
    </div>
  
    <div class='bg'>
        <div class='content'>
            
            <div id='filter-container' class='filter' style='width: 100%'>
                <table>
                    <tr>
                        <td>Организация: </td><td><p id='org_list_loading'>Загрузка...</p><select style='display: none; width: 450px;' id='org_id_select'></select></td>
                    </tr>
                    <tr>
                        <td>Техкарта: </td><td><p id='techcard_list_loading'>Загрузка...</p><select style='display: none; width: 450px;' id='techcard_select'></select></td>
                        <td><p style='color: red; display: none;' id='techcard_nf_l'>СХЕМА НЕ ЗАГРУЖЕНА!</p></td>
                    </tr>
                </table>
                <div class='button-bar'>
					<div class='button-block'>
						<button title="Перезагрузить схему" id='refresh_btn'><svg fill="#000000" height="15px" width="15px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 489.698 489.698" xml:space="preserve"> <g> <g> <path d="M468.999,227.774c-11.4,0-20.8,8.3-20.8,19.8c-1,74.9-44.2,142.6-110.3,178.9c-99.6,54.7-216,5.6-260.6-61l62.9,13.1 c10.4,2.1,21.8-4.2,23.9-15.6c2.1-10.4-4.2-21.8-15.6-23.9l-123.7-26c-7.2-1.7-26.1,3.5-23.9,22.9l15.6,124.8 c1,10.4,9.4,17.7,19.8,17.7c15.5,0,21.8-11.4,20.8-22.9l-7.3-60.9c101.1,121.3,229.4,104.4,306.8,69.3 c80.1-42.7,131.1-124.8,132.1-215.4C488.799,237.174,480.399,227.774,468.999,227.774z"/> <path d="M20.599,261.874c11.4,0,20.8-8.3,20.8-19.8c1-74.9,44.2-142.6,110.3-178.9c99.6-54.7,216-5.6,260.6,61l-62.9-13.1 c-10.4-2.1-21.8,4.2-23.9,15.6c-2.1,10.4,4.2,21.8,15.6,23.9l123.8,26c7.2,1.7,26.1-3.5,23.9-22.9l-15.6-124.8 c-1-10.4-9.4-17.7-19.8-17.7c-15.5,0-21.8,11.4-20.8,22.9l7.2,60.9c-101.1-121.2-229.4-104.4-306.8-69.2 c-80.1,42.6-131.1,124.8-132.2,215.3C0.799,252.574,9.199,261.874,20.599,261.874z"/> </g> </g> </svg></button>
						<button title="Сохранить" id='save_btn'><svg width="15px" height="15px" viewBox="4 4 16 16" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M17 20.75H7C6.27065 20.75 5.57118 20.4603 5.05546 19.9445C4.53973 19.4288 4.25 18.7293 4.25 18V6C4.25 5.27065 4.53973 4.57118 5.05546 4.05546C5.57118 3.53973 6.27065 3.25 7 3.25H14.5C14.6988 3.25018 14.8895 3.32931 15.03 3.47L19.53 8C19.6707 8.14052 19.7498 8.33115 19.75 8.53V18C19.75 18.7293 19.4603 19.4288 18.9445 19.9445C18.4288 20.4603 17.7293 20.75 17 20.75ZM7 4.75C6.66848 4.75 6.35054 4.8817 6.11612 5.11612C5.8817 5.35054 5.75 5.66848 5.75 6V18C5.75 18.3315 5.8817 18.6495 6.11612 18.8839C6.35054 19.1183 6.66848 19.25 7 19.25H17C17.3315 19.25 17.6495 19.1183 17.8839 18.8839C18.1183 18.6495 18.25 18.3315 18.25 18V8.81L14.19 4.75H7Z" fill="#000000"/> <path d="M16.75 20H15.25V13.75H8.75V20H7.25V13.5C7.25 13.1685 7.3817 12.8505 7.61612 12.6161C7.85054 12.3817 8.16848 12.25 8.5 12.25H15.5C15.8315 12.25 16.1495 12.3817 16.3839 12.6161C16.6183 12.8505 16.75 13.1685 16.75 13.5V20Z" fill="#000000"/> <path d="M12.47 8.75H8.53001C8.3606 8.74869 8.19311 8.71403 8.0371 8.64799C7.88109 8.58195 7.73962 8.48582 7.62076 8.36511C7.5019 8.24439 7.40798 8.10144 7.34437 7.94443C7.28075 7.78741 7.24869 7.61941 7.25001 7.45V4H8.75001V7.25H12.25V4H13.75V7.45C13.7513 7.61941 13.7193 7.78741 13.6557 7.94443C13.592 8.10144 13.4981 8.24439 13.3793 8.36511C13.2604 8.48582 13.1189 8.58195 12.9629 8.64799C12.8069 8.71403 12.6394 8.74869 12.47 8.75Z" fill="#000000"/> </svg></button>
					</div>
					<div class='button-block'>
						<button title="Уменьшить" onclick='resize(0.9)'><svg height="15px" viewBox="0 0 32 32" width="15px" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><path d="m0 0h32v32h-32z"/><path d="m15 0c8.2842712 0 15 6.71572875 15 15 0 3.7818764-1.3995847 7.2368622-3.7090554 9.8752589l4.6588029 4.660275c.3905243.3905243.3905243 1.0236893 0 1.4142136s-1.0236893.3905243-1.4142136 0l-4.660275-4.6588029c-2.6383967 2.3094707-6.0933825 3.7090554-9.8752589 3.7090554-8.28427125 0-15-6.7157288-15-15 0-8.28427125 6.71572875-15 15-15zm0 2c-7.17970175 0-13 5.82029825-13 13 0 7.1797017 5.82029825 13 13 13 7.1797017 0 13-5.8202983 13-13 0-7.17970175-5.8202983-13-13-13zm5 12c.5522847 0 1 .4477153 1 1s-.4477153 1-1 1h-10c-.55228475 0-1-.4477153-1-1s.44771525-1 1-1z" fill="#000" fill-rule="nonzero"/></g></svg></button>
						<button title="Номировать размер" onclick='autoResize()'><svg height="15px" viewBox="0 0 32 32" width="15px" version="1.1" xmlns="http://www.w3.org/2000/svg"> <defs id="defs48" /> <sodipodi:namedview id="namedview46" pagecolor="#ffffff" bordercolor="#000000" borderopacity="0.25" inkscape:showpageshadow="2" inkscape:pageopacity="0.0" inkscape:pagecheckerboard="0" inkscape:deskcolor="#d1d1d1" showgrid="false" inkscape:zoom="7.375" inkscape:cx="4.8813559" inkscape:cy="2.1694915" inkscape:window-width="1440" inkscape:window-height="837" inkscape:window-x="1912" inkscape:window-y="-8" inkscape:window-maximized="1" inkscape:current-layer="text491" /> <g fill="none" fill-rule="evenodd" id="g42"> <path d="m0 0h32v32h-32z" id="path38" /> <path d="m 15,0 c 8.284271,0 15,6.7157287 15,15 0,3.781876 -1.399585,7.236862 -3.709055,9.875259 l 4.658802,4.660275 c 0.390525,0.390524 0.390525,1.023689 0,1.414213 -0.390524,0.390525 -1.023689,0.390525 -1.414213,0 L 24.875259,26.290945 C 22.236862,28.600415 18.781876,30 15,30 6.7157287,30 0,23.284271 0,15 0,6.7157287 6.7157287,0 15,0 Z m 0,2 C 7.8202982,2 2,7.8202982 2,15 2,22.179702 7.8202982,28 15,28 22.179702,28 28,22.179702 28,15 28,7.8202982 22.179702,2 15,2 Z" fill="#000000" fill-rule="nonzero" id="path40" sodipodi:nodetypes="ssccsccssssssss" /> <g aria-label="A" id="text358" style="font-size:24px;fill:#000000"> <g aria-label="W" id="text491" style="font-size:18.6667px"> <path d="M 23.313437,8.2588701 19.786087,21.830509 H 17.753531 L 14.900662,10.564864 12.111594,21.830509 H 10.124611 L 6.533459,8.2588701 H 8.3837227 L 11.236592,19.542745 14.043889,8.2588701 h 1.832035 L 18.710564,19.65212 21.545205,8.2588701 Z" id="path493" /> </g> </g> </g> </svg></button>
						<button title="Увеличить" onclick='resize(1.1)'><svg height="15px" viewBox="0 0 32 32" width="15px" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><path d="m0 0h32v32h-32z"/><path d="m15 0c8.2842712 0 15 6.71572875 15 15 0 3.7818764-1.3995847 7.2368622-3.7090554 9.8752589l4.6588029 4.660275c.3905243.3905243.3905243 1.0236893 0 1.4142136s-1.0236893.3905243-1.4142136 0l-4.660275-4.6588029c-2.6383967 2.3094707-6.0933825 3.7090554-9.8752589 3.7090554-8.28427125 0-15-6.7157288-15-15 0-8.28427125 6.71572875-15 15-15zm0 2c-7.17970175 0-13 5.82029825-13 13 0 7.1797017 5.82029825 13 13 13 7.1797017 0 13-5.8202983 13-13 0-7.17970175-5.8202983-13-13-13zm0 7c.5522847 0 1 .44771525 1 1v4h4c.5522847 0 1 .4477153 1 1s-.4477153 1-1 1h-4v4c0 .5522847-.4477153 1-1 1s-1-.4477153-1-1v-4h-4c-.55228475 0-1-.4477153-1-1s.44771525-1 1-1h4v-4c0-.55228475.4477153-1 1-1z" fill="#000" fill-rule="nonzero"/></g></svg></button>
						<button title="Авто-нормирование" id='auto_resize_mode_btn' onclick='setAutoResizeMode()'><svg height="15px" viewBox="0 0 32 32" width="15px" xmlns="http://www.w3.org/2000/svg"> <defs id="defs48" /> <sodipodi:namedview id="namedview46" pagecolor="#ffffff" bordercolor="#000000" borderopacity="0.25" inkscape:showpageshadow="2" inkscape:pageopacity="0.0" inkscape:pagecheckerboard="0" inkscape:deskcolor="#d1d1d1" showgrid="false" inkscape:zoom="7.375" inkscape:cx="4.8813559" inkscape:cy="2.1694915" inkscape:window-width="1440" inkscape:window-height="837" inkscape:window-x="1912" inkscape:window-y="-8" inkscape:window-maximized="1" inkscape:current-layer="g42" /> <g fill="none" fill-rule="evenodd" id="g42"> <path d="m0 0h32v32h-32z" id="path38" /> <path d="m 15,0 c 8.284271,0 15,6.7157287 15,15 0,3.781876 -1.399585,7.236862 -3.709055,9.875259 l 4.658802,4.660275 c 0.390525,0.390524 0.390525,1.023689 0,1.414213 -0.390524,0.390525 -1.023689,0.390525 -1.414213,0 L 24.875259,26.290945 C 22.236862,28.600415 18.781876,30 15,30 6.7157287,30 0,23.284271 0,15 0,6.7157287 6.7157287,0 15,0 Z m 0,2 C 7.8202982,2 2,7.8202982 2,15 2,22.179702 7.8202982,28 15,28 22.179702,28 28,22.179702 28,15 28,7.8202982 22.179702,2 15,2 Z" fill="#000000" fill-rule="nonzero" id="path40" sodipodi:nodetypes="ssccsccssssssss" /> <g aria-label="A" id="text358" style="font-size:24px;fill:#000000"> <path d="M 23.14866,22.435659 H 20.676003 L 18.965066,17.572378 H 11.418191 L 9.7072535,22.435659 H 7.3517847 L 13.703347,4.9864407 h 3.09375 z M 18.250222,15.580191 15.191628,7.0137844 12.121316,15.580191 Z" id="path472" /> </g> </g> </svg></button>
					</div>
				</div>
            </div>
			
			
            
            <div class='editor'>
                <div class='scheme' id='scheme'  style='min-height: 1px;' >
					
                    <div class='scheme_canvas' id='scheme_canvas'>
						
                    
                        <!-- Окно редактирования точек -->
                        <div style='display: none' class='menu' id='context_menu_point'>
                            <form>
                                <table>
                                    <tr><td>Имя</td>
                                        <td colspan='2'>
                                            <select onChange='OnChangeParams(event)' aria-label="name" id='name_context'>
                                            </select>
                                        </td>
                                        <td>
                                            <p id='point-name-label'>NAME</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>X</td><td><input oninput='OnChangeParams(event)' aria-label="X" name='x_context' id='x_context' type='number' step='0.1' max='100' min='0'/></td>
                                        <td>Y</td><td><input oninput='OnChangeParams(event)' aria-label="Y" name='y_context' id='y_context' type='number' step='0.1' max='100' min='0'/></td>
                                    </tr>
                                    <tr><td>Размер</td><td colspan='3'><input onchange='OnChangeParams(event)' aria-label="size" id='size_context' type="range" min="1" max="5" value="1" step="0.5"></td></tr>
                                    <tr><td>Описание</td><td colspan='3'><textarea disabled style='width: 100%; min-height: 100px;' oninput='OnChangeParams(event)' aria-label="size" id='description_context'></textarea></td></tr>
                                    <tr><td><input type='hidden' id='cur_point_context' value=-1 style='width: 35px'/></td></tr>
                                    <tr><td></td><td></td><td></td><td><button onclick='onDeletePoint()'>Удалить</button></td></tr>
                                </table>
                            </form>
                        </div>
                        <!-- Окно создания точек -->
                        <div style='display: none' class='menu' id='context_menu'>
                            <table>
                                <tr><td><button onclick='onCreatePoint(event)'>Новая точка</button></td></tr>
                            </table>
                        </div>
						
                        <svg style="width=100%; height=100%; position: absolute; border: 1px solid blue;" id="line-canvas"  viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
							
						</svg>
						
                    </div>
					
                </div>
            </div>
        
        </div>
    </div>
		<script src="xxeam317_modal_window.js"></script>
        <script>
			//-----конвертер строк в числа и чисел в строки------
            function Utf8ArrayToStr(array) {
              var out, i, len, c;
              var char2, char3;
            
              out = "";
              len = array.length;
              i = 0;
              while (i < len) {
                c = array[i++];
                switch (c >> 4)
                { 
                  case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
                    // 0xxxxxxx
                    out += String.fromCharCode(c);
                    break;
                  case 12: case 13:
                    // 110x xxxx   10xx xxxx
                    char2 = array[i++];
                    out += String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
                    break;
                  case 14:
                    // 1110 xxxx  10xx xxxx  10xx xxxx
                    char2 = array[i++];
                    char3 = array[i++];
                    out += String.fromCharCode(((c & 0x0F) << 12) |
                                               ((char2 & 0x3F) << 6) |
                                               ((char3 & 0x3F) << 0));
                    break;
                }
              }    
              return out;
            }
			
			function StrToUtf8Array(text) {
				const surrogate = encodeURIComponent(text);
				const result = [];
				for (let i = 0; i < surrogate.length;) {
					const character = surrogate[i];
					i += 1;
					if (character == '%') {
						const hex = surrogate.substring(i, i += 2);
						if (hex) {
							result.push(parseInt(hex, 16));
						}
					} else {
						result.push(character.charCodeAt(0));
					}
				}
				return result;
			};
			//--------------------------------------------
            
            function getOrganizationList(callback, callback_id){
                let org_list = [];
                let result = null;
				
				let org_select = document.getElementById('org_id_select');
				let org_list_loading = document.getElementById('org_list_loading');
				
				let techcard_select = document.getElementById('techcard_select');
				let techcard_list_loading = document.getElementById('techcard_list_loading');
				
				org_list_loading.style.display = 'inline';
				org_select.style.display = 'none'
				
				techcard_list_loading.style.display = 'inline';
				techcard_select.style.display = 'none';
				
				$.ajax({
				   type: "POST",
				   url: "xxeam317_fetch.jsp?type=organizations",
				   dataType: 'json',
				   headers: {
                        "Content-type": "application/json; charset=iso-8859-5"
                      },
				   success: function(response){
						let data = response;
						
						org_list = data.data;
						
						result = data.data[0].code;
						
						org_list.forEach(function(org) {
							let option = document.createElement("option");
						
							option.text = org.name;
							option.value = org.code;
							
							org_select.add(option);
						}); 
						
						org_list_loading.style.display = 'none';
						org_select.style.display = 'inline'
						
						console.log(result);
						
						if(document.getElementById('org_id').value != 'null') {
							org_select.value = document.getElementById('org_id').value;
							document.getElementById('org_id').value = 'null';
						}
						
						if (callback[callback_id] != null) {
							callback_id++;
							callback[callback_id-1](callback, callback_id, org_select.value);
						}
				   }
				 });
				
            }
			
            function getTechcards(callback, callback_id, org_id) {
				let techcard_list = [];
				let result = null;
				
				let techcard_select = document.getElementById('techcard_select');
				let techcard_list_loading = document.getElementById('techcard_list_loading');
				let org_select = document.getElementById('org_id_select');
				
				techcard_list_loading.style.display = 'inline';
				techcard_select.style.display = 'none';
				org_select.disabled = true;

				$.ajax({
						type: "POST",
						url: 'xxeam317_fetch.jsp?type=techcards&org_id='+org_id,
						dataType: 'json',
						headers: {
							"Content-type": "application/json; charset=iso-8859-5"
						},
						success: function(response) {
							let data = response;
							
							while (techcard_select.firstChild) {
								techcard_select.removeChild(techcard_select.lastChild);
							}

							techcard_list = data.data;
							techcard_list.forEach(function(techcard) {
								let option = document.createElement("option");

								option.text = techcard.NAME;
								option.value = techcard.ID;

								techcard_select.add(option);
							});
							techcard_list_loading.style.display = 'none';
							techcard_select.style.display = 'inline';
							org_select.disabled = false;
							
							if (document.getElementById('techcard_id').value != 'null') {
								techcard_select.value = document.getElementById('techcard_id').value;
								document.getElementById('techcard_id').value = 'null';
							}

							if (callback[callback_id] != null) {
								callback_id++;
								callback[callback_id - 1](callback, callback_id, techcard_select.value);
							}
							
							
						}
				});
			}
			
			function getScheme(callback, callback_id, tech_card_id){
				console.log('tech_card_id: ' + tech_card_id);
                
                close_all_menu();
				
				$.ajax({
					type: "POST",
					url: 'xxeam317_fetch.jsp?type=scheme&techcard_id='+tech_card_id,
					dataType: 'json',
					ContentType: "application/json; charset=iso-8859-5",
					headers: {
						"Content-type": "application/json; charset=iso-8859-5"
					},
					success: function(response) {
						let data = response;
						
						//console.log(data);

						const reg_DOCTYPE = /<!DOCTYPE(.*?)>/g; 
						const reg_XML = /<\?xml(.*?)>/g; 
						
						let pre_result = data.data.scheme;// /\<{!DOCTYPE}*\>
						
						if (pre_result != null) {
							//console.log(pre_result);
							pre_result = Utf8ArrayToStr(pre_result);
						} else {
							pre_result = '';
						}
						
						pre_result = pre_result.replace(reg_DOCTYPE, "");
						result = pre_result.replace(reg_XML, "");
						
						renderSVG(result, data.data.points);
						
						techcard_nf_l = document.getElementById('techcard_nf_l');
						techcard_nf_l.style.display = 'none';

						if (callback[callback_id] != null) {
							callback_id++;
							callback[callback_id - 1](callback, callback_id, tech_card_id);
						}
					}
				});
			}
			
			function getOrgIdByTechcard(callback, callback_id, techcard_id) {
				let techcard_list = [];
				let result = null;

				$.ajax({
						type: "POST",
						url: 'xxeam317_fetch.jsp?type=get_org_id_by_techcard_id&techcard_id='+techcard_id,
						dataType: 'json',
						headers: {
							"Content-type": "application/json; charset=iso-8859-5"
						},
						success: function(response) {
							let data = response;

							org_id = data.data.ID;
							
							document.getElementById('org_id').value = org_id;

							if (callback[callback_id] != null) {
								callback_id++;
								callback[callback_id - 1](callback, callback_id, org_id);
							}
						}
				});
			}
			
            function save(){
                let req_body = {data: []};
                let techcard_id = document.getElementById('techcard_select').value;
                let user_id = document.getElementById('user_id').value;
                let result = 'E';
                
                points.forEach(function(point) {
                    let point_r = {
                        techcard: techcard_id,
                        name: point.name,
                        x: point.x,
                        y: point.y,
                        size: point.size
                    }
                    req_body.data.push(point_r);
                });
				
				//console.log(StrToUtf8Array(JSON.stringify(req_body)));
				
				$.ajax({
					type: "POST",
					url: 'xxeam317_fetch.jsp?type=save&techcard_id=' + techcard_id + '&user_id=' + user_id,
					dataType: 'json',
					data: JSON.stringify(StrToUtf8Array(JSON.stringify(req_body))), // <-- костыль для передачи символов через IE
					headers: {
						"Content-type": "charset=iso-8859-5"
					},
					success: function(response) {
						let data = response;

						closeModalWindow();
					}
				});
            }
            
            function fetchOnStart(){
				 let get_techcard_id = document.getElementById('techcard_id');
				 console.log('[GET] techcard_id: ' + get_techcard_id.value);
				 
				 if (get_techcard_id.value == 'null'){
					getOrganizationList([getTechcards, getScheme], 0);
				 } else {//375482
					getOrgIdByTechcard([getOrganizationList, getTechcards, getScheme], 0, parseInt(get_techcard_id.value));
				 }
            }
            
            function onChangeOrganiation(orgId){
                getTechcards([getScheme], 0, orgId);
            }
            
            document.getElementById('org_id_select').onchange = function(event) {
                onChangeOrganiation(event.target.value);
            };
            
            document.getElementById('techcard_select').onchange = function(event) {
                getScheme([], 0, event.target.value);
            };
            
            document.getElementById('refresh_btn').onclick = function(event) {
                let desc = 'Перезагрузить схему? Это приведет к потере несохранённых изменений.';
                let yes_event = function() {
                        let techcard = document.getElementById('techcard_select');
                        if (techcard != null && techcard != undefined){
                            getScheme([], 0, techcard.value);
                        }
                        closeModalWindow();
                    }
                showWindow(WinType.INFO, BtnType.YESNO, desc, [yes_event]);
            };
            
            document.getElementById('save_btn').onclick = function(event) {
                let desc = 'Сохранить изменения?';
                let type = 'Подтверждение';
                
                if(pointsProp.size != points.length){
                    desc = 'Не все точки привязаны к схеме! Всё равно cохранить изменения?';
                    type = WinType.WARNING;
                }
                
                let yes_event = function() {
                        
                        showWindow('Сохраняю...', BtnType.NONE, loading_gif, [yes_event]);
                        save();
                    }
                showWindow(type, BtnType.YESNO, desc, [yes_event]);
            };
            
            
            window.onload = fetchOnStart();
        </script>
    
	<script>
            //Убираем "призраков" при перемещении
            document.addEventListener("dragstart", function( event ) {
				let img = new Image();
				img.src = 'data:image/gif;base64,R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=';

				//event.dataTransfer.setDragImage(img, 0, 0); //работает только на ES6

				close_all_menu();
            }, false);
    
            //Определяем схему
            const scheme_el = document.getElementById('scheme');
            let scheme_canvas_el = document.getElementById('scheme_canvas');
            let scheme_svg;
            
            //Ищем контектсные меню
            let context_menu = document.getElementById('context_menu');
            let context_menu_point = document.getElementById('context_menu_point');
            
            //выбранная точка
            let cur_point = {};
            
            //Позиция вызова контекстного меню
            let cur_cursor = {
                x: 0,
                y: 0
            };
            
            //массив всех точек
            const points = [];
            
            //массив параметров имён точек
            const pointsProp = new Map();
			
			
	</script>
	
    <script src="xxeam317_scheme_editor.js"></script>
    <script>
		//стандартное значение режима автообновления размера
		var autoResizeModeFlag = true;
		setAutoResizeMode(autoResizeModeFlag);
	
		function OnChangeParams(event) {
			const srcElement = event.srcElement.id;
			const value = event.srcElement.value;
			
			console.log(srcElement + "=" + value);
			
			switch (srcElement) {
			  case 'x_context':
				pointMoveTo(cur_point, event.target.value, cur_point.y, true);
				break;
			  case 'y_context':
				pointMoveTo(cur_point, cur_point.x, event.target.value, true);
				break;
			  case 'size_context':
				resizePoint(cur_point, event.target.value);
				break;
			  case 'name_context':
				renamePoint(cur_point, event.target.value);
				break;
			}
		}
		
		//получение именно SVG схемы
		function getSvgScheme() {
			const svgs = scheme_el.getElementsByTagName("svg");
			for (let svg_el_id = 0; svg_el_id != svgs.length; svg_el_id++){
				let svg_el = svgs[svg_el_id];
				if (svg_el.parentNode == scheme_el) {
					return svg_el;
				}
			}
		}
                
		function clearCanvas(){
			deleteAllPoints();
			let scheme_element = getSvgScheme();
			
			if (scheme_element != null && scheme_element != undefined){
				let parent_node = scheme_element.parentNode;
				parent_node.removeChild(scheme_element);
			}
		}
		
		//Загрузка точек
		function updatePoints(p_points){
			let name_select = document.getElementById('name_context');
			
			while (name_select.firstChild) {
				name_select.removeChild(name_select.lastChild);
			}
			
			let option = document.createElement("option");
			option.text = 'Сменить';
			option.value = '';
			option.id = 'null_name';
			name_select.add(option);
			
			pointsProp.clear();
		
			for (var point_id = 0; point_id < p_points.length; point_id++){
				let point = p_points[point_id];
				let prop = point.PROPERTIES;
				
				pointsProp.set(point.NAME, {DESCRIPTION: point.DESCRIPTION, seqIDs: point.SEQ_IDS})
				
				if(prop.X == null || prop.Y == null || prop.SIZE == null){
					option = document.createElement("option");
					
					option.text = point.NAME;
					option.value = point.NAME;
					option.id = point.NAME + '_name';
					
					name_select.add(option);
				} else {
					createPoint(parseFloat(prop.X), parseFloat(prop.Y), parseFloat(prop.SIZE), point.NAME, point.DESCRIPTION, point.SEQ_IDS, scheme_canvas);
				}
			}
		}
		
		//Вставляем схему
		function renderSVG(svg, p_points){
			clearCanvas();
			
			scheme_el.insertAdjacentHTML('beforeend', svg);
			scheme_svg = getSvgScheme();
			
			scheme_params.width = scheme_el.clientWidth;
			scheme_params.height = scheme_el.clientHeight;
			
			console.log(p_points)
			
			autoResize();
			
			updatePoints(p_points);
		}
		
		//правый клик по пустой области
		scheme_canvas.addEventListener('contextmenu', function (event) {
			event.preventDefault();
			event.stopPropagation();
			close_all_menu();
			let context_menu = document.getElementById('context_menu');
			context_menu.style.display = 'block';
			
			const rect = scheme.getBoundingClientRect();
			let deltaX = event.clientX - rect.left;
			let deltaY = event.clientY - rect.top;
			
			let X = deltaX;
			let Y = deltaY;
			
			cur_cursor.x = X;
			cur_cursor.y = Y;
			
			X = X - (context_menu.clientWidth/100)*(X*100)/scheme_params.width;
			
			console.log('scheme_canvas contextmenu');
			
			context_menu.style.transform = "translate("+X+"px,"+Y+"px)";
		});

		//закрытие оконо при правом клике по пустой области
		scheme_canvas.addEventListener('click', function (event) {
			event.preventDefault();
			event.stopPropagation();
			
			if (event.target !== scheme_canvas && event.target !== document.getElementById('line-canvas')) return;
			
			close_all_menu();
			console.log('scheme_canvas click');
		});
		
		
    </script>
  </body>
</html>