module LibrariesHelper

  def time_zone_localiztion time
      (time.in_time_zone(current_user.time_zone).strftime("%b %d %Y @ %I:%M %p") rescue time.strftime("%b %d %Y @ %I:%M %p") )
  end

  def genrarte_keys piece
    keys = Key.pluck(:title)
    ind = keys.rindex(piece.key.title)
    keys_array = Array.new
    6.times{ ind = 0 if ind == 12; keys_array.push(keys[ind]); ind = ind + 1;  }
    if keys.rindex(keys_array.last) < 12 && keys.rindex(keys_array.last) > 6
      last_index = keys.rindex(keys_array.last)
      inverse_keys = Array.new
      (12-last_index).times{ |x| logger.debug inverse_keys.push(keys[last_index+x]) }
      keys = keys - inverse_keys
      keys = inverse_keys + keys
      keys = keys - keys_array
      keys = keys + keys_array
      keys = keys & piece.audio_files.collect{ |a| Key.find(a.key_id).title}
    end
  end

end
