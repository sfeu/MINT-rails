/**
 * Created by .
 * User: sfeu
 * Date: 6/4/11
 * Time: 3:45 PM
 * adapted from www.floydprice.com/wp-content/uploads/2010/09/multiTouch.htm
 */
var jug = new Juggernaut;
var touches = [];
var angle = 0;

$(function() {
 //   bindEvents();
    setTimeout(	drawTouches , 33);

    jug.subscribe("thumb", function(data) {

        var a = jQuery.parseJSON(data);

        switch(a.cmd) {

            case 'NEW':
                recordTouch(a.touch);
                break;
            case 'DEL':
                removeTouch( a.touch);
                break;
            case 'POS':
                moveTouch(a.touch);
                break;
        }
    });
});



//function bindEvents(){
//    $('#pointerCanvas').bind('touchstart', function() {
//        event.preventDefault();
//        do
//            var allTouches = event.touches;
//
//        for (var i = 0; i < allTouches.length; i++)
//        {
//            recordTouch(allTouches[i]);
//        }
//    });
//
//    $('#pointerCanvas').bind('touchend', function() {
//        event.preventDefault();
//
//        var allTouches = event.touches;
//
//
//        removeTouch(allTouches);
//
//    });
//
//    $('#pointerCanvas').bind('touchmove', function() {
//        event.preventDefault();
//
//        var allTouches = event.touches;
//        for (var i = 0; i < allTouches.length; i++)
//        {
//            moveTouch(allTouches[i]);
//        }
//    });
//}

function recordTouch(touch){
    if (newTouch(touch))
    {
        var template = $("<canvas class='touch' width='120' height='120' id='"+ touch.identifier+ "'></canvas>");
        $('#pointerCanvas').append(template);
        template.css({left: touch.pageX - (template.width() / 2), top: touch.pageY - (template.height() /2) });
        var t = {touch: touch, element: template};
        touches.push(t);

    }
}

function moveTouch(touch){
    for (var i = 0; i < touches.length; i++){
        if (touches[i].touch.identifier == touch.identifier){
            touches[i].element.css({left: touch.pageX - (touches[i].element.width() / 2), top: touch.pageY - (touches[i].element.height() /2) });
        }
    }
}

function newTouch(touch){
    for (var i = 0; i < touches.length; i++){
        if (touches[i].touch.identifier == touch.identifier){
            return false;
        }
    }
    return true;
}

function removeTouch_fromexisting(all_touches){
    var toRemove = [];
    for (var i = 0; i < touches.length; i++){

        var found  = false;
        for (var j = 0; j < all_touches.length; j++ )
        {

            if (touches[i].touch.identifier == all_touches[j].identifier){
                found = true;
            }

        }
        if (!found){
            toRemove.push({obj: touches[i], ref: i })

        }
    }


    for (var i = 0; i < toRemove.length; i++)
    {
        for (var j = 0 ; j < touches.length; j++)
        {
            if (touches[j].touch.identifier == toRemove[i].obj.touch.identifier)
            {
                touches.splice(j ,1);
            }
        }
        $(toRemove[i].obj.element).remove();
    }
}

function removeTouch(touch){
    var toRemove = [];
    for (var i = 0; i < touches.length; i++){
            if (touches[i].touch.identifier == touch.identifier){
                toRemove.push({obj: touches[i], ref: i })
            }

    }


    for (var i = 0; i < toRemove.length; i++)
    {
        for (var j = 0 ; j < touches.length; j++)
        {
            if (touches[j].touch.identifier == toRemove[i].obj.touch.identifier)
            {
                touches.splice(j ,1);
            }
        }
        $(toRemove[i].obj.element).remove();
    }
}


function drawTouch(ref){


    var canvas = document.getElementById(ref.touch.identifier);
    if (!canvas) return;
    var ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.save();


    ctx.setAlpha(0.4);
    ctx.strokeStyle = "#FF0000";

    ctx.beginPath();
    ctx.lineWidth = 5;
    ctx.lineJoin = "round";
    ctx.arc(canvas.width / 2, canvas.height / 2, (canvas.width / 2) -5, 0, Math.PI*2, true);
    ctx.closePath();
    ctx.stroke();
    // ctx.fill();

    ctx.fillStyle = "#FF0000";
    ctx.beginPath();
    ctx.arc(canvas.width / 2, canvas.height / 2, (canvas.width / 2) - 20, 0, Math.PI*2, true);
    ctx.closePath();
    ctx.fill();

    ctx.restore();

    ctx.save();

    ctx.translate(canvas.width / 2, canvas.height / 2);
    ctx.rotate(angle * Math.PI / 180);
    for (var i = 0; i < 4; i ++)
    {
        ctx.rotate((90 * i)  * Math.PI / 180);
        ctx.fillStyle = "#FF0000";
        // Top Triangle
        ctx.beginPath();
        ctx.moveTo(0, - (canvas.height / 2) +  9);        // Top Corner
        ctx.lineTo( 4, - (canvas.height / 2) + 17); // Bottom Right
        ctx.lineTo( - 4, - (canvas.height / 2) + 17);         // Bottom Left
        ctx.closePath();
        ctx.fill();
    }
    ctx.restore();


}

function drawTouches(){
    for (var i = 0; i < touches.length; i++){
        drawTouch(touches[i]);
    }
    angle = angle + 8;
    setTimeout(	drawTouches , 33);
}