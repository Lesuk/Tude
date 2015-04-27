module FlashHelper
  ALERT_TYPES = ['success', 'info', 'warning', 'danger']

  # flash_message :success, 'Success'
  def flash_message(type, text)
      flash[type] ||= []
      flash[type] << text
  end

  def render_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      compare_type = type.to_s
      compare_type = 'success' if compare_type == 'notice'
      compare_type = 'danger'  if compare_type == 'alert'
      compare_type = 'danger'  if compare_type == 'error'

      next unless ALERT_TYPES.include?(compare_type)

      Array(message).each do |msg|
        flash = content_tag(:li,
                           content_tag(:i, '', :class => "fa fa-lg #{flash_icon_class(compare_type)}") +
                           msg.html_safe, :class => "flash-item -type-#{compare_type}")
        flash_messages << flash if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def flash_icon_class(type)
    case type
    when 'success' then "fa-check-square"
    when 'info' then "fa-info-circle"
    when 'warning' then "fa-warning"
    when 'danger' then "fa-warning"
    end
  end
end
