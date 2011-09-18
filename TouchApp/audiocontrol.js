$(function(){
  
  var pause = function(){
    $('#playerwrapper').html("<div><strong>Pause</strong><br /><span class='subtitle'>Tap here to pause the audio stream</span></div>");
    document.location = 'js2objc:///play';
  }
  
  var play = function(){    $('#playerwrapper').html("<div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div>");
    document.location = 'js2objc:///pause';
  }
  
  $('#playerwrapper').toggle(pause,play);
  
});

