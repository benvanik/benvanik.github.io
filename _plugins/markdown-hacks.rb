require 'digest/md5'

def triple_backtick(content)
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
  content
end

def gfm(text)
  # Extract pre blocks
  extractions = {}
  text.gsub!(%r{<pre>.*?</pre>}m) do |match|
    md5 = Digest::MD5.hexdigest(match)
    extractions[md5] = match
    "{gfm-extraction-#{md5}}"
  end

  # prevent foo_bar_baz from ending up with an italic word in the middle
  text.gsub!(/(^(?! {4}|\t)\w+_\w+_\w[\w_]*)/) do |x|
    x.gsub('_', '\_') if x.split('').sort.to_s[0..1] == '__'
  end

  # in very clear cases, let newlines become <br /> tags
  text.gsub!(/^[\w\<][^\n]*\n+/) do |x|
    x =~ /\n{2}/ ? x : (x.strip!; x << "  \n")
  end

  # Insert pre block extractions
  text.gsub!(/\{gfm-extraction-([0-9a-f]{32})\}/) do
    "\n\n" + extractions[$1]
  end

  text
end

module Jekyll
  module Converters
    class Markdown < Converter
      alias old_convert convert
      def convert(content)
        #content = gfm(content)
        content = triple_backtick(content)
        old_convert(content)
      end
    end
  end
end
