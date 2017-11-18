require_relative "kramdown_katex_engine"

KramdownConfig = proc do
  set :markdown_engine, :kramdown
  set :markdown,
    input: "GFM",
    enable_coderay: false,
    hard_wrap: false,
    math_engine: "katex",
    smartypants: true
end
