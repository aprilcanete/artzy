
$(document).ready(function(){
    var header = $('body');
    
    var backgrounds = new Array(
        'url(/images/bg1.jpg)'
      , 'url(/images/bg2.webp)'
      , 'url(/images/bg3.webp)'
    );
    
    var current = 0;
    
    function nextBackground() {
        current++;
        current = current % backgrounds.length;
        header.css('background-image', backgrounds[current]);
    }
    setInterval(nextBackground, 10000);
    
    header.css('background-image', backgrounds[0]);
});