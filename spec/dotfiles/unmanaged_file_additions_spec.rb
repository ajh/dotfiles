require 'spec_helper'
require 'tempfile'

describe Dotfiles::UnmanagedFile::Additions do
  describe "initialize" do
    let(:file) {
      Tempfile.new('test file')
    }

    it "should take a path" do
      s = described_class.new file.path, 'custom', '#'
      s.path.should == Pathname.new(file.path)
    end

    it "should require path to be a readable file"

    it "should take a comment character" do
      s = described_class.new file.path, 'custom', '#'
      s.comment_token.should == '#'
    end

    it "should take a name" do
      s = described_class.new file.path, 'custom', '#'
      s.name.should == 'custom'
    end
  end

  shared_context "file without additions" do
    subject do
      file = Tempfile.new('without_additions').tap do |f|
        f << <<-CONFIG
[color]
  ui = auto
[alias]
  lp = log --patch --decorate
  lg = log --graph --pretty=oneline --abbrev-commit
        CONFIG

        f.flush
      end

      described_class.new file.path, 'custom', '#'
    end
  end

  shared_context "file with additions" do
    subject do
      file = Tempfile.new('with_additions').tap do |f|
        f << <<-CONFIG
# Set color
[color]
  ui = auto

# begin dotfiles custom additions
[core]
  excludesfile = ~/.gitexcludes
# end dotfiles custom additions
        CONFIG

        f.flush
      end

      described_class.new file.path, 'custom', '#'
    end
  end

  shared_context "file with other named additions" do
    subject do
      file = Tempfile.new('with_other_named_additions').tap do |f|
        f << <<-CONFIG
# Set color
[color]
	ui = auto

# begin dotfiles other additions
[core]
	excludesfile = ~/.gitexcludes
# end dotfiles other additions
        CONFIG

        f.flush
      end

      described_class.new file.path, 'custom', '#'
    end
  end

  shared_context "file with several named additions" do
    subject do
      file = Tempfile.new('with_several_named_additions').tap do |f|
        f << <<-CONFIG
# Set color
[color]
	ui = auto

# begin dotfiles custom additions
[alias]
  lp = log --patch --decorate
  lg = log --graph --pretty=oneline --abbrev-commit
# end dotfiles custom additions

# begin dotfiles other additions
[core]
	excludesfile = ~/.gitexcludes
# end dotfiles other additions
        CONFIG

        f.flush
      end

      described_class.new file.path, 'custom', '#'
    end
  end

  describe "#to_s" do
    context "with no additions" do
      include_context "file without additions"

      it "should return empty string" do
        subject.to_s.should == ""
      end
    end

    context "with additions" do
      include_context "file with additions"

      it "should return value in file" do
        subject.to_s.should == "[core]\n  excludesfile = ~/.gitexcludes\n"
      end
    end

    context "with other named additions" do
      include_context "file with other named additions"

      it "should return empty string" do
        subject.to_s.should == ""
      end
    end

    context "with several named additions" do
      include_context "file with several named additions"

      it "should return value in file" do
        subject.to_s.should == "[alias]\n  lp = log --patch --decorate\n  lg = log --graph --pretty=oneline --abbrev-commit\n"
      end
    end
  end

  # replace
  describe "#replace" do
    context "with no additions" do
      include_context "file without additions"

      it "should write replaced string to file" do
        subject.replace "hi there!"

        subject.path.open do |f|
          f.read.should match(%r/# begin dotfiles custom additions\nhi there!\n# end dotfiles custom additions/)
        end
      end
    end
  end

  # <<
  describe "add_content" do
    it "should add values to the managed content"
  end

  # clear
  describe "remove_content" do
    it "should remove all managed content from the file"
  end

  it "should backup files"

end
