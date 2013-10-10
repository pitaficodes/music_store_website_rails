class PieceTag < ActiveRecord::Base
  belongs_to :piece
  belongs_to :parent_tag, class_name: "Piece"
  # attr_accessible :title, :body
end
