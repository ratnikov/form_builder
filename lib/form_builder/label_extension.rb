module FormBuilder
  module LabelExtension
    attr_accessor :label

    def parse_options_with_label options
      parsed_options = parse_options_without_label options
      self.label = parsed_options.has_key?(:label) ? parsed_options.delete(:label) : name.to_s.humanize
      parsed_options
    end

    def label_tag
      content_tag :label, [label, label_captions_tag].compact.join, {:for => name }
    end

    def self.included base
      base.class_eval do
        include LabelCaptionsExtension
        alias_method_chain :parse_options, :label
      end
    end
  end
end
