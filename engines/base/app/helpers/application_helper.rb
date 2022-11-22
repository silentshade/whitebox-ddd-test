module ApplicationHelper
  unless const_defined?(:ALERT_TYPES)
    ALERT_TYPES = { notice: :success,
                    info: :info,
                    warning: :warning,
                    alert: :danger,
                    error: :danger }.freeze
  end

  def bootstrap_flash(options = {})
    tag_class = options.extract!(:class)[:class]

    flash.select(&:present?).map do |type, message|
      type = ALERT_TYPES[type.to_sym] || type.to_sym
      next unless ALERT_TYPES.values.uniq.include?(type)

      tag_options = {
        class: "alert fade show alert-dismissible alert-#{type} #{tag_class}"
      }.merge(options)

      close_button = content_tag(:button, '', type: "button", class: "btn-close", 'data-bs-dismiss': :alert)

      Array(message).flatten.compact.map do |msg|
        message = content_tag(:span, sanitize(msg.to_s, tags: %w[i b strong em].freeze))
        content_tag(:div, message + close_button, tag_options)
      end
    end.flatten.compact.join("\n").html_safe
  end
end
