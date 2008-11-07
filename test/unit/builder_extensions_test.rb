require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class BuilderExtensionsTest < ActiveSupport::TestCase
    def setup
      @builder = Class.new do
        def foo *args; args end

        def self.form_fields; %w(foo) end
        include BuilderExtensions
      end.new
    end

    def test_truth
      assert true
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

    def test_field_override
      class << @builder
        attr_accessor :bar_options
        extend_options :foo do |options|
          options.reverse_merge!(:bar => bar_options) unless bar_options.blank?
        end
      end
        
      options = { :foo => :test }
      assert_equal [:bar, options], @builder.foo(:bar, options.dup), "Should not edit options."
      
      mendable_options = options.dup; @builder.bar_options = :bleh
      assert_equal [:bar, options.merge(:bar => :bleh)], @builder.foo(:bar, mendable_options), "Should use the updated options."
      assert_equal options.merge(:bar => :bleh), mendable_options, "the options hash should have been destructively updated."
    end
  end
end
