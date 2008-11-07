require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class CellBasedBuilderTest < ActiveSupport::TestCase

    class MockCellBasedBuilder < CellBasedBuilder
      def initialize; end
    end

    def setup
      @builder = MockCellBasedBuilder.new
    end

    def test_truth
      assert true
    end

    def assert_extract_cell_options!
      args = [:foo, :bar, { :foo => :bar }]

      mendable_args = args.dup
      assert_equal nil, @builder.extract_cell_options!(args), "Should not find any cell options of :cell is not specified."
      assert_equal args, mendable_args, "Should not change the args."

      args.last.merge!(:cell => { :alpha => :beta }); mendable_args = args.dup
      assert_equal({:alpha => :beta}, @builder.extract_cell_options(mendable_args), "Should extract whatever is in :cell as options.")
      assert_equal args, [mendable_args.first(2), mendable_args.last.merge(:cell => { :alpha => :beta })], "mendable args should have been same as original args, except :cell key removed from options."
    end
  end
end
