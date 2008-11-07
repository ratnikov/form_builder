module FormBuilder
  class BasicFormBuilder < ActionView::Helpers::FormBuilder

    class_inheritable_accessor :form_fields
    self.form_fields = %w(label text_field password_field hidden_field file_field text_area check_box radio_button submit)

    def render_form &block
      raise ArgumentError, "Missing block" if block.blank?
      content = full_form_wrap capture(self, &block)

      if block_is_within_action_view? block
        concat content, block.binding
      else 
        content
      end
    end

    def full_form_wrap content
      form_wrap(content)
    end

    def method_missing method_name, *args
      if method_name =~ /_options$/ and respond_to?(method_name+'!')
        send(method_name+'!', args.map(&:dup))
      else
        super(method_name, *args)
      end
    end

    def method_missing method_name, *args, &block
      if @template.respond_to?(method_name)
        @template.send method_name, *args, &block
      else
        super(method_name, *args)
      end
    end

    include BuilderExtensions

    def options; super || {} end

    def url; options[:url] end
    def form_options; apply_form_options(options[:form] || {}) end

    def apply_form_options options; options end

    def form_wrap content = nil, &block
      content = capture(&block) unless block.blank?
      render :partial => "form_builder/basic_form", :locals => { :form_content => content, :url => url, :form_options => form_options }
    end

    include AjaxBuilderExtension
  end
end
