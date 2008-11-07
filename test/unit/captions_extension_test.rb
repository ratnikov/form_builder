require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class CaptionsExtensionTest < ActiveSupport::TestCase

    class MockCell
      attr_accessor :name, :options
      def initialize options = {}
        self.options = parse_options options
      end
      def parse_options options; self.name = options.delete(:name); options end
      include CaptionsExtension

      # supporting methods
      def content_tag type, content, options
        { :type => type, :content => content, :options => options }
      end
    end

    def test_truth
      assert true
    end

    def test_caption_parsing
      cell = MockCell.new :name => "foo", :captions => %w(foo bar)
      assert_equal "foo", cell.name, "Name should be parsed."
      assert_equal CaptionUlList.new(%w(foo bar), :ul => cell.default_ul_options), cell.caption_list, "Should create a new list out of the caption strings."

      blank_cell = MockCell.new :name => "foo"
      assert_nil blank_cell.captions_tag, "If no captions are specified, should return a nil captions tag."
    end
  end
end
