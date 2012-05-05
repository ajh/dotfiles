require 'tmpdir'

module Dotfiles
  module UnmanagedFile

    # Add lines to an otherwise unmanaged config file.
    #
    # Create a new string-like object that can be used to manage
    # changes to a file that is not completely under the control of
    # dotfiles.
    #
    # A use case is to add a line to ~/.bashrc to source files in the
    # ~/.bash.d  directory.
    #
    # = Example
    #
    #   changes = Dotfiles::UnmanagedFile::Changes.new '~/.bashrc', :comment_token => '#'
    #   changes.to_s => '' # no changes yet
    #
    #   # add some lines to ~/.bashrc
    #   changes += <<-SOURCE
    #   for rc in $HOME/.bash/*.sh; do
    #     source $rc
    #   done
    #   SOURCE
    #
    #   changes.to_s => 'for rc in...'
    #
    #   changes.clear
    #   changes.to_s => ''
    #
    # = How changes are tracked
    #
    # Comment blocks are created above and below the changes so they can
    # be identifed at a later time. This is why the comment token needs
    # to be provided. Config files without a comment syntax won't work.
    #
    # = Other features
    #
    # Changes can be named by passing a name option to new. Named
    # changes are managed separately from other named or unnamed
    # changes.
    #
    # = Issues
    #
    # * This doesn't allow control over where the changes go.
    class Additions < String
      attr_reader :path, :name, :comment_token

      def initialize(path, name, comment_token)
        @path = Pathname.new path
        @comment_token = comment_token
        @name = name

        reload
      end

      # list of methods that modify the string in place
      MUTATORS = (
        String.public_instance_methods.sort.select {|m| m.to_s.match(%r/[!]$/) && m != :!} \
        + %w(<< concat []= clear replace insert prepend).map(&:to_sym)
      ).freeze

      MUTATORS.each do |name|
        module_eval <<-ALIAS
          def #{name}(*args, &block)
            output = super *args, &block
            flush
            output
          end
        ALIAS
      end

      private

      # Replace value from file, or set to empty string if file has no value.
      def reload
        string = File.open(path) do |f|
          start_reading = false
          string = ""

          f.each do |line|
            if line =~ %r/#{Regexp.escape begin_comment_line}/
              start_reading = true

            elsif line =~ %r/#{Regexp.escape end_comment_line}/
              break

            elsif start_reading
              string += line
            end
          end

          string
        end

        @file_is_empty = string.empty?

        replace string
      end

      # Write changes to file
      def flush
        empty? && @file_is_empty and return

        # Do a simple append
        if !empty? && @file_is_empty
          path.open('a') do |f|
            f.write begin_comment_line
            f.write to_s.chomp + "\n"
            f.write end_comment_line
          end

          return
        end

        # Do a more expensive copy and replace
        Dir.mktmpdir do |dir|
          dir = Pathname.new dir
          copy_path = dir.join(path.basename)
          FileUtils.cp path, copy_path

          copy_path.open('r') do |reader|
            path.open('w') do |writer|
              is_inside = false

              reader.each do |line|
                if line =~ %r/#{Regexp.escape begin_comment_line}/
                  is_inside = true

                elsif line =~ %r/#{Regexp.escape end_comment_line}/
                  is_inside = false

                  unless empty?
                    writer.write begin_comment_line
                    writer.write to_s.chomp + "\n"
                    writer.write end_comment_line
                  end

                elsif is_inside
                  next

                else
                  writer.write line
                end
              end
            end
          end
        end
      end

      def begin_comment_line
        "#{comment_token} begin dotfiles #{name} additions\n"
      end

      def end_comment_line
        "#{comment_token} end dotfiles #{name} additions\n"
      end
    end
  end
end
