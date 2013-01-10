#encoding: utf-8

module Redcarpet
  module Render
    class XiangMarkdown < HTML
      def initialize(extensions={})
        super(extensions.merge(
          :filter_html => true,
          :hard_wrap => true
        ))
      end

      def block_code(code, language)
        language = 'text' if language.blank?
        begin
          Pygments.highlight(code, lexer: language, formatter: 'html', options: {encoding: 'utf-8'})
        rescue
          Pygments.highlight(code, lexer: 'text', formatter: 'html', options:{encoding: 'utf-8'})
        end
      end
    end
  end
end

class XiangMarkdownConverter
  include Singleton

  def self.convert(text)
    self.instance.convert(text)
  end

  def convert(text)
    @converter.render(text)
  end

  def self.format(raw)
    text = raw.clone
    return '' if text.blank?

    # 如果 ``` 在刚刚换行的时候 Redcapter 无法生成正确，需要两个换行
    text.gsub!("\n```","\n\n```")
    result = self.convert(text)
    self.tooltip(result)
    return result.strip
  end

  def self.preview_markdwon(str)
    content = format(str)
    %(<article><div class="content">#{content}</div></article>)
  end

  private
  def self.tooltip(str)
    # [foo]t(http://example.com/ | tooltip)
    # link_to 'foo', rel: 'tooltip', 'data-original-title' => 'tooltip', 'data-placement' => 'left'
    str.gsub!(/\[(.+?)\]t\((.+?)\)/) do |s|
      text = $1.strip
      attrs = $2.split('|')
      attrs.each do |attr|
        attr.strip!
      end
      attrs[0] = 'javascript:;' if attrs[0].blank?
      %(<a href="#{attrs[0]}" rel="tooltip" data-original-title="#{attrs[1]}" data-placement="top">#{text}</a>)
    end
  end
  def initialize
    @converter = Redcarpet::Markdown.new(Redcarpet::Render::XiangMarkdown.new, {
        :autolink => false,
        :fenced_code_blocks => true,
        :no_intra_emphasis => true
      })
  end
end
