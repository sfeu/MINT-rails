/**
 * Created by .
 * User: sfeu
 * Date: 5/17/11
 * Time: 8:52 AM
 * To change this template use File | Settings | File Templates.
 */


var jug = new Juggernaut;
var drag_obj = null;
var drag_x = -1;
var drag_y = -1;



jug.subscribe("channel_name", function(data){
    eval(data);
//  debug("Got data: " + data);
});

jug.subscribe("pointer", function(data) {
    var a = data.split("-");

    switch(a[0]) {

        case 'POS':
            var c = a[1].split(",");
            recordPointer(c[0],c[1],'#00ff00');
            movePointer(c[0],c[1],'#00ff00');
            if (drag_obj!=null) {
                $(drag_obj).css("left",parseInt(c[0])+drag_x);
                $(drag_obj).css("top",parseInt(c[1])+drag_y);
                console.log ("moving"+drag_obj+c[0]+"-"+(parseInt(c[1])+drag_x))
            }
            console.log ("pos "+c[0]+" "+c[1]+" "+c[2]);

            change_pos("POS",null,c[0],c[1],c[2]);
            break;

        case 'DRAG':
            var d = a[2].split(",");
            console.log ("drag "+a[1]+" "+d[0]+" "+d[1]);
            drag_obj= "#"+a[1];
            drag_x = $(drag_obj).offset().left -d[0];
            drag_y = $(drag_obj).offset().top -d[1];
            change_pos("DRAG",a[1],d[0],d[1],d[2]);
            break;
        case 'DROP':
            var e = a[2].split(",");
            console.log ("drop "+a[1]+" "+e[0]+" "+e[1]);
            drag_obj = null;
            change_pos("DROP",a[1],e[0],e[1],e[2]);
            break;
    }
});

function disableSelection(target){
    if (typeof target.onselectstart!="undefined") //IE route
        target.onselectstart=function(){return false}
    else if (typeof target.style.MozUserSelect!="undefined") //Firefox route
        target.style.MozUserSelect="none"
    else //All other route (ie: Opera)
        target.onmousedown=function(){return false}
    target.style.cursor = "default"
}

// web socket reference

var ws;
var ws_reconnect_timer_started = false;
var last_send_mouse_X = -1;
var last_send_mouse_Y = -1;

THRESHOLD_MOUSE_MOVEMENT_X = 9;
THRESHOLD_MOUSE_MOVEMENT_Y = 6; // Address 16:9 format
THRESHOLD_MOUSE_MOVEMENT_Z = 1; // Address scrollwheel ticks

function debug(str){ console.log(str); }
function startWS(server_address) {
    ws = new WebSocket("ws://"+server_address+":5006/websocket");
    ws.onmessage = function(evt) { debug(evt.data)};
    ws.onclose = function() {debug("connection close event...");ws_reconnect_timer();};
    ws.onopen = function() {  debug("connected...");};
    ws_reconnect_timer_started = false;
    return ws;
}


function ws_reconnect_timer() {
    if (!ws_reconnect_timer_started) {
        ws_reconnect_timer_started = true;
        setTimeout('startWS()', 2000);
    }
}

function ws_send(message) {
    if (!window.WebSocket) { return; }
    if (ws.readyState == WebSocket.OPEN) {
        ws.send(message);
    } else {
        debug('The WebSocket is not open!');
    }
}

<!-- pointer display -->

SCREEN_WIDTH = 1200;
SCREEN_HEIGHT = 900 ;

var pointer = null;
var pointer_color = null;

function recordPointer(x,y,color){
    if (pointer == null)
    {
        var template = $("<canvas class='touch' width='10' height='10' id='pointer'></canvas>");
        $('#pointerCanvas').append(template);
        template.css({left: x - (template.width() / 2), top: y - (template.height() /2) });
        pointer = template;
        drawPointer(color)
    }
}

function movePointer(x,y,color){
    pointer.css({left: x - (pointer.width() / 2), top: y - (pointer.height() /2) });
    if (pointer_color!=color) drawPointer(color);
}

function removePointer() {
    pointer.remove();
    pointer = null;
}

function drawPointer(color){
    var canvas = document.getElementById('pointer');
    if (!canvas) return;
    var ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.save();
    ctx.setAlpha(0.4);

    ctx.clearRect(0,0, SCREEN_WIDTH,SCREEN_HEIGHT);
    ctx.beginPath();
    ctx.fillStyle= color;
    // Draws a circle of radius 5 at the coordinates x,y on the canvas
    ctx.arc(canvas.width / 2, canvas.height / 2,5,0,Math.PI*2,true);
    ctx.closePath();
    ctx.fill();
    ctx.restore();
    ctx.save();
    pointer_color = color;
}



function bindMouse()  {
    $(document).mousemove(function(e){
        var clientCoords = e.clientX + "," + e.clientY ;
//        $("span:first").text("( e.clientX, e.clientY ) - " + clientCoords);
        if ( (Math.abs(last_send_mouse_X -  e.clientX)>THRESHOLD_MOUSE_MOVEMENT_X) || (Math.abs(last_send_mouse_Y -  e.clientY)>THRESHOLD_MOUSE_MOVEMENT_Y)) {
            ws_send(clientCoords);
            last_send_mouse_X = e.clientX;
            last_send_mouse_Y = e.clientY;
        }
    });

    $(document).mouseup(function(e){
        switch (e.which) {
            case 1:
                ws_send("LEFT_RELEASED");
                break;
            case 2:
                ws_send("MIDDLE_RELEASED");
                break;
            case 3:
                ws_send("RIGHT_RELEASED");
                break;
        }
    });
    $(document).mousedown(function(e){
        switch (e.which) {
            case 1:
                ws_send("LEFT_PRESSED");
                break;
            case 2:
                ws_send("MIDDLE_PRESSED");
                break;
            case 3:
                ws_send("RIGHT_PRESSED");
                break;
        }
    });

    $(document).mousewheel(function(event, delta) {
        console.log(delta);
        switch (delta) {
            case 1:
                ws_send("WHEEL_UP");
                break;
            case -1:
                ws_send("WHEEL_DOWN");
                break;
        }
    })
}


function sendTouch(cmd,touch) {
    //if ( (Math.abs(last_send_mouse_X -  e.clientX)>THRESHOLD_MOUSE_MOVEMENT_X) || (Math.abs(last_send_mouse_Y -  e.clientY)>THRESHOLD_MOUSE_MOVEMENT_Y)) {

        ws.send(cmd+"/"+ touch.identifier+ "/"+touch.pageX+"/"+touch.pageY);
    //    last_send_mouse_X = e.clientX;
    //    last_send_mouse_Y = e.clientY;
    //}
}

function bindTouch() {
    $('#pointerCanvas').bind('touchstart', function() {
        event.preventDefault();
         var allTouches = event.changedTouches;
         for (var i = 0; i < allTouches.length; i++)
        {
            sendTouch("NEW-TOUCH",allTouches[i]);
        }
    });

    $('#pointerCanvas').bind('touchend', function() {
        event.preventDefault();

        var allTouches = event.changedTouches;

        for (var i = 0; i < allTouches.length; i++)
        {
            sendTouch("REMOVE-TOUCH",allTouches[i]);
        }
    });

    $('#pointerCanvas').bind('touchmove', function() {
        event.preventDefault();

        var allTouches = event.changedTouches;

        for (var i = 0; i < allTouches.length; i++)
        {
            sendTouch("MOVE-TOUCH",allTouches[i]);
        }
    });

}
