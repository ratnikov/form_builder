require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class LabelExtensionTest < ActiveSupport::TestCase
    class MockCell
      attr_accessor :name, :options
      
      def initialize options = {}
        parse_options options
      end

      def parse_options options; self.name = options.delete(:name); options end
      include LabelExtension

      # supporting methods
      def content_tag type, content, options
        { :type => type, :content => content, :options => options }
      end
    end

    def setup
      @cell = MockCell.new :name => "foo", :label => "bar"
    end

    def test_truth
      assert true
    end

    def test_options_parsing
      cell = MockCell.new(options = { :name => "foo", :label => "bar" })
      assert_equal "foo", cell.name, "#name should be parsed from options."
      assert_equal "bar", cell.label, "the label should be parsed from options."
      assert_equal({}, options, "Options should have been destructively parsed.")
    end

    def test_default_label
      cell = MockCell.new :name => :foo
      assert_equal :foo, cell.name, "The name should be parsed."
      assert_equal cell.name.to_s.humanize, cell.label, "By default, the label should be set to the humanized name."
      
      labeless_cell = MockCell.new :name => "foo", :label => nil
      assert_equal "foo", labeless_cell.name, "The name should not be changed."
      assert_nil labeless_cell.label, "The label should be set to nil if specified so."
    end

    def test_label_tag
      assert_equal({:type => :label, :content => "bar", :options => {:for => "foo"}}, @cell.label_tag, 
        "Should correctly wrap the label in the label with #label providing contents with :for specified.")
    end
  end
end
