class UserPiece < ActiveRecord::Base
  attr_accessible :updated_at, :created_at, :current_index, :current_key, :current_tempo, :user_id,:piece_id , :is_favourite , :loop_delay, :current_tuning, :current_key, :current_piano_type, :loop_end, :loop_piece, :loop_start, :volume
  belongs_to :user
  belongs_to :piece

  scope :find_piece_user , lambda { |user_id,piece_id| where("user_id = ? and piece_id =? " , user_id , piece_id)  }

end