class AudioFile < ActiveRecord::Base
  attr_accessible :pitch, :tempo , :instrument_id , :file , :piano_type_id , :tuning_id , :key_id

  mount_uploader :file , AudioFileUploader
  before_save :update_asset_attributes

  belongs_to :piece
  belongs_to :piano_type
  belongs_to :tuning
  belongs_to :key

  scope :find_piece_audio_file , lambda { |piece_id,tempo,piano_type,key,tuning| AudioFile.where("piece_id = ? and tempo = ? and key_id = ? and piano_type_id = ? and tuning_id = ?",piece_id,tempo,key,piano_type,tuning) }

  private

  def update_asset_attributes
    if file.present? && file.file.content_type == "audio/x-m4a"
      file.file.content_type = "audio/mp4"
    end
  end

end
