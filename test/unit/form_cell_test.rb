require File.dirname(__FILE__) + '/../../test_helper'

module FormBuilder
  class FormCellTest < ActiveSupport::TestCase
    class MockFormCell < FormCell
      def initialize name, *args
        super(proc { |name, *extra_args | { :name => name, :options => extra_args.pop, :extra_args => extra_args } }, name, *args)
      end
    end

    def test_truth
      assert true
    end

    def test_to_tag
      assert_equal({:name => :foo, :extra_args => [ :blah ], :options => {} }, MockFormCell.new(:foo, :blah).to_tag, 
        "Should create correct to_tag and add default empty options.")
      assert_equal({:name => :foo, :options => { :foo => :bar }, :extra_args => [] }, MockFormCell.new(:foo, :foo => :bar).to_tag, 
        "Should create to_tag without extra builder args and inherited options.")
    end

    def test_enabled?
      assert FormCell.new("foo", :foo).enabled?, "A cell should be enabled by default."
      assert !FormCell.new("foo", :foo, :make_cell => false).enabled?, "Should be able to disable cell via options."
      assert FormCell.new("foo", :foo, :make_cell => true).enabled?, "Should be able to make sure a cell is enabled."
    end
  end
end
