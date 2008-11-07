module FormBuilder
  module CaptionsExtension
    include CaptionsExtensionUtil
    attr_accessor :caption_list

    def parse_options_with_captions unparsed_options
      options = parse_options_without_captions unparsed_options
      list =
        if options.has_key?(:captions)
          options.delete(:captions)
        elsif options.has_key?(:caption)
          options.delete(:caption)
        else
          nil
        end
      # list =
      
      self.caption_list = parse_captions_list list
      options
    end

    def captions_tag
      caption_list.nil? ? nil : caption_list.to_tag
    end

    def default_ul_options; { :class => 'mute' } end

    def self.included base
      base.class_eval do
        alias_method_chain :parse_options, :captions
      end
    end
  end
end
