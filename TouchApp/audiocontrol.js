$(function(){
  isPlaying = false;
  
  pause = function(){
    showPlayButton();
    document.location = 'js2objc:///pause';
  }
  
  play = function(){    
    showPauseButton();
    document.location = 'js2objc:///play';
  }

  showPlayButton = function(){
    isPlaying = false;
    $('#playerwrapper').html("<div><strong>Play</strong><br /><span class='subtitle'>Tap here to stream audio</span></div>");
  }

  showPauseButton = function(){
    isPlaying = true;
    $('#playerwrapper').html("<div><strong>Pause</strong><br /><span class='subtitle'>Tap here to pause the audio stream</span></div>");
  }
  
  $('#playerwrapper').click(function(){
    if (isPlaying){
        pause();
    }
    else {
        play();
    }
  });
});
