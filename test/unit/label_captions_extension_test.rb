require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class LabelCaptionsExtensionTest < ActiveSupport::TestCase
    class CellStub
      attr_accessor :label, :options
      def label_tag; label end
      def parse_options options; options end

      def initialize init_options = {}
        init_options.each_pair { |k, v| send("#{k}=", v) }
        self.options = parse_options options
      end
      
      include LabelCaptionsExtension
    end

    def test_truth
      assert true
    end

    def test_options_parsing
      cell = CellStub.new :label => :test, :options => { :label_captions => %w(foo bar) } 
      assert_equal CaptionUlList.new(%w(foo bar), :ul => { :class => 'mute'}), cell.label_caption_list, 
        "Should be able to parse a new label caption list from the parameters."
      assert_equal nil, CellStub.new(:options => { :foo => :bar }).label_caption_list, "Captions list should be blank if it was not specified."
    end
  end
end
