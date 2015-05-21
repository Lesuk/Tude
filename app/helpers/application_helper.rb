module ApplicationHelper

	def gulp_asset_path(path)
    path = REV_MANIFEST[path] if defined?(REV_MANIFEST)
    "/assets/#{path}"
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  #Returns the full title on a per-page basis
  def full_title(page_title)
    base_title = "Edut"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def user_pic_placeholder(num)
    case num
    when 1
      "https://s3.amazonaws.com/uifaces/faces/twitter/jsa/73.jpg"
    when 2
      "https://s3.amazonaws.com/uifaces/faces/twitter/peterlandt/73.jpg"
    else
      "https://s3.amazonaws.com/uifaces/faces/twitter/rem/73.jpg"
    end
  end

  def youtube_thumbnail(id, size)
    case size
    when 'default'
      "https://i.ytimg.com/vi/#{id}/default.jpg"
    when 'mq'
      "https://i.ytimg.com/vi/#{id}/mqdefault.jpg"
    when 'hq'
      "https://i.ytimg.com/vi/#{id}/hqdefault.jpg"
    when 'maxres'
      "https://i.ytimg.com/vi/#{id}/maxresdefault.jpg"
    else
      "#{gulp_asset_path('images/thumb-placeholder.png')}"
    end
  end

  def set_duration(duration)
    if ( (duration > 0) && (duration < 3600) )
      Time.at(duration).utc.strftime("%M:%S")
    elsif (duration >= 3600)
      Time.at(duration).utc.strftime("%H:%M:%S")
    end
  end

  def insert_time_tag(time, classes)
    time_tag(time, title: "#{time.to_s(:shortdate)}", class: "#{classes}") do
      get_time_value(time)
    end
  end

  def get_time_value(time)
    time > (Time.now - 1.days) ? time_ago_in_words(time) + " ago" : time.to_s(:shortdate)
  end

  def wilson_score(up, down)
    return 0.0 unless up + down > 0

    z = 1.96
    n = up + down
    phat = up / n.to_f

    begin
      score = (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
    rescue Math::DomainError
      score = 0
    end
  end

  # OPTIMIZE
  def activity_icon(type, key)
    if type == 'Course' && key == 'create'
      'fa-tasks'
    elsif type == 'Article' && key == 'create'
      'fa-file-text'
    elsif type == 'Comment' && key == 'create'
      'fa-comment'
    elsif type == 'Comment' && key == 'mention'
      'fa-bullhorn'
    elsif type == 'Question' && key == 'create'
      'fa-question'
    elsif type == 'User' && key == 'start'
      'fa-chevron-circle-right'
    elsif type == 'User' && key == 'completed'
      'fa-graduation-cap'
    elsif type == 'User' && key == 'favorited'
      'fa-star'
    elsif type == 'User' && key == 'subscribe'
      'fa-rss'
    elsif type == 'Review' && key == 'create'
      'fa-pencil'
    end
  end
end
