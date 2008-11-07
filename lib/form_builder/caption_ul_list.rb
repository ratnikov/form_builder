module FormBuilder
  class CaptionUlList
    include Viewable

    attr_accessor :captions, :options

    def initialize captions, options = {}
      parse_options! options
      self.captions = parse_captions(captions)
    end

    def parse_captions captions
      captions.map { |caption_content| CaptionLiTag.parse_caption caption_content, default_li_options }
    end

    def parse_options! options; self.options = options || {} end

    def ul_options; options[:ul] || {} end

    def default_li_options
      options.has_key?(:li) ? {:li => options[:li] } : {}
    end

    def to_tag
      content_tag :ul, captions.map(&:to_tag).join, ul_options
    end

    is_equal_by :captions, :options
  end
end
