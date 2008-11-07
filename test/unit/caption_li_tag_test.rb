require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class CaptionLiTagTest < ActiveSupport::TestCase
    class MockCaptionLiTag < CaptionLiTag
      def content_tag type, content, options
        { :type => type, :content => content, :options => options }
      end
    end

    def setup
      @caption_tag = MockCaptionLiTag.new "foo", :li => { :foo => :bar }
    end

    def test_truth
      assert true
    end

    def test_options_parsing
      assert_equal "foo", @caption_tag.content, "Should have correctly parsed the contents for the tag."
      assert_equal({:li => { :foo => :bar }}, @caption_tag.options, "Should correctly save all the options.")
      
      @caption_tag.options.freeze # freeze to make sure that further calls do not edit the options hash

      assert_equal({:foo => :bar}, @caption_tag.li_options, "Should correctly parse the li options with :li key.")
    end

    def test_to_tag
      assert_equal({:type => :li, :content => "foo", :options => { :foo => :bar }}, @caption_tag.to_tag, 
        "Should create an li tag with specified custom options and content of the caption.") 
    end

    def test_parse_caption
      mock_class = Class.new(MockCaptionLiTag) do
        attr_accessor :init_args
        def initialize *args
          self.init_args = args
        end
      end

      expected_init_args = ["foo", {:li => { :foo => :bar }}]

      initializer_interface = mock_class.parse_caption "foo", :li => { :foo => :bar}
      assert_equal expected_init_args, initializer_interface.init_args, "Should use the \"foo\" as content and the options as default options."

      assert_equal ["foo\nfoo", {}], mock_class.parse_caption("foo\nfoo").init_args, 'Should support content with \n characters.'

      array_interface = mock_class.parse_caption [ "foo", {:li => { :foo => :bar }} ]
      assert_equal expected_init_args, array_interface.init_args, "Should parse first element as content and second as options if array-style is used."

      array_with_defaults = mock_class.parse_caption [ "foo" ], :li => { :foo => :bar }
      assert_equal expected_init_args, array_with_defaults.init_args, "Should use the defaults hash to setup the caption options hash."

      array_with_conflicting_defaults = mock_class.parse_caption [ "foo", { :li => { :foo => :bar } }], :li => { :foo => :boo }
      assert_equal expected_init_args, array_with_conflicting_defaults.init_args, "Should prefer the specific options over default if there's a conflict."
    end

    def test_equality
      assert CaptionLiTag.new("foo", :bar => :foo) == CaptionLiTag.new("foo", :bar => :foo), "Two tags with same content and options should be equal."
      assert CaptionLiTag.new("foo", :bar => :bar) != CaptionLiTag.new("foo", :bar => :foo), "Two tags with different options should be not equal."
      assert CaptionLiTag.new("foo", :bar => :foo) != CaptionLiTag.new("bar", :bar => :foo), "Two tags with different content should be not equal."
    end
  end
end
