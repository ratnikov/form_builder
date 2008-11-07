module FormBuilder
  class FormCell
    attr_accessor :tag_builder, :name, :extra_builder_args, :options

    def initialize tag_builder, name, *extra_args
      self.name = name
      self.options = extract_options! extra_args
      self.tag_builder, self.extra_builder_args = tag_builder, extra_args
    end

    def to_tag
      tag_builder.call name, *(extra_builder_args + [options])
    end

    def parse_options options; options end
    def extract_options! args; parse_options(args.last.is_a?(Hash) ? args.pop : {}) end

    def enabled?; options.has_key?(:make_cell) ? options[:make_cell] : true end

    include Viewable
    include LabelExtension
    include CaptionsExtension
  end
end
