require File.dirname(__FILE__) + '/../../test_helper'

class FormBuilder::BasicFormBuilderTest < ActiveSupport::TestCase
  class MockTemplate
    def initialize options = {}
      options.each_pair { |k,v| send("#{k}=", v) if respond_to?("#{k}=") }
    end
  end

  class MockBuilder < FormBuilder::BasicFormBuilder
    attr_accessor :template
    def initialize options = {}
      options.each_pair { |k,v| send("#{k}=", v) if respond_to?("#{k}=") }
    end

    def foo content, options = {}
      "<foo #{options.keys.map { |k| "#{k}=#{options[k]}"}.join ' ' }>#{content}</foo>"
    end

    def apply_foo_options! options; options end
    mixin_apply_options :foo

    self.form_fields += [ "foo" ]
  end

  def setup
    @builder = MockBuilder.new :template => MockTemplate.new
  end

  def test_truth
    assert true
  end

  def test_form_fields
    assert_equal %w(label text_field password_field hidden_field file_field text_area check_box radio_button submit).sort, FormBuilder::BasicFormBuilder.form_fields.sort,
      "Should contain all required html fields."
  end

  def test_extending_options
    class << @builder
      extend_options :foo do |options|
        options.reverse_merge!(:foo => :bar)
      end
    end

    options = { }; @builder.apply_foo_options!(options)
    assert_equal({:foo => :bar}, options, "Should have destructively updated options to have the :foo key.")

    options[:foo] = "Bar"; @builder.apply_foo_options!(options)
    assert_equal({:foo => "Bar"}, options, "Should not have changed the options.")
  end

  def test_form_wrapp
    class << @builder.template
      attr_accessor :render_args
      def render *args
        self.render_args = args
        :render
      end
    end

    assert_equal(:render, @builder.send(:form_wrap, "content"), "Should return whatever the render returns.")

    render_hash = @builder.template.render_args.first
    assert_equal "form_builder/basic_form", render_hash[:partial], "Should render the basic form partial."

    render_locals = render_hash[:locals] or flunk("Render should specify local variables.")
    assert_equal "content", render_locals[:form_content], "Should use the content specified as form_wrap parameter."
    assert_equal @builder.url, render_locals[:url], "Should use the builder url as form url."
    assert_equal @builder.form_options, render_locals[:form_options], "Should use builder's html options as form options."
  end

  def test_template_delegation
    class << @builder.template 
      attr_accessor :bar_invoked
      def bar
        self.bar_invoked = true
      end
    end

    assert !@builder.respond_to?(:bar), "Builder should not respond to bar directly."
    assert_nothing_raised "Should not complain about #bar not found." do
      @builder.bar
    end
    assert @builder.template.bar_invoked, "Template's #bar should have been invoked."
  end

  MockBuilder.form_fields.each do |form_field|
    define_method "test_#{form_field}" do
      @builder.metaclass.class_eval do
        attr_accessor :bar_options
        define_method "apply_#{form_field}_options!" do |options|
          options.merge!(:bar => bar_options) unless bar_options.nil?
        end

        define_method "#{form_field}_without_apply_options" do |name, *args|
          options = args.pop || {}
          [name, options]
        end
      end

      options = { :foo => :test }
      assert_equal [:bar, options], @builder.send(form_field, :bar, options.dup), "Should invoke using name and unedited options."

      mendable_options = options.dup; @builder.bar_options = :blah
      assert_equal [:bar, options.merge(:foo => :test, :bar => :blah)], @builder.send(form_field, :bar, mendable_options), "Should use the updated options."
      assert_equal options.merge(:bar => :blah), mendable_options, "should destructively update options hash."
    end
  end
end
