ActiveAdmin.register AudioFile  do

  menu :parent => "Piece Management"

  form partial: "audio_files_uploder"

  index do
    selectable_column
    column :id
    column :piece_id
    column :key
    column :piano_type
    column :created_at
    column :updated_at
    default_actions
  end

  filter :id
  filter :piece_id
  filter :piano_type
  filter :key
  filter :tempo
  filter :created_at
  filter :updated_at


  controller do
    def create
      attr = params[:audio_file][:file].original_filename.scan(/(=.+?\])/).collect!{ |x| x[0].gsub('=','').gsub(']','').gsub(/[^0-9A-Za-z#]/, '') }
      ################# Parse Keys ##################
      attr[2] = attr[2].gsub(/[^A-Za-z#]/, '')
      keys_hash = { "A" => "A" , "A#" => "A#",  "Bb" => "A#" , "B" => "B", "C" => "C" , "C#" => "C#" , "Db" => "C#", "D" => "D", "D#" => "D#", "Eb" => "D#", "E" => "E" , "F" => "F", "F#" => "F#", "F#" => "F#" , "Gb" => "F#" , "G" => "G" , "G#" => "G#" , "Ab" => "G#" }
      key = Key.find_by_title(keys_hash[attr[2]])
      piece = Piece.try(:find_by_id,attr[0])
      ################# Parse Keys ##################
      if key.blank? or  piece.blank?
        @message = "Invalid File Piece ID #{attr[0]} Piano Type #{attr[1]} Key #{attr[2]} Tuning #{attr[4]} Tempo #{attr[3]} Please Check the Format"
      else
        tuning = Tuning.find_by_tuning(attr[4]).blank? ? Tuning.create( tuning: attr[4]) : Tuning.find_by_tuning(attr[4])
        existing = AudioFile.find_piece_audio_file(attr[0] , attr[3] , attr[1] , key.id , tuning.id)
        @audio_file = existing.blank? ? AudioFile.new : existing.first
        @audio_file.file = params[:audio_file][:file]
        @audio_file.piece_id = attr[0]
        @audio_file.piano_type_id = attr[1]
        @audio_file.key = key
        @audio_file.tempo = attr[3]
        @audio_file.tuning = tuning
        @audio_file.save
        @message = ""
      end
    end
  end

end
