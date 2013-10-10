class LibrariesController < ApplicationController
  authorize_resource class: false
   before_filter :library, only: [:show,]
   before_filter :set_breadcrumb, only: [:show,:history,:personal]

  before_filter :check_subscription_validity


  def check_subscription_validity
    if (current_user and current_user.subscription and !(current_user.subscription.credit_card_num.nil?))
      if((current_user.subscription.end_date).to_date < DateTime.now.to_date)
        redirect_to pricing_info_index_path
      end
    else
      if((current_user.created_at+15.days).to_date < DateTime.now.to_date)
        redirect_to pricing_info_index_path
      end
    end
  end


  helper_method :sort_column, :sort_direction

  def index
    user = User.find(current_user.id)
    if user && user.password_reset==false
      @search = Piece.search(params[:search])
      @matching_pieces = Piece.searched(params[:search])
      @libraries = Array.new
      if !params[:instrument_id].blank?
        user.update_attributes(:last_instrument_id => params[:instrument_id])
      end
      unless params[:instrument_id].blank? and params[:in_search].blank?
        Piece.search(instruments_id_eq: params[:instrument_id]).each { |p|  p.libraries.each { |lib| @libraries.push lib  } }
        @libraries = @libraries.uniq
      end
      @libraries = Library.order(:title).all #unless !params[:in_search].blank?
    else
       redirect_to edit_user_registration_path
    end
  end

  def show
    if params[:related_piece].blank?
      if !params[:instrument_id].blank?
        user = User.find(current_user.id)
        user.update_attributes(:last_instrument_id => params[:instrument_id])
      end
     @search = Piece.search(params[:search])
     @matching_pieces = Piece.searched(params[:search])
     @lib= Library.all
     @pieces = @library.pieces.order(sort_column + ' ' + sort_direction).where("is_active = ?",true).metasearch instruments_id_eq: params[:instrument_id]
    else
      @pieces = Array.new
      @pieces.push Piece.find(params[:related_piece])
    end
  end

  def enable_favourite
    piece = UserPiece.find_piece_user(current_user.id , params[:id])[0]
    piece.blank? ?  ( UserPiece.create user_id: current_user.id, piece_id: params[:id] , is_favourite: true ): (piece.update_attributes is_favourite: true)
    unless piece.blank?
      render json: "Yes"
    else
      render json: "No"
    end
  end

  def disable_favourite
    if UserPiece.find_piece_user(current_user.id , params[:id])[0].update_attributes is_favourite: false
      render json: "Updated"
    else
      render json: "Error"
    end

  end
  def personal
    @pieces =current_user.pieces.order(:title).where("is_favourite = ? AND is_active = ?", true,true)#.metasearch instruments_id_eq: params[:instrument_id]
    @lib = Library.order(:title).all
  end
  def history
    @pieces = current_user.pieces.order(:title).where("is_active = ?",true)#.metasearch instruments_id_eq: params[:instrument_id]
    @lib = Library.order(:title).all
    respond_to do |format|
      format.html # index2.html.erb
      format.json { render json: @libraries }
    end
  end

  def library
    @library = Library.find(params[:id])
  end

  helper_method :set_breadcrumb

  def set_breadcrumb
    if params[:instrument_id]==""
      if @library
        "#{@library.title.capitalize}"
      else
        "Search"
      end
    else
      if @library
        "#{(Instrument.find(params[:instrument_id]).to_s.capitalize rescue params[:related_piece].blank? ? "Search" : "Related Piece")} > #{@library.title.capitalize} "
      else
        "#{(Instrument.find(params[:instrument_id]).to_s.capitalize rescue params[:related_piece].blank? ? "Search" : "Related Piece")} >"
      end
    end
  end
  def inner_libraries

  end
  private
  def sort_column
    Piece.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end


end