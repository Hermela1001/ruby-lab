class ApplicationController < ActionController::Base
  include ActionView::Helpers::DateHelper
  before_action :track_visits
  before_action :set_greeting

  private

  def track_visits
    session[:visit_counts] ||= {}
    session[:total_visits] ||= 0

    current_page = request.path
    session[:visit_counts][current_page] ||= 0
    session[:visit_counts][current_page] += 1
    session[:total_visits] += 1

    @page_visits = session[:visit_counts][current_page]
    @total_visits = session[:total_visits]

    if session[:last_visit_time]
      @last_visited_ago = time_ago_in_words(Time.at(session[:last_visit_time]))
    end

    session[:last_visit_time] = Time.now.to_i
  end

  def set_greeting
    hour = Time.now.hour
    @greeting =
      case hour
      when 5..11 then "Good morning!"
      when 12..16 then "Good afternoon!"
      when 17..20 then "Good evening!"
      else "Good night!"
      end
  end
end