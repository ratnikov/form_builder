require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class DivCellTest < ActiveSupport::TestCase

    class MockDivCell < DivCell
      def initialize name, *args
        super(proc { |name, *extra| { :name => name, :options => extra.pop, :extra => extra }.inspect}, name, *args)
      end
    end

    def test_truth
      assert true
    end

    def test_to_tag
      cell = MockDivCell.new :foo, :label => "bar"
      assert_equal "<div class=\"field\">#{cell.label_tag}<p>#{expected_content(:foo, {})}</p></div>", cell.to_tag, "Should return content in div tags."

      assert_equal "<div class=\"field\"><p>#{expected_content :foo, {}}</p></div>", MockDivCell.new(:foo, :label => nil).to_tag, "Should omit the label."
    end

    def test_div_options
      assert_equal({:class => 'field', :foo => :bar}, MockDivCell.new(:foo, :div => { :foo => :bar }).div_options, "Should correctly recognize div options.")
      assert_equal({:class => 'foo'}, MockDivCell.new(:foo, :div => { :class => 'foo' }).div_options, "Should allow overriding options.")
    end

    private

    def expected_content name, *args
      options = args.pop
      { :name => name, :options => options, :extra => args }.inspect
    end
  end
end
