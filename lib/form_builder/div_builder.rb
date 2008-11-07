module FormBuilder
  class DivBuilder < CellBasedBuilder
    def make_cell content, name, options = {}
      DivCell.new(content, name, options).to_tag
    end
  end
end
