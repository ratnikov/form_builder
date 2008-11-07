module FormBuilder
  class TableBuilder < CellBasedBuilder

    def full_form_wrap content
      form_wrap table_wrap(content)
    end

    def table_wrap content
      render :partial => "form_builder/table_form", :locals => { :builder => self, :content => content, :table_options => table_options } 
    end

    def make_cell content, name, options = {}
      TableCell.new(content, name, options).to_tag
    end

    def table_options
      @table_options ||= apply_table_options!(options[:table] || {})
      @table_options
    end

    def apply_table_options! options; options.reverse_merge!(:class => 'form') end
  end

  module TableBuilderHelper
  end
end
