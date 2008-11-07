module FormBuilder
  class DivCell < FormCell
    attr_accessor :div_options

    def to_tag_with_div
      content_tag :div, div_options do
        head = label.nil? ? nil : label_tag
        cell = content_tag :p, [to_tag_without_div, captions_tag].join
        [head, cell].compact.join
      end
    end
    alias_method_chain :to_tag, :div

    def label_tag_with_p
      content_tag :p do
        label_tag_without_p
      end
    end
    alias_method_chain :label_tag, :p

    def parse_options_with_div unparsed_options
      options = parse_options_without_div unparsed_options
      self.div_options = parse_div_options(options.delete(:div) || {})
      options
    end
    alias_method_chain :parse_options, :div

    def parse_div_options options
      options.reverse_merge(:class => 'field')
    end
  end
end
