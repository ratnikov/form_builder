require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class TableCellTest < ActiveSupport::TestCase

    class MockTableCell < TableCell
      def initialize name, *args
        super(proc { |name, *extra| { :name => name, :options => extra.pop, :extra => extra }.inspect }, name, *args)
      end
    end

    def setup
      @cell = MockTableCell.new("foo", :foo)
    end

    def test_truth
      assert true
    end

    def test_to_tag
      cell = MockTableCell.new :foo, :label => "bar"
      assert_equal "<tr>#{cell.label_tag}<td>#{expected_content(:foo, {})}</td></tr>", cell.to_tag, "Should return the content and label wrapped within th/tr tags."


      assert_equal "<tr><td>#{expected_content(:foo, {})}</td></tr>", MockTableCell.new(:foo, :label => nil).to_tag, "Should return content without label."

      captioned_cell = MockTableCell.new(:foo, :label => nil, :captions => "testing", :foo => :bar)
      assert_equal "<tr><td>#{expected_content(:foo, :foo => :bar)}#{captioned_cell.captions_tag}</td></tr>", 
        captioned_cell.to_tag, "Should return captions withing the cell td."
    end

    def test_to_tag_options
      cell_class = Class.new(MockTableCell) do
        def label_tag_without_th; "<label_tag />" end
      end

      assert_equal "<tr foo=\"bar\"><th scope=\"row\"><label_tag /></th><td>#{expected_content :foo, {}}</td></tr>", 
        cell_class.new(:foo, :tr => { :foo => :bar }).to_tag, 
        "Should append the :tr options to the tr tag."

      assert_equal "<tr><th foo=\"bar\" scope=\"row\"><label_tag /></th><td>#{expected_content(:foo, {})}</td></tr>", 
        cell_class.new(:foo, :th => { :foo => :bar }, :label => "bar").to_tag, 
        "Should append the :th options to the th tag."

      assert_equal "<tr><th scope=\"row\"><label_tag /></th><td foo=\"bar\">#{expected_content(:foo, {})}</td></tr>", 
        cell_class.new(:foo, :td => { :foo => :bar }).to_tag, 
        "Should append the :td options to the td tag."
    end

    def test_table_options
      # th
      assert_equal({:scope => 'row'}, MockTableCell.new("foo").table_options(:th), "Should apply :scope => 'row' option to :th table by default.")
      assert_equal({:scope => nil}, MockTableCell.new("foo", :foo, :th => { :scope => nil }).table_options(:th), "Should override the defaults.")
      assert_equal({:foo => :bar, :scope => 'row'}, MockTableCell.new(:foo, :th => { :foo => :bar }).table_options(:th), "Should allow additional options.")

      # td
      assert_equal({:foo => :bar}, MockTableCell.new(:foo, :td => { :foo => :bar }).table_options(:td), "Should allow custom td options.")
      assert_equal({}, MockTableCell.new(:foo).table_options(:td), "Should not specify any td options by default.")

      # tr
      assert_equal({:foo => :bar}, MockTableCell.new(:foo, :tr => { :foo => :bar }).table_options(:tr), "Should allow custom tr options.")
      assert_equal({}, MockTableCell.new(:foo).table_options(:tr), "Should not specify any tr options by default.")
    end

    private

    def expected_content name, *args
      options = args.pop
      { :name => name, :options => options, :extra => args }.inspect
    end
  end
end
