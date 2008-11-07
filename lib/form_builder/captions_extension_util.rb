module FormBuilder
  module CaptionsExtensionUtil
    def parse_captions_list list
      caption_list_options = (list.respond_to?(:last) and list.last.is_a?(Hash)) ? list.pop : {}
      caption_list_options.merge!(:ul => default_ul_options) unless default_ul_options.blank?

      list.blank? ? nil : CaptionUlList.new(list, caption_list_options)
    end
  end
end
