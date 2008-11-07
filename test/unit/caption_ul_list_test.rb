require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class CaptionUlListTest < ActiveSupport::TestCase

    class MockCaptionUlList < CaptionUlList
      def content_tag type, content, options = {}
        { :type => type, :content => content, :options => options }
      end
    end

    def test_truth
      assert true
    end

    def test_initalization
      list = CaptionUlList.new %w(foo bar), :li => { :foo => :bar }, :ul => { :class => "list" }
      assert_equal [CaptionLiTag.new("foo", :li => { :foo => :bar }), CaptionLiTag.new("bar", :li => { :foo => :bar })], list.captions,
        "Should create caption li tags with specified :li options only."
    end

    def test_ul_options
      assert_equal({:foo => :bar }, CaptionUlList.new(%w(foo bar), :ul => { :foo => :bar }).ul_options, "Should be able to parse the regular :ul options.")
      assert_equal({}, CaptionUlList.new(%w(foo bar)).ul_options, "Should return a blank ul options even if options are not set.")
    end

    def test_default_li_options
      assert_equal({:li => { :foo => :bar } }, CaptionUlList.new(%(foo bar), :li => { :foo => :bar }).default_li_options, 
        "Should be able to get the default li options from the options list including the :li key.")
      assert_equal({}, CaptionUlList.new(%w(foo bar)).default_li_options, "Should return a blank list if options doesn't have :li key.")
    end

    def test_to_tag
      list = MockCaptionUlList.new(%w(foo bar), :ul => { :foo => :bar })
      captions = %w(foo bar).map { |info| CaptionLiTag.parse_caption info }
      assert_equal({:type => :ul, :options => { :foo => :bar }, :content => captions.map(&:to_tag).join }, list.to_tag, 
        "Should build a :ul list using joined caption tags as content and using :ul_options.")
    end

    def test_equality
      assert CaptionUlList.new('foo', :foo => :bar) == CaptionUlList.new(['foo'], :foo => :bar), "Two lists should be equal if they have same caption tag and options."
      assert CaptionUlList.new('foo', :foo => :bar) != CaptionUlList.new(%w(foo bar), :foo => :bar), "Two lists should not be equal if they have different caption contents."
      assert CaptionUlList.new('foo', :foo => :bar) != CaptionUlList.new('foo', :foo => :zeta), "Two lists should not be equal if their options do not match."
      assert CaptionUlList.new([], :foo => :bar) == CaptionUlList.new([], :foo => :bar), "Two empty lists should be equal if they have same options."
    end
  end
end
