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
    class Additions < ObservableString
      attr_reader :path, :name, :comment_token

      def initialize(path, name, comment_token)
        @path = Pathname.new path
        @comment_token = comment_token
        @name = name

        replace self.class.load(self)
        add_observer self.class
      end

      def self.load(addition)
        File.open addition.path do |f|
          start_reading = false
          string = ""

          f.each do |line|
            if line =~ %r/#{Regexp.escape begin_comment_line(addition)}/
              start_reading = true

            elsif line =~ %r/#{Regexp.escape end_comment_line(addition)}/
              break

            elsif start_reading
              string += line
            end
          end

          string
        end
      end

      # Write changes to file
      def self.update(addition)
        Dir.mktmpdir do |dir|
          dir = Pathname.new dir
          copy_path = dir.join(addition.path.basename)
          FileUtils.cp addition.path, copy_path

          copy_path.open('r') do |reader|
            addition.path.open('w') do |writer|
              inside_additions = false
              found_additions = false
              already_wrote_additions = false

              reader.each do |line|
                if line =~ %r/#{Regexp.escape begin_comment_line(addition)}/
                  inside_additions = found_additions = true
                  writer.write line

                elsif line =~ %r/#{Regexp.escape end_comment_line(addition)}/
                  inside_additions = false
                  writer.write line

                elsif inside_additions && already_wrote_additions
                  next

                elsif inside_additions
                  already_wrote_additions = true
                  writer.write addition.to_s.chomp + "\n"

                else
                  writer.write line
                end
              end

              if !found_additions
                writer.write begin_comment_line(addition)
                writer.write addition.to_s.chomp + "\n"
                writer.write end_comment_line(addition)
              end
            end
          end
        end
      end

      private

        def self.begin_comment_line(addition)
          "#{addition.comment_token} begin dotfiles #{addition.name} additions\n"
        end

        def self.end_comment_line(addition)
          "#{addition.comment_token} end dotfiles #{addition.name} additions\n"
        end
    end
  end
end
