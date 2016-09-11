require "pathname"

class SprocketsBowerFontsIntegration
  def initialize(context)
    @context = context
    @bower_components = Pathname.new(
      File.join(context.root, "bower_components")
    )
  end

  def configure
    sprockets.append_path(bower_components)

    component_directories.each do |component_directory|
      files = find_asset_files_within(component_directory)
      files.each { |file| import_component_asset(component_directory, file) }
    end
  end

  protected

  attr_accessor :context, :bower_components

  private

  def sprockets
    context.sprockets
  end

  def component_directories
    Pathname.glob(bower_components.join("*"))
  end

  def find_asset_files_within(component_directory)
    if ["source-code-pro", "source-sans-pro"].include?(File.basename(component_directory))
      Pathname.glob(
        component_directory.join(
          "{WOFF,WOFF2}/OTF",
          "*.{woff,woff2}"
        )
      )
    else
      Pathname.glob(
        component_directory.join(
          "**",
          "*.{woff,woff2}"
        )
      )
    end
  end

  def import_component_asset(component_directory, file)
    input_path = file.relative_path_from(bower_components)
    output_path = Pathname.new(
      File.join("fonts", file.relative_path_from(component_directory)).
        sub(%r{(?:/fonts)+}, "")
    )

    puts "Adding to Sprockets path: #{input_path} -> #{output_path}"
    sprockets.import_asset(input_path) { output_path }
  end
end
