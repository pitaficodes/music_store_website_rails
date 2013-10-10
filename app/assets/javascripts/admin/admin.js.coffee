jQuery ->
  $(".audio_file").fileupload
    dataType: "script"
    add: (e, data) ->
      types = /(\.|\/)(mp3|m4a|acc)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        data.context = $(tmpl("template-upload", file))
        $('#files_uploading').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 95, 10)
        data.context.find('.bar').css('width', progress + '%')
    done: (e,data) ->
      data.context.remove() if data.context



