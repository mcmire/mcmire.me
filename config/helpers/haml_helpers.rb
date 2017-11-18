module HamlHelpers
  def render_haml(content)
    tempfile = Tempfile.open("haml")
    tempfile.write(content)
    tempfile.close
    Tilt["haml"].new(tempfile).render
  end
end
