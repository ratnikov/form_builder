module FormBuilder
  module BuilderHelper
    def custom_form_for *args, &block
      (object_name, object, *extra_args) = parse_form_for_args! args; options = extra_args.pop

      builder = (options.delete(:builder) || ActionView::Base.default_form_builder).new object_name, object, self, options, block
      builder.render_form &block
    end

    # destructively updates args from form_for format to field_for format, i.e. to format:
    # [ object_name, object, *extra_args, options ]
    # NOTE:
    #   <tt>object</tt> is nil when <tt>object_name</tt> is a <tt>String</tt> or <tt>Symbol</tt>.
    #   All fields should always be present, except for <tt>extra_args</tt>, which will be not present 
    #   if args has two or less non-option items.
    def parse_form_for_args! args
      options = args.extract_options!

      record_or_name_or_array = args.shift
      case record_or_name_or_array
      when String, Symbol
        object_name = record_or_name_or_array
        args.unshift nil
      when Array
        object = record_or_name_or_array.last
        object_name = ActionController::RecordIdentifier.singular_class_name object
        apply_form_for_options!(record_or_name_or_array, options)
        args.unshift object
      else
        object = record_or_name_or_array
        object_name = ActionController::RecordIdentifier.singular_class_name object
        apply_form_for_options!([object], options)
        args.unshift object
      end
      args.unshift object_name
      args << options
      args
    end
  end
end
