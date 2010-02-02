# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def google_jquery_script_tags
    javascript_include_tag 'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js',
                           'http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js'
  end
  
  def flash_divs
    markup = []
    [:info, :notice, :error].each do |key|
      unless flash[key].blank?
        markup << content_tag(:div, flash[key], :class => "#{key.to_s} flash")
      end
    end
    markup.join("\n")
  end
  
end
