require 'observer'

module Dotfiles

  # A string class that notifies observers when it is modified in place.
  class ObservableString < String
    include Observable

    # list of methods that modify the string in place
    MUTATORS = (
      String.public_instance_methods.sort.select {|m| m.to_s.match(%r/[!]$/) && m != :!} \
      + %w(<< concat []= clear replace insert prepend).map(&:to_sym)
    ).freeze

    MUTATORS.each do |name|
      module_eval <<-ALIAS
        def #{name}(*args, &block)
          output = super *args, &block

          changed
          notify_observers self

          output
        end
      ALIAS
    end
  end
end
