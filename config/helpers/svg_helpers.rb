module SvgHelpers
  # Source: <https://gist.github.com/bitmanic/0047ef8d7eaec0bf31bb>
  def embed_svg(path, attributes = {})
    given_attributes = attributes.dup
    given_class = extract_class_from_attributes(given_attributes)
    css_class = build_css_class(given_class, ["image"])
    final_attributes = { class: css_class }
    content_tag(:div, generate_svg(path, attributes), final_attributes)
  end

  private

  def generate_svg(path, given_attributes = {})
    attributes = given_attributes.dup
    svg_content = read_svg(path)

    if svg_content
      doc = Nokogiri::XML.parse(svg_content)
      svg = doc.at_css("svg")
      dimensions = extract_dimensions_from(attributes)
      svg[:style] = build_style_from_dimensions(dimensions)
      # SvgOptimizer.optimize(doc.to_xml)
      doc.to_xml
    else
      <<-SVG
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 800 30"
          style="height: 30px"
        >
          <text x="8" y="20" style="font-size: 16px; fill: #cc0000">
            Error: "#{path}" could not be found.
          </text>
        </svg>
      SVG
    end
  end

  def read_svg(path)
    resource = Middleman::Util::FindResource.call(app, current_resource, path)

    if resource
      logger.debug "== (svg) Resolving path: #{path} => #{resource.source_file}"
      content = File.read(resource.source_file)

      if resource.source_file.end_with?(".haml")
        render_haml(content)
      else
        content
      end
    end
  end

  def build_css_class(given_class, given_classes = [])
    ([given_class] + given_classes).join(" ").strip
  end

  def build_style_from_dimensions(attributes)
    dimensions = {}

    if attributes[:width]
      dimensions[:width] = "#{attributes[:width]}px"
    end

    if attributes[:height]
      dimensions[:height] = "#{attributes[:height]}px"
    end

    dimensions.map { |key, value| "#{key}: #{value}" }.join("; ")
  end

  def extract_class_from_attributes(attributes)
    attributes.delete(:class) { "" }
  end

  def extract_dimensions_from(attributes)
    width = attributes.delete(:width)
    height = attributes.delete(:height)
    { width: width, height: height }
  end
end
