module MentionsHelper

  # OPTIMIZE with calling users model
  def text_with_mentions(text)
    text.gsub(/@([A-Za-z0-9_]{3,15})/).each do |userName|
      user = User.find_by_username(userName[1..-1])
      if user
        link_to userName, user_path(user)
      else
        userName
      end
    end
  end

end
