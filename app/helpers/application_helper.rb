module ApplicationHelper
  def markdown(str, options = {})
    options[:class] ||= ''
    text = XiangMarkdownConverter.format(str)
    content_tag(:div, raw(text), :class => options[:class])
  end
  def markdown_preview(str, options = {})
    str = str.split(/\n/).slice(0, 3).join("\n")
    if str.scan(/```/).length%2 !=0
      str += "\n...\n```"
    end
    options[:class] ||= ''
    markdown(str, options)
  end

end
