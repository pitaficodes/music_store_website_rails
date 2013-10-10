class PiecesController < ApplicationController
  require 'open-uri'

  def index
    @search = Piece.search(params[:search])
  end
  def log
    piece = UserPiece.find_piece_user(current_user.id , params[:id])[0]
    params[:user_piece].merge!({ user_id: current_user.id , piece_id: params[:id].to_i })
    piece.blank? ?  ( UserPiece.create(params[:user_piece]) ): (piece.update_attributes params[:user_piece])
    if piece.blank?
      render json: "Failure"
    else
      render json: "Success"
    end
  end

  def find_audio_file
    params[:user_piece]= params[:audio_file]
    piece = UserPiece.find_piece_user(current_user.id , params[:user_piece][:piece_id])[0]
    #params[:user_piece].merge!({ user_id: current_user.id , piece_id: params[:id].to_i })
    piece.blank? ?  ( piece=UserPiece.create(params[:user_piece]) ): (piece.update_attributes params[:user_piece])
    if piece.blank?
      render json: "Failure"
    else
      piece.last_played =  DateTime.now.utc
      piece.save
      render json: "Success"
    end
    #@piece_id = params[:audio_file][:piece_id]
    #@key_id = params[:audio_file][:key]
    #@piano_type_id=  params[:audio_file][:piano_type]
    #@tuning_id = params[:audio_file][:tuning]
    #@audio_file = AudioFile.where("piano_type_id = ? and key_id = ? and  tuning_id = ? and piece_id = ?",@piano_type_id,@key_id,@tuning_id,@piece_id).first
  end
  def load_piece
    @piece = Piece.find_by_id(params[:id])

  end
  def piece_request
    title = params[:title]
    composer =params[:composer]
    UserMailer.send_piece_request(current_user,title,composer).deliver
  end

  def allow_stream
    if ( request.env["HTTP_REFERER"].include?("http://localhost")  || request.env["HTTP_REFERER"].include?("http://pianoamigo")) && current_user.subscription.try(:is_subscribed?)
      file = AudioFile.find(params[:id]).file
      send_data open(file.to_s).read, type: "audio/mp4", disposition: 'inline' , :stream =>  'true'
    end
  end

end