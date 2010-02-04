module Polynome
  class OSCPrefix < String
    def initialize(*strings)
      string = strings.map{|s| normalise_prefix(s)}.join
      super(string)
    end

    private

    def normalise_prefix(prefix)
      normalise_slashes(prefix || "")
    end

    def prefix_message_prefix(message)
      @prefix + normalise_slashes(message || "")
    end

    def normalise_slashes(string)
      remove_trailing_slash(enforce_starting_slash(string))
    end

    def enforce_starting_slash(string)
      string.start_with?('/') ? string : "/#{string}"
    end

    def remove_trailing_slash(string)
      string.end_with?('/') ? string[0..-2] : string
    end
  end
end
