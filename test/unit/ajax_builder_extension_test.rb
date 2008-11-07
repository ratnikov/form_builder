require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class AjaxBuilderExtensionTest < ActiveSupport::TestCase

    class MockBuilder
      attr_accessor :options, :url, :render_args, :submit_args, :submit_to_remote_args
      def render *args; self.render_args = args; :ajax_render end
      def submit *args; self.submit_args = args; :submit end
      def submit_to_remote *args; self.submit_to_remote_args = args; :submit_to_remote end

      def form_wrap content; "<old>#{content}</old>" end
      def form_options; options[:form] || {} end
      include AjaxBuilderExtension

      public :ajax_submit
    end

    def setup
      @builder = MockBuilder.new
      @builder.options = {:form => { :id => :form_identifier }}
    end

    def test_truth
      assert true
    end

    def test_ajax_submit
      @builder.options[:ajax] = true
      @builder.options[:form] = { :id => :form_identifier }
      @builder.url = :google_com
      assert_equal :submit_to_remote, @builder.submit("foo", :options => { :bar => 'bar' }), "Should call submit_to_remote."
      assert_equal ["submit", "foo", { :options => { :bar => 'bar' }}.merge(:submit => :form_identifier, :url => :google_com) ], 
        @builder.submit_to_remote_args, "Should forward the arguments to submit_to_remote."
    end

    def test_form_wrap_with_ajax
      @builder.options[:ajax] = true
      @builder.url = :google_com
      assert_equal :ajax_render, @builder.form_wrap("foo"), "should use the ajax renderer."
      render_hash = @builder.render_args.first
      assert_equal "form_builder/ajax_form", render_hash[:partial], "Should use the ajax form partial to render."

      assert_equal({:form_content => "foo", :url => :google_com, :div_options => {:id => :form_identifier}}, 
                   render_hash[:locals], "Should use the correct locals and should not inherit :ajax key.")
    end

    def test_extension
      assert_equal "<old>bar</old>", @builder.form_wrap("bar"), "Should use the old wrapper by default."

      @builder.options[:ajax] = true
      assert_equal :ajax_render, @builder.form_wrap("bar"), "Should use the ajax wraper if form_options[:ajax] is true."
      @builder.options[:ajax] = false
      assert_equal "<old>bar</old>", @builder.form_wrap("bar"), "Should use the old wrapper if :ajax if false."
    end
  end
end
