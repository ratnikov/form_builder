module FormBuilder
  class TableCell < FormCell
    attr_accessor :table_options

    def to_tag_with_table
      content = to_tag_without_table
      content_tag :tr, table_options(:tr) do
        head = label.nil? ? nil : label_tag
        cell = content_tag :td, [content, captions_tag].join, table_options(:td)
        [head, cell].compact.join
      end
    end
    alias_method_chain :to_tag, :table

    def label_tag_with_th
      content_tag :th, table_options(:th) do
        label_tag_without_th
      end
    end
    alias_method_chain :label_tag, :th

    def parse_options_with_table_support unparsed_options
      options = parse_options_without_table_support unparsed_options
      self.table_options = %w(tr th td).map(&:to_sym).inject({}) do |acc, table_key|
        acc.merge table_key => send("parse_#{table_key}_options", (options.delete(table_key) || {}))
      end
      options
    end
    alias_method_chain :parse_options, :table_support

    def table_options key = nil
      key.nil? ? @table_options : (@table_options[key] || {})
    end


    def parse_th_options options; options.reverse_merge(:scope => 'row') end
    def parse_tr_options options; options end
    def parse_td_options options; options end
  end
end
