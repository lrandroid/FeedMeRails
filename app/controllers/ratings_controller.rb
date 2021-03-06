class RatingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ratings }
    end
  end

  # GET /ratings/1
  # GET /ratings/1.json
  def show
    @rating = Rating.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rating }
    end
  end

  # GET /ratings/new
  # GET /ratings/new.json
  def new
    @rating = Rating.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rating }
    end
  end

  # GET /ratings/1/edit
  def edit
    @rating = Rating.find(params[:id])
  end

  # POST /ratings
  # POST /ratings.json
  def create
    @rating = Rating.new(params[:rating])
    facebook_id = params[:rating][:user_id]
    @user = User.find_by_facebook_id(facebook_id)
    @rating.user_id = @user.id
    dish = Dish.find(params[:rating][:dish_id])    
    @rating.dish_id = dish.id   
  
    respond_to do |format|
      if @rating.save
        if @rating.value == 1
          dish.upvotes += 1
        else
          dish.downvotes += 1
        end
        dish.save
        format.html { redirect_to @rating, notice: 'Rating was successfully created.' }
        format.json { render json: @rating, status: :created, location: @rating }
      else
        format.html { render action: "new" }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ratings/1
  # PUT /ratings/1.json
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to @rating, notice: 'Rating was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.json
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy

    respond_to do |format|
      format.html { redirect_to ratings_url }
      format.json { head :no_content }
    end
  end

  def search
    restaurant = Restaurant.find(params[:restaurant_id])
    menu = restaurant.menu
    @ratings = []
    menu.dishes.each do |dish|
      dish.ratings.each do |rating|
        @ratings.push(rating)
      end
    end

    respond_to do |format|
      format.json { render json: @ratings }
    end
  end
end
