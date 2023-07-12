const WinType = { ERROR: 'error', WARNING: 'warning', INFO: 'info'};
const BtnType = { YESNO: 'yesno', OK: 'ok', NONE: 'none'};

function closeModalWindow() {
	const modal_frame = document.getElementById('modal-frame');
	modal_frame.style.display = 'none';
}

//процедура отображения модального окна (тип окна, тип набора кнопок, основной текст, процедуры выполняемые по нажатию кнопок)
function showWindow(winType, btnType, description, eventList) {
	
	if (eventList == null){
		eventList = [];
	}
	
	const modal_frame = document.getElementById('modal-frame');
	const sub_modal_title = document.getElementById('sub-modal-title');
	const sub_modal_info = document.getElementById('sub-modal-info');
	const sub_modal_btns_yesno = document.getElementById('sub-modal-btns-yesno');
	const sub_modal_btns_ok = document.getElementById('sub-modal-btns-ok');
	
	sub_modal_btns_yesno.style.display = 'none';
	sub_modal_btns_ok.style.display = 'none';
	
	let title = 'NO NAME';
	let title_color = 'silver';
	
	switch (winType) {
		case WinType.ERROR:
			title = 'ОШИБКА!';
			title_color = 'red';
			break;
		case WinType.WARNING:
			title = 'ПРЕДУПРЕЖДЕНИЕ!';
			title_color = 'orange';
			break;
		case WinType.INFO:
			title = 'ИНФО';
			break;
		default:
			title = winType;
			break;
	}
	
	sub_modal_title.innerHTML = title;
	sub_modal_title.style.color = title_color;
	
	switch (btnType) {
		case BtnType.OK: 	
			sub_modal_btns_ok.style.display = 'block';
			if (eventList[0] != undefined || eventList[0] != null) {
				document.getElementById('sub-modal-btn-ok').onclick = eventList[0];
			} else {
				document.getElementById('sub-modal-btn-ok').onclick = closeModalWindow;
			}
			break;
		case BtnType.YESNO:
			sub_modal_btns_yesno.style.display = 'block';
			if (eventList[0] != undefined || eventList[0] != null) {
				document.getElementById('sub-modal-btn-yes').onclick = eventList[0];
			} else {
				document.getElementById('sub-modal-btn-yes').onclick = closeModalWindow;
			}
			
			if (eventList[1] != undefined || eventList[1] != null) {
				document.getElementById('sub-modal-btn-no').onclick = eventList[1];
			} else {
				document.getElementById('sub-modal-btn-no').onclick = closeModalWindow;
			}
			break;
	}
	
	sub_modal_info.innerHTML = description;
	
	modal_frame.style.display = 'flex';
}

//закрыть все контекстные окна
function close_all_menu(){
    let context_menu = document.getElementById('context_menu');
    context_menu.style.display = 'none';
    let context_menu_point = document.getElementById('context_menu_point');
    context_menu_point.style.display = 'none';
}