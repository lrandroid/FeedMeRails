class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    unless User.find_by_facebook_id(params[:user][:facebook_id])
      @user = User.new(params[:user])
      @user.profile_pic_url = "http://graph.facebook.com/#{params[:user][:facebook_id]}/picture?type=square"
    else
      @user = User.find_by_facebook_id(params[:user][:facebook_id])
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
    end

    restaurant = Restaurant.find(params[:restaurant_id])
    menu = restaurant.menu
    @dishes = menu.dishes
    table_id = params[:table_id]
    
    respond_to do |format|
      if @user.save
        unless Customer.find_by_user_id_and_restaurant_id_and_is_active(@user.id, restaurant.id, true)
          customer = Customer.new
          customer.is_active = true
          customer.restaurant_id = restaurant.id
          customer.table_id = table_id
          customer.user_id = @user.id
          customer.save
        end
        format.html { redirect_to @user }
        format.json { render json: @dishes }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
