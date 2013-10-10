 #################### Extra Methods ###############
Array::unique = ->
  output = new Array()
  array_output = new Array()
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output
  output
#################### Classes ###############
class window.Jplayer
  @soundurl = ""
  @container = ""
  @loop_time = 5000
  @start_time = 0
  @end_time = 0
  constructor: (container,soundurl) ->
    Jplayer.container = $(container)
    Jplayer.soundurl = soundurl
    myControll =
      progress: $("#jp_container_1 .jp-progress-slider")
    Jplayer.container.jPlayer
        ready: Jplayer.ready
        play: Jplayer.play
        ended: Jplayer.ended
        loadstart: Jplayer.loadstart
        seeking: Jplayer.seeking
        repeat: Jplayer.repeat
        pause: Jplayer.pause
        playing: Jplayer.playing
        timeupdate: Jplayer.custom_loop
        ended: Jplayer.ended
        progress: Jplayer.progress
        swfPath: "/assets"
        supplied: "m4a,mp3"
        solution:"html,flash"
        preload: "auto"
        nativeSupport: true
        oggSupport: false
        customCssIds: true
        verticalVolume:true
        wmode: "window"
    myControll.progress.slider
      animate: "fast"
      max: 100
      range: "min"
      step: 0.1
      value: 0
      slide: (event, ui) ->
        sp = Jplayer.container.data("jPlayer").status.seekPercent
        if sp > 0
          Jplayer.container.jPlayer "playHead", ui.value * (100 / sp)
        else
          # Create a timeout to reset this slider to zero.
          setTimeout (-> $(".jp-progress-slider").slider "value", 0), 0
  @ready: (event) ->
    Jplayer.container.jPlayer "setMedia", m4a: Jplayer.soundurl
  @progress: (event) ->
    $("#player-load-bar").hide() if $("#player-load-bar").is(":visible")
#    console.log event;
  @play: (event) ->
#  Console.log Play
  @playing: (event) ->
#    console.log "HAHHAHAHA"
  @custom_loop: (event) ->
    ####### Set the timer's on the player ####################
    $("#jp_container_1 .jp-progress-slider").slider "value", event.jPlayer.status.currentPercentAbsolute
    $(".jp-remainig-time").text($.jPlayer.convertTime( Jplayer.container.data("jPlayer").status.duration - Jplayer.container.data("jPlayer").status.currentTime))
    ####### Set the timer's on the player ####################
    if $("#loop_piece").val() == "true"
      current = Jplayer.container.data("jPlayer").status.currentTime
      duration = Jplayer.container.data("jPlayer").status.duration
      ############ Percentage Calculation #################
      unless duration == 0
        start_loop_time =Math.round((Jplayer.start_time*duration)/100)
        end_loop_time = Math.round((Jplayer.end_time*duration)/100)

        console.clear()
        console.log "start_loop_time:"
        console.log start_loop_time

        console.log "current:"
        console.log current

        console.log "end_loop_time:"
        console.log end_loop_time
      ############ Percentage Calculation #################
        if current < start_loop_time
          Jplayer.container.jPlayer("play",start_loop_time)
        if current > end_loop_time
          Jplayer.container.jPlayer("pause",start_loop_time)
          window.setTimeout (->Jplayer.container.jPlayer("play") ) , parseInt( $("#player_delay").val() )
  @loadstart: (event) ->
    $("#player-load-bar").show()
    #loadstart logic here
  @seeking: (event) ->
#    console.log "Seeking Started"
    #seeking logic here
  @ended:(event) ->
#    console.log "ended"
  @pause:(event) ->
#    console.log "pause"
  @repeat: (event) ->
#    console.log "repeating"
    if event.jPlayer.options.loop
      jplayer = $(this)
      $(this).unbind(".jPlayerRepeat").bind $.jPlayer.event.ended + ".jPlayer.jPlayerRepeat", ->
        setTimeout (-> jplayer.jPlayer "play"), Jplayer.loop_time
    else
      $(this).unbind ".jPlayerRepeat"
  volume_change: (vol) ->
    Jplayer.container.jPlayer("volume", vol/100)
  total_play_time: () ->
    Jplayer.container.data("jPlayer").status.duration
$ ->
  if $(window).width() < 500
    $(".player-adjustments").first().remove()
    orientation = "horizontal"
  else
    $(".player-adjustments").last().remove()
    orientation = "vertical"
  ################# Player Object #####################
  window.player = new Jplayer "#jquery_jplayer_1",""
  ####################### Slider ######################
  $("#vol_slider").slider
    orientation: orientation
    range: "min"
    min: 0
    max: 100
    step: 1
    value: parseInt($("#player_volume").val())
    slide: (ui,event)->
      vol =  $( "#vol_slider" ).slider( "option", "value" )
      player.volume_change(vol)
    stop: (ui,event) ->
      vol =  $( "#vol_slider" ).slider( "option", "value" )
      player.volume_change(vol)
      $("#player_volume").val($( "#vol_slider" ).slider( "option", "value" ))
      if $(this).slider("value") <= 3
        $(".mute-volume").removeClass("mute-off").addClass("mute-on") if $(".mute-volume").hasClass("mute-off")
      else
        $(".mute-volume").removeClass("mute-on").addClass("mute-off") if $(".mute-volume").hasClass("mute-on")
      $(".audio_file").submit()
  #################### Volume Change #######################
  $(".loop_duration").change (event) ->
    Jplayer.loop_time =$(this).val()
  ############################# Change Player Piece ################################
  $(".change-piece_opt").live "change" , (event) ->
    lp_duration = $(".loop_duration").val()
    $("#loop_end").val($("#jp-duration").val())
    $("#player_index").val($("jp-current-time").val())
    $this_file= $(this)
    playing_time = $("#jquery_jplayer_1").data("jPlayer").status.currentPercentAbsolute
    tempo = $("#tempo-id-collection").val()
    piano_type = parseInt( $("#piano_type-id-collection").val() )
    key = parseInt( $("#key-id-collection").val() )
    tuning = parseInt( $("#tuning-id-collection").val() )
    text_value = collection.filter (v) ->  v.audio_file.tempo  == tempo and v.audio_file.piano_type_id == piano_type and v.audio_file.key_id  == key and v.audio_file.tuning_id == tuning
    ###################### Reconfigure Slider ############################
    $("#loop_start").val(Jplayer.start_time)
    $("#loop_end").val(Jplayer.end_time)
    ###################### Reconfigure Slider ############################
    unless text_value.length == 0
      data_file = text_value[0].audio_file.file
      console.log playing_time
      $("#jquery_jplayer_1").jPlayer("setMedia", {
        m4a: data_file
      }).jPlayer("play").jPlayer("playHead",playing_time)
      ########################## Save the form #####################################
      $(".player-notification").html("")
      $(".simple_form").submit()
    else
      $(".player-notification").html("Audio not available. Please contact <a href='mailto:help@pianoamigo.com'>help@pianoamigo.com</a> ")
  ############################# Change Player Piece Information ################################
  $(".show_details_img").live "click" , (event) ->
    $(".show_details").hide()
    $(".hide_details").show()
    $(".current_piece_detail").show()
  $(".hide_details_img").live "click" , (event) ->
    $(".hide_details").hide()
    $(".show_details").show()
    $(".current_piece_detail").hide()
  ############################# Change Player Piece Information ################################
  ############################# Player Components Operations ############################################################
  $(".minus-player").live "click" , (event) ->
    event.preventDefault()
    $this = $(this)
    $select = $this.parents(".select-up-down, .select-up-down-keys").find("select")
    unless $select.find('option:selected').prev('option').length == 0
      $select.find('option:selected').removeAttr('selected').prev('option').attr('selected', 'selected')
    $(".change-piece_opt").first().change()

  $(".plus-player").live "click" , (event) ->
    event.preventDefault()
    $this = $(this)
    $select = $this.parents(".select-up-down , .select-up-down-keys").find("select")
    unless $select.find('option:selected').next('option').length == 0
      $select.find('option:selected').removeAttr('selected').next('option').attr('selected', 'selected')
    $(".change-piece_opt").first().change()
  ################ Mute and Un-mute ####################
  $(".mute-volume").live "click" , (event) ->
    event.preventDefault()
    if $(this).hasClass("mute-off")
      $(this).removeClass("mute-off").addClass("mute-on")
      window.unmute_volume = $("#vol_slider").slider("value")
      $("#vol_slider").slider('option','value',0)
      player.volume_change(0)
    else if $(this).hasClass("mute-on")
      $(this).removeClass("mute-on").addClass("mute-off")
      $("#vol_slider").slider('option','value',unmute_volume)
      player.volume_change(50)
  ################ Loop On and Off #####################
  $(".on-loop").live "click" , (event) ->
    $(this).hide()
    $("#loop_piece").val(false)
    $(".off-loop").show()
    $(".audio_file").submit()
    $(".ui-slider-handle").eq(1).hide()
    $(".ui-slider-handle").eq(2).hide()
    $("#vol_slider .ui-slider-handle").show()
    #call this to repeat off loop
    $(".jp-repeat-off").click()
    event.preventDefault()

  $(".off-loop").live "click" , (event) ->
    $(this).hide()
    $(".on-loop").show()
    $("#loop_piece").val(true)
    $(".audio_file").submit()
    $(".ui-slider-handle").eq(1).show()
    $(".ui-slider-handle").eq(2).show()
    #call this to repeat off loop##
    $(".jp-repeat").click()
    event.preventDefault()

  ############################# Player Components Operations ############################################################
  $(".player-play").live "click" , (event) ->
    event.preventDefault()
    ##########bread crumb by rashid##############
    $(".div_head_text").removeClass("pg_head_color").append(" > <span style='color:#4CA5FF;'>Now Playing</span>")
    $(".piece_request_div").hide()
    ###########end############
    $this = $(this)
    $("#piece_id").val($this.data("piece_id"))
    window.collection = $this.data("audio_files")
    $(["tuning", "piano_type"]).each (sel_key,sel_value) ->
      ids = new Array()
      $.each collection,(index,value) ->
        ids.push( eval( "value.audio_file.#{sel_value}_id" ) )
      ids =  ids.unique()
      $("##{sel_value}-id-collection").html("")
      $.each ids ,(index,value) ->
        text_value = collection.filter (v) ->  eval( "v.audio_file.#{sel_value}_id" ) == value
        unless text_value.length == 0
          option = "<option value= '#{ eval("text_value[0].audio_file.#{sel_value}_id") }'> #{ eval("text_value[0].audio_file.#{sel_value}_title") } </option>"
          $("##{sel_value}-id-collection").append(option)
    $(".jplayer_div").css("opacity","1")
    $(".bs-docs-example").hide()
    ids = new Array()
    $.each collection,(index,value) ->
      ids.push( value.audio_file.tempo )
    ids =  ids.unique()
    $("#tempo-id-collection").html("")
    $.each ids ,(index,value) ->
      text_value = collection.filter (v) ->  v.audio_file.tempo  == value
      unless text_value.length == 0
        option = "<option value= '#{text_value[0].audio_file.tempo }'> #{ text_value[0].audio_file.tempo } </option>"
        $("#tempo-id-collection").append(option)
    ############### Centering the middle Element ##########################
    $.each $this.data("keys") ,(index,value) ->
      value[1] = "A#/Bb"if value[1] == "A#"
      value[1] = "C#/Db"if value[1] == "C#"
      value[1] = "D#/Eb"if value[1] == "D#"
      value[1] = "F#/Gb"if value[1] == "F#"
      value[1] = "G#/Ab"if value[1] == "G#"
      option = "<option value= '#{ value[0] }'> #{ value[1] } </option>"
      $("#key-id-collection").append(option)
    ############### Centering the middle Element ##########################
    ######## History Maintance ################
    window.default_piece= $(this).data('default_file')
    if $this.data("current_piece") == ""
      if $(this).data('default_file').length == 0
        window.default_file = collection[0].audio_file
        Jplayer.soundurl = default_file.file
      else
        window.default_file = $(this).data('default_file')
        Jplayer.soundurl = default_file.file
      tempo =  parseInt(default_file.tempo)
      key = default_file.key_id
      pinao_type = default_file.piano_type_id
      tuning = default_file.tuning_id
      start_loop = 0
      end_loop = 100
      loop_piece = false
      loop_delay = 0
      volume = 50
    else
      window.current = $this.data("current_piece")
      text_value = collection.filter (v) ->  v.audio_file.tempo  == current.current_tempo and v.audio_file.piano_type_id == parseInt(current.current_piano_type) and v.audio_file.key_id  == parseInt(current.current_key) and v.audio_file.tuning_id == parseInt(current.current_tuning)
      Jplayer.soundurl = text_value[0].audio_file.file
      tempo = parseInt(current.current_tempo)
      key = parseInt(current.current_key)
      pinao_type = parseInt(current.current_tuning)
      tuning = parseInt(current.current_piano_type)
      start_loop = current.loop_start
      end_loop = current.loop_end
      loop_piece = current.loop_piece
      loop_delay = current.loop_delay
      volume = parseInt(current.volume)
    player.volume_change(volume)
    $("#vol_slider").slider('option' , 'value' , volume)
    $("#tempo-id-collection option[value='#{tempo}']").prop("selected",true)
    $("#key-id-collection option[value='#{key}']").prop("selected",true)
    $("#tuning-id-collection option[value='#{tuning}']").prop("selected",true)
    $("#piano_type-id-collection option[value='#{pinao_type}']").prop("selected",true)
    $("#loop_piece").val(loop_piece)
    $("#loop_start").val(start_loop)
    $("#player_delay option[value='#{loop_delay}']").prop("selected",true)
    $("#loop_end").val(end_loop)
    if $("#loop_piece").val() == "true"
      $(".on-loop").show()
      $(".off-loop").hide()
    else
      $(".off-loop").show()
      $(".on-loop").hide()
    $("#vol_slider").slider("option","value",volume)
    ####### History Maintance ################
    ###################### Loop Handles ######################
    Jplayer.start_time = parseInt($("#loop_start").val())
    Jplayer.end_time = parseInt($("#loop_end").val())
    if $("#slider_range").data("uiSlider") == undefined
      $("#slider_range").slider
        range: true
        min: 0
        step: 1
        max: 100
        values: [ Jplayer.start_time , Jplayer.end_time ]
        slide: (event,ui) ->
          if ui.values[0] + 2  > ui.values[1]
            return false
        stop: (event,ui)->
          Jplayer.start_time = ui.values[0]
          Jplayer.end_time = ui.values[1]
          $("#loop_start").val(Jplayer.start_time)
          $("#loop_end").val(Jplayer.end_time)
          $(".audio_file").submit()
      if $("#loop_piece").val() == "true"
        $(".ui-slider-handle").eq(1).show()
        $(".ui-slider-handle").eq(2).show()
      else
        $(".ui-slider-handle").eq(1).hide()
        $(".ui-slider-handle").eq(2).hide()
      $(".ui-slider-handle").eq(1).addClass("red-end-point")
    ###################### Loop Handles ######################
    Jplayer.ready()
    $("#jp_container_1").show()  unless $("#jp_container_1").is(":visible")
    $(".jplayer_div").css("opacity","1")
    event.preventDefault()
    $(".simple_form").submit()
    false

    ######################## Tuner Logic Here #######################
    $(".tune-player").live "click", (event) ->
      event.preventDefault()
      str = $(this).data("str")
      tune = $("#tuning-id-collection").val()
      tune_files = $("#tuner").data("tuning_files")
      tune_index = tune_files.filter (v) ->  v.tuning_file.str_key  == str and v.tuning_file.tuning_id == parseInt(tune)
      tune_file = tune_index[0].tuning_file.file
      $("#jquery_jplayer_1").jPlayer("setMedia", m4a: tune_file ).jPlayer "play", 0
      $(".pop-over-player-controller").addClass("pop_up_play").removeClass("pop_up_pause")

    $('#tuning_model').on 'show' , (event)->
      window.tuner_current_position = $("#jquery_jplayer_1").data("jPlayer").status.currentTime
      window.tuner_current_src = $("#jquery_jplayer_1").data("jPlayer").status.src
      window.tuner_current_loop = $("#loop_piece").val()
      $("#loop_piece").val(false)

    $('#tuning_model').on 'hidden' , (event)->
      $("#loop_piece").val(tuner_current_loop)
      $("#jquery_jplayer_1").jPlayer("setMedia", {
      m4a: tuner_current_src
      }).jPlayer("pause",tuner_current_position)

    $(".pop-over-player-controller").live "click" , (event) ->
      event.preventDefault()
      if $(this).hasClass("pop_up_pause")
        $("#jquery_jplayer_1").jPlayer("pause")
        $(this).addClass("pop_up_play").removeClass("pop_up_pause")
      else if $(this).hasClass("pop_up_play")
        $(this).addClass("pop_up_pause").removeClass("pop_up_play")
        $("#jquery_jplayer_1").jPlayer("pause")
    ##################### Repeat Logic ######################
    $(".repeat-toggle").live "click" , (event) ->
      $("#jquery_jplayer_1").jPlayer "play", 0
