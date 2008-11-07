module FormBuilder
  class CellBasedBuilder < BasicFormBuilder
    extend_form_fields :cell_support do |old_builder, name, *args|
      cell_options = extract_cell_options! args
      make_cell(old_builder, name, cell_options)
    end

    def apply_cell_options! options; options end

    private
    def extract_cell_options! args
      options = args.last || {}
      cell_options = options 
      apply_cell_options! cell_options
    end
  end
end
