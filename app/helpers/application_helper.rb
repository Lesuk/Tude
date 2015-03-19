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

  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
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

end
