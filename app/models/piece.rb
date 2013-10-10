class Piece < ActiveRecord::Base
  attr_accessible :id ,:price, :style, :title , :composer_id , :tag_ids , :audio_files_attributes , :library_ids , :is_active , :instrument_ids, :piano_type_id, :key_id, :tuning_id, :videourl , :tempo , :professional_performance , :sheet_music
  has_many :audio_files, :dependent => :destroy
  #has_and_belongs_to_many :instruments
  belongs_to :composer
  has_and_belongs_to_many :libraries
  belongs_to :piano_type
  belongs_to :key
  belongs_to :tuning
  has_and_belongs_to_many :instruments
  has_many :user_pieces, :dependent => :destroy
  has_many :users ,through: :user_pieces
  has_many :orders  , through: :orders_pieces
  has_many :parent_tags, class_name: "PieceTag", foreign_key: :parent_tag_id
  has_many :tags, source: :piece, through: :parent_tags

  accepts_nested_attributes_for :audio_files, :allow_destroy => true, :reject_if => lambda { |a| a['tempo'].blank? }
  accepts_nested_attributes_for :tags

  validates_uniqueness_of :id
  validates_presence_of :title , :composer , :instruments , :tempo , :tuning , :id , :libraries , :piano_type , :tuning , :key
  validates_format_of :sheet_music, :with => URI::regexp(%w(http https)) , allow_blank: true
  validates_format_of :professional_performance, :with => URI::regexp(%w(http https)) , allow_blank: true
  validates_format_of :videourl, :with => URI::regexp(%w(http https)) , allow_blank: true

  
#Search Function by Fakhar Khan @DevBatch
def self.searched(search)

    string_query=""
    str_instrument =""
    unless  search.nil?

      unless search[:instruments_id_eq].nil?
        if !search[:instruments_id_eq].to_s.empty?
          str_instrument = "AND  (instruments.id ="+search[:instruments_id_eq].to_s+" )"
        end
      end

      unless search[:composer_first_name_or_composer_last_name_or_title_contains].nil?
        query=""
        query=search[:composer_first_name_or_composer_last_name_or_title_contains].to_s
        search =query
        search.split.map { |name|
          string_query = string_query +" CONCAT(composers.first_name,composers.last_name,pieces.title) ilike '%#{name}%' AND "
        }
        string_query =string_query.chomp('AND ')

        if !string_query.empty?
          string_query =" AND ("+string_query+" )"
        end
      end


    end
    find_by_sql "
        SELECT pieces.* FROM pieces
          LEFT OUTER JOIN composers ON composers.id = pieces.composer_id
          LEFT OUTER JOIN instruments_pieces ON instruments_pieces.piece_id = pieces.id
          LEFT OUTER JOIN instruments ON instruments.id = instruments_pieces.instrument_id
        WHERE 1=1 #{str_instrument}  #{string_query} "

  end
end
