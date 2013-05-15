module Jekyll
  module Converters
    class Markdown < Converter
      alias old_convert convert
      def convert(content)
        content.gsub!(/```(\w*)\n(.*?)```/m) do |text|
          cls = $1.empty? ? "" : " lang-#{$1}"
          code = "#{$2}"
          code.gsub!(/</m) do |text|
            "&lt;"
          end
          code.gsub!(/>/m) do |text|
            "&gt;"
          end
          "<pre class=\"prettyprint linenums#{cls}\"><code>#{code}</code></pre>"
        end
        old_convert(content)
      end
    end
  end
end
