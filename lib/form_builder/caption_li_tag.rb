module FormBuilder
  class CaptionLiTag
    include Viewable

    attr_accessor :content, :options
    def initialize content, options = {}
      self.content = content
      parse_options! options
    end

    def parse_options! options; self.options = options end

    def li_options; parse_li_options(options[:li] || {}) end
    def parse_li_options options; options end

    def to_tag
      content_tag :li, content, li_options
    end

    def self.parse_caption content_arr, default_options = {}
      content_arr = [content_arr] unless content_arr.is_a?(Array)
      
      content, specific_options = content_arr.first(2)
      new content, default_options.merge(specific_options || {})
    end

    is_equal_by :content, :options
  end
end
