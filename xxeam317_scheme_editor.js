//прототип схемы
const scheme_params = {
    width: 0,
    height: 0,
    element: undefined
}

//прототип точки
const default_point = {
    id: '',
    size: 1,
    x: 0,
    y: 0,
	seqIDs: [],
    name: 'unnamed',
    description: '',
    element: undefined
}

//Рандомный ID
function makeid(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    let counter = 0;
    while (counter < length) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
      counter += 1;
    }
    return result;
}

function toFixed(value) {
	return (parseInt(value * 100)) / 100;
}

/*------- тестовые
context_menu.addEventListener('click', function(event) {
    event.preventDefault();
    event.stopPropagation();
    console.log('context_menu click');
});

context_menu_point.addEventListener('click', function(event) {
    event.preventDefault();
    console.log('context_menu_point click');
});
*///-------

//получение размера точки относительно размера экрана
function getPointRealSize(point){
    return trunc(scheme_params.width/100 * point.size)
}

function resizePoint(point, size) {
    point.size = size;
    let point_real_size = getPointRealSize(point);
    point.element.style.width = point_real_size + 'px';
    point.element.style.height = point_real_size + 'px';
    pointMoveTo(point, cur_point.x, cur_point.y, true);
}

//передвинуть точку
function onMovePoint(event, point){
    pointMoveTo(point, event.layerX, event.layerY);
}

//создать точку
function onCreatePoint(event){
    try {
        let last_name_value = document.getElementById('name_context').children[1].value;
        deleteName(last_name_value)
        const point = createPoint(0, 0, 2.5, last_name_value, '', getSeqIDsByName(last_name_value), scheme_canvas);
        pointMoveTo(point, cur_cursor.x, cur_cursor.y, false);
    } catch(e){
        showWindow(WinType.ERROR, BtnType.OK, 'Все точки осмотра уже на схеме.', []);
    }
    close_all_menu();
}

//поиск элемента по идентификатору
function deletePointByID(id){
    for (let index in points) {
        let point = points[index];
        if (point.id === id) {
            //point.element.remove(); //Да эта фигня тоже не поддерживается
			point.element.outerHTML = '';
            
            if(points[index].name.length != 0){
                insertName(points[index].name);
            }
            
            points.splice(index, 1);
            close_all_menu();
            return;
        }
    }
}


//рисуем линии
function drawLines(){
	const line_canvas = document.getElementById('line-canvas');
	const seq_ids = {};
	
	line_canvas.innerHTML = '';
	
	for (let pointId = 0; pointId != points.length; pointId++){
		let curent_point = points[pointId];
		for (let seqId_Id = 0; seqId_Id != curent_point.seqIDs.length; seqId_Id++){
			seq_ids[curent_point.seqIDs[seqId_Id]] = {curent_point: curent_point}
		}
	}
	
	let last_point;
	let point;
	

	for (let key in seq_ids) {
		if (seq_ids.hasOwnProperty(key)) {
			point = seq_ids[key].curent_point;
			if (last_point) {
				let path = '<path stroke="' + '#' + (Math.random().toString(16) + '000000').substring(2,8).toUpperCase() + '" stroke-width="0.5" stroke-linecap="butt" fill="none"d="';//M80,100 Q160,20 240,100 T320,100
				
				path += 'M' + point.x + "," + point.y + 
					   " Q" + (point.x-(point.x-last_point.x)/2) + "," + point.y +
					   " "  + (point.x-(point.x-last_point.x)/2) + "," + (point.y-(point.y-last_point.y)/2) +
					   " T" + last_point.x + "," + last_point.y;
				
				path += '"/>';
				
				let line = '<line stroke="' + '#' + (Math.random().toString(16) + '000000').substring(2,8).toUpperCase() + 
				'" stroke-width="0.5" x1="'+toFixed(point.x*10)+'" y1="'+toFixed(point.y*10)+'" x2="'+toFixed(last_point.x*10)+'" y2="'+toFixed(last_point.y*10)+'" stroke="black" />'
				  
				line_canvas.innerHTML += line_canvas.innerHTML + line;

			}
			last_point = point;
		}
	}
}

//Вставляет точку осмотра из списка имён в контектсном меню
function insertName(name){
    if (name.length == 0) return;
    
    let name_select = document.getElementById('name_context');
                
    let option = document.createElement("option");
    option.text     = name;
    option.value    = name;
    option.id       = name + '_name';
    name_select.add(option);
    
    name_select.value = '';
}

//Удаляет точку осмотра из списка имён в контектсном меню
function deleteName(name){
    let name_element = document.getElementById(name + '_name');
    //name_element.remove();
	name_element.outerHTML = '';
    
    let name_select = document.getElementById('name_context');
    name_select.value = '';
}

function swapName(name_from, name_to){
    insertName(name_from);
    deleteName(name_to);
}

function deleteAllPoints(){
    for (let index in points) {
        let point = points[index];
        //point.element.remove();
		point.element.outerHTML = '';
    }
    points.splice(0,points.length);
}

//удалить точку
function onDeletePoint(){
    deletePointByID(cur_point.id);
}

//Получить описание точки по имени
function getDescriptionByName(name){
    return pointsProp.get(name).DESCRIPTION;
}

//Получить очередность точки по имени
function getSeqIDsByName(name){
    return pointsProp.get(name).seqIDs;
}

//переименование точки
function renamePoint(point, name){
    swapName(point.name, name);
    point.name = name;
	point.seqIDs = getSeqIDsByName(name);
    point.element.children[0].innerHTML = name;
    
    document.getElementById('point-name-label').innerHTML = name;
    document.getElementById('description_context').value = getDescriptionByName(name);
}

//дублирование экземпляра объекта
function assign(target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i];
    for (var key in source) {
      if (source.hasOwnProperty(key)) {
        target[key] = source[key];
      }
    }
  }
  return target;
}

function trunc(x) {
  if (isNaN(x)) {
    return NaN;
  }

  if (x > 0) {
    return Math.floor(x);
  } else {
    return Math.ceil(x);
  }
}

//создание точки
function createPoint(x, y, size, name, description, seqIDs, scheme){
    const new_point = assign({}, default_point);
    new_point.x = x;
    new_point.y = y;
    new_point.size = size;
    new_point.name = name;
	new_point.seqIDs = seqIDs;
    new_point.description = description;
    new_point.id = 'point_' + makeid(15);
    
    let point_real_size = getPointRealSize(new_point);
    let body = "<div id = '"+new_point.id+"' draggable='true' class='point'><p class='point_name'>"+name+"</p></div>";
    scheme.insertAdjacentHTML('beforeend', body);
    
    new_point.element = document.getElementById(new_point.id);
    new_point.element.style.width = point_real_size + 'px';
    new_point.element.style.height = point_real_size + 'px';
    
    let X_pos = scheme_params.width/100*x - point_real_size/2;
    let Y_pos = scheme_params.height/100*y - point_real_size/2;
    new_point.element.style.transform = "translate("+X_pos+"px, "+ Y_pos+"px)";
    
    /*
	new_point.element.addEventListener('mousedown', function(event) {
        event.preventDefault();
		console.log('drag');
        onMovePoint(event, new_point);
    });
    
    new_point.element.addEventListener('mouseup', function(event) {
        event.preventDefault();
		console.log('dragend');
        onMovePoint(event, new_point);
    });//*/
	
	///*
	new_point.element.addEventListener('mousedown', function(event) {
		let element = event.target;
		let startX = event.clientX;
		let startY = event.clientY;

		document.addEventListener('mousemove', moveElement);
		document.addEventListener('mouseup', stopMoving);

		function moveElement(event) {
		  const rect = scheme.getBoundingClientRect();
		  let deltaX = event.clientX - rect.left;
		  let deltaY = event.clientY - rect.top;
		  //console.log(event.clientX + 'x' + event.clientY + ' ' + rect.left + 'x' + rect.top);

		  //onMovePoint(event, new_point);
		  pointMoveTo(new_point, deltaX, deltaY, false);
		}

		function stopMoving() {
		  //console.log('dragend');
		  document.removeEventListener('mousemove', moveElement);
		  document.removeEventListener('mouseup', stopMoving);
		}
	  
	});//*/
	
	new_point.element.addEventListener("dragstart", function(event) {
		console.log('dragstart');
	  event.preventDefault();
	});
	
	new_point.element.addEventListener("dragend", function(event) {
	  console.log('dragend');
	  event.preventDefault();
	});
	
	new_point.element.addEventListener("drag", function(event) {
		console.log('drag');
	  event.preventDefault();
	});
    
    //контекстное меню
    new_point.element.addEventListener('contextmenu', function(event) {
        event.preventDefault();
        event.stopPropagation();
        close_all_menu();
        
        cur_point = new_point;
        
        let context_menu = document.getElementById('context_menu_point');
        context_menu.style.display = 'block';
        
        let X = scheme_params.width/100*new_point.x + point_real_size/4;
        let Y = scheme_params.height/100*new_point.y + point_real_size/4;
        
        X = X - (context_menu.clientWidth/100)*cur_point.x;
        
        context_menu.style.transform = "translate("+X+"px,"+Y+"px)";
        
        document.getElementById('x_context').value = new_point.x;
        document.getElementById('y_context').value = new_point.y;
        document.getElementById('name_context').value = '';
        document.getElementById('point-name-label').innerHTML = new_point.name;
        document.getElementById('size_context').value = new_point.size;
        document.getElementById('cur_point_context').value = new_point.id;
        document.getElementById('description_context').value = getDescriptionByName(new_point.name);
        
        console.log('point contextmenu');
    });
    
    points.push(new_point);
    return new_point;
}

//перемещение точек
function pointMoveTo(point, to_x, to_y, toPercent){
	
	if(toPercent == null){
		toPercent = false;
	}
	
    let point_real_size = getPointRealSize(point);
    let X = 0;
    let Y = 0;
    
    let x = 0;
    let y = 0;
	
	console.log(to_x + ':' + to_y)
	
    if (!toPercent) {
        x = (to_x*100)/scheme_params.width;
        y = (to_y*100)/scheme_params.height;
        
        X = to_x - point_real_size/2;
        Y = to_y - point_real_size/2;
    } else {
        x = toFixed(to_x);
        y = toFixed(to_y);
        
        X = x/100*scheme_params.width - point_real_size/2;
        Y = y/100*scheme_params.height - point_real_size/2;
    }
    
    //console.log(point.x + ":" + point.y + " " + scheme_params.width + "x" + scheme_params.height);
    
	x = toFixed(x);
	y = toFixed(y);
	
    if (x >= 0 && y >= 0 && x <= 100 && y <= 100) {
        point.x = x;
        point.y = y;
        point.element.style.transform = "translate("+X+"px,"+ Y+"px)";
    }
}


//работа с размером полотна
function autoResize(){
	scheme_svg = getSvgScheme();
	if (scheme_svg) {
		filter_element = document.getElementById("filter-container");
		resize(filter_element.getBoundingClientRect().width/scheme_svg.getBoundingClientRect().width);
	}
}

function resize(scale) {
	let scheme_svg = getSvgScheme();
	let scheme_canvas_el = document.getElementById("scheme_canvas");
	let line_canvas_el = document.getElementById("line-canvas");
	let scheme_el = document.getElementById("scheme");
	
	if (scheme_svg) {
		
		scheme_svg.attributes.width.value = (scheme_svg.getBoundingClientRect().width * scale) + 'px';
		scheme_svg.attributes.height.value = (scheme_svg.getBoundingClientRect().height * scale) + 'px';
		
		scheme_canvas_el.style.width = scheme_svg.attributes.width.value;
		scheme_canvas_el.style.height = scheme_svg.attributes.height.value;
		
		line_canvas_el.style.width = scheme_svg.attributes.width.value;
		line_canvas_el.style.height = scheme_svg.attributes.height.value;
		
		scheme_el.style.width = scheme_svg.attributes.width.value;
		scheme_el.style.height = scheme_svg.attributes.height.value;
		
		scheme_params.width = scheme_el.clientWidth;
		scheme_params.height = scheme_el.clientHeight;
		
		points.forEach(function (point) {
			let point_real_size = getPointRealSize(point);
			let X_pos = scheme_params.width/100*point.x - point_real_size/2;
			let Y_pos = scheme_params.height/100*point.y - point_real_size/2;
			
			point.element.style.width = point_real_size + 'px';
			point.element.style.height = point_real_size + 'px';
			
			point.element.style.transform = "translate("+X_pos+"px,"+ Y_pos+"px)";
		});
	}
} 

function setAutoResizeMode(value){
	autoResizeModeFlag = (value == null)? !autoResizeModeFlag:value;
	arm_btn = document.getElementById("auto_resize_mode_btn");
	
	console.log('Auto resize mode: ' + autoResizeModeFlag)
	
	if(autoResizeModeFlag == true){
		arm_btn.style.background = '#4cd93d';
		autoResize();
	} else {
		arm_btn.style.background = '';
	}
}


//событие при изменении размера окна
addEventListener("resize", function(event) {
	if(autoResizeModeFlag) autoResize();
});
