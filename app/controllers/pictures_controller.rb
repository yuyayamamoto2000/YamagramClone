class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :current_user
  before_action :logged_in?
  before_action :authenticate_user
  before_action :check_user, only: [:edit,:update,:destroy]

  def index
    @pictures = Picture.all
  end

  def new
    @picture = Picture.new
    @picture.user_id = current_user.id
  end

  def create
    @picture = current_user.pictures.build(picture_params)
    if params[:back]
       render :new
    else
      if @picture.save
        # redirect_to pictures_path, notice: '投稿しました。'
        PictureMailer.picture_mail(@picture).deliver
        redirect_to pictures_path, notice: 'Contact was successfully created.'
      else
        render :new
      end
    end
  end

  def show
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  def edit
  end

  def update
    if @picture.update(picture_params)
      redirect_to pictures_path, notice: "投稿を編集しました。"
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice: "ブログを消去しました!"
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
  end

  private

  def picture_params
    params.require(:picture).permit(:id, :image, :image_cache,:user_id, :content)
  end

  def set_picture
    @picture = Picture.find(params[:id])
  end
end
