class BookroomsController < ApplicationController
  before_action :check_valid_date,
    only: [:slots]

  def index
    @bookings = Bookroom.all
  end

  def create
    @new_room = Bookroom.new
    @room_title = Meetingroom.distinct.pluck(:room_title).sort
    params[:bookroom][:slot].each do |slot|
      if slot != ""
        @bookroom = Bookroom.create(params.require(:bookroom).permit(:date_start, :meetingroom_id))
        @bookroom.slot = slot
        @bookroom.price = 10
        @bookroom.user_id = current_user.id
        @bookroom.save
      end
    end
    redirect_to bookrooms_path
  end

  # def new
  #   @new_room = Bookroom.new
  #   @room_title = Meetingroom.distinct.pluck(:room_title).sort
  #   params[:bookroom][:slot].each do |slot|
  #     if slot != ""
  #       @bookroom = Bookroom.create(params.require(:bookroom).permit(:date_start, :meetingroom_id))
  #       @bookroom.slot = slot
  #       @bookroom.price = 10
  #       @bookroom.user_id = current_user.id
  #       @bookroom.save
  #     end
  #   end
  #   redirect_to bookrooms_path
  # end

  def slots
      @available_slots = ['7:00 AM','8:00 AM','9:00 AM','10:00 AM','11:00 AM','12:00 PM','1:00 PM','2:00 PM','3:00 PM','4:00 PM','5:00 PM','6:00 PM','7:00 PM']
      # render json: params
      roomID = Meetingroom.find_by(room_title: params[:bookroom][:meetingroom_id]).id
      @bookroom = Bookroom.new
      @bookroom.meetingroom_id = roomID
      @bookroom.date_start = params[:bookroom][:date_start]

      slots_same_date = Bookroom.where(date_start: params[:bookroom][:date_start])

      taken_slots = slots_same_date.map do |slot|
        slot.slot if slot.meetingroom_id == roomID
      end

      @available_slots = @available_slots - taken_slots
    end

  def new
    @bookroom = Bookroom.new
    @meetingrooms = Meetingroom.all
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def check_valid_date
    if Date.today > Date.parse(params[:bookroom][:date_start])
      flash[:date_error] = "Please input a valid date"
      redirect_to new_bookroom_path
    end
  end

end
