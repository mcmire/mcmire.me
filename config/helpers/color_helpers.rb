module ColorHelpers
  def color_names
    @color_names ||= begin
      color_map_file_path = File.expand_path("../../colors/map.js", __FILE__)
      colors = JSON.parse(`#{color_map_file_path}`)
      colors.keys.sort.map { |name| name.underscore.dasherize }
    end
  end
end
