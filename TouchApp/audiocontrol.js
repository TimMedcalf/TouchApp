$(function(){
  
  var pause = function(){
    $('#playerwrapper').html("<div><strong>Pause</strong><br /><span class='subtitle'>Click here to pause the audio stream</span></div>");
  }
  
  var play = function(){
    $('#playerwrapper').html("<div><strong>Play</strong><br /><span class='subtitle'>Click here to stream audio</span></div>");
  }
  
  $('#playerwrapper').toggle(pause,play);
  
});

