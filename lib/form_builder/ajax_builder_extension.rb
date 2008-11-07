module FormBuilder
  module AjaxBuilderExtension
    def self.included base
      base.class_eval do
        alias_method_chain :form_wrap, :ajax
        alias_method_chain :submit, :ajax
      end
    end

    def form_wrap_with_ajax content
      if ajax_form? 
        ajax_form_wrap content
      else
        form_wrap_without_ajax content
      end
    end

    def submit_with_ajax *args
      if ajax_form?
        ajax_submit *args
      else
        submit_without_ajax *args
      end
    end

    def ajax_form?; options[:ajax] end

    def form_id
      form_options.has_key?(:id) ? options[:form][:id] : dom_id(object)
    end

    def div_options
      form_options.merge :id => form_id
    end

    private

    def ajax_form_wrap content
      render :partial => "form_builder/ajax_form", :locals => { :form_content => content, :url => url, :div_options => div_options}
    end

    def ajax_submit value, options = {}
      submit_to_remote "submit", value, options.merge(:submit => form_id, :url => url) 
    end
  end
end
