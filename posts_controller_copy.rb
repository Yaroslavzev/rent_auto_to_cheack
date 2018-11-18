
class PostsController < ApplicationController

  def index
    @cost = calculator(post_params['start_time'].to_time,post_params['end_time'].to_time)
    render json: @cost
  end

  private
  def post_params
    params.permit(:start_time,:end_time,:model)
  end
  def calculator(start_time,end_time)
    cost1 = 1000
    cost2 = 900
    cost3 = 800
    costworkday = 4500
    costweekend = 1
    @start_time = start_time
    @end_time = end_time
    @rent_days = ((@end_time - @start_time)/1.day).to_i
    @start_time_day = post_params['start_time'].to_date
    @end_time_day = post_params['end_time'].to_d
    if @rent_days <= 6
      if (@start_time_day..@end_time_day).select {|d| (1..5).include?(d.wday)}.size === 5
        if @rent_days === 6
          @cost = costworkday + cost1
        else
          @cost = costworkday
        end
      elsif (@start_time_day..@end_time_day).select {|d| 6.eql?(d.wday) or 0.eql?(d.wday) }.size === 2
        @cost = (@rent_days-2) * cost1 + costweekend
      else
        @cost = @rent_days * cost1
      end
    elsif @rent_days <= 20
      @cost = @rent_days * cost2
    else
      @cost = @rent_days * cost3
    end
    return @cost
  end
end
