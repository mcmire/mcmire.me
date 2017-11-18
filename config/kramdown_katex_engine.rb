module KramdownKatexEngine
  def self.call(converter, element, options)
    converter.format_as_block_html(
      "script",
      { "type" => "math/katex" },
      converter.escape_html(element.value),
      options[:indent]
    )
  end
end

Kramdown::Converter.add_math_engine(:katex, KramdownKatexEngine)
