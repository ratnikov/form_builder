module FormBuilder
  module BuilderExtensions
    def self.included base
      base.extend ClassMethods
      base.class_eval do
        form_fields.each do |field_name|
          define_method "apply_#{field_name}_options!" do |options| 
            options
          end
          mixin_apply_options field_name
        end
      end
    end

    module ClassMethods
      def extend_options form_field, &extension_block
        raise "Block missing" if extension_block.blank?
        define_method "apply_#{form_field}_options!" do |options|
          super(options)
          instance_exec options, &extension_block
        end
      end

      def extend_form_fields functionality, &extension
        form_fields.each do |field|
          chain_override field, functionality, &extension 
        end
      end

      private

      def mixin_apply_options field_name
        chain_override field_name, :apply_options do |old, model_name, *args|
          options = args.last.is_a?(Hash) ? args.pop : {}
          send("apply_#{field_name}_options!", options)
          old.call model_name, *(args << options)
        end
      end
    end
  end
end
