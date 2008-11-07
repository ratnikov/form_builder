module FormBuilder
  module LabelCaptionsExtension
    include CaptionsExtensionUtil
    attr_accessor :label_caption_list

    def parse_options_with_label_captions unparsed_options
      options = parse_options_without_label_captions unparsed_options

      self.label_caption_list = parse_captions_list options.delete(:label_captions)
      options
    end

    def label_captions_tag
      label_caption_list.nil? ? nil : label_caption_list.to_tag
    end

    def default_ul_options; { :class => 'mute' } end

    def self.included base
      base.class_eval do
        alias_method_chain :parse_options, :label_captions
      end
    end
  end
end
