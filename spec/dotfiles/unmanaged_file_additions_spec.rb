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
  excludesfile = .gitexcludes
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
  excludesfile = .gitexcludes
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
  excludesfile = .gitexcludes
# end dotfiles other additions
        CONFIG

        f.flush
      end

      described_class.new file.path, 'custom', '#'
    end
  end

  describe "#to_s" do
    context "with no existing additions" do
      include_context "file without additions"

      it "should return empty string" do
        subject.to_s.should == ""
      end
    end

    context "with existing additions" do
      include_context "file with additions"

      it "should return value in file" do
        subject.to_s.should == <<-CONTENT
[core]
  excludesfile = .gitexcludes
CONTENT
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
        subject.to_s.should == <<-CONTENT
[alias]
  lp = log --patch --decorate
  lg = log --graph --pretty=oneline --abbrev-commit
CONTENT
      end
    end
  end

  describe "#replace" do
    context "with no existing additions" do
      include_context "file without additions"

      it "should append additions to file" do
        subject.replace "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
[color]
  ui = auto
[alias]
  lp = log --patch --decorate
  lg = log --graph --pretty=oneline --abbrev-commit
# begin dotfiles custom additions
hi there!
# end dotfiles custom additions
        CONTENT
      end
    end

    context "with existing additions" do
      include_context "file with additions"

      it "should write replaced string to file" do
        subject.replace "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

# begin dotfiles custom additions
hi there!
# end dotfiles custom additions
        CONTENT
      end
    end

    context "with other named additions" do
      include_context "file with other named additions"

      it "should append additions to file" do
        subject.replace "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

# begin dotfiles other additions
[core]
  excludesfile = .gitexcludes
# end dotfiles other additions
# begin dotfiles custom additions
hi there!
# end dotfiles custom additions
        CONTENT
      end
    end

    context "with several named additions" do
      include_context "file with several named additions"

      it "should write replaced string to file while ignoring other additions" do
        subject.replace "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

# begin dotfiles custom additions
hi there!
# end dotfiles custom additions

# begin dotfiles other additions
[core]
  excludesfile = .gitexcludes
# end dotfiles other additions
        CONTENT
      end
    end
  end

  describe "#concat" do
    context "with no existing additions" do
      include_context "file without additions"

      it "should append additions to file" do
        subject.concat "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
[color]
  ui = auto
[alias]
  lp = log --patch --decorate
  lg = log --graph --pretty=oneline --abbrev-commit
# begin dotfiles custom additions
hi there!
# end dotfiles custom additions
        CONTENT
      end
    end

    context "with existing additions" do
      include_context "file with additions"

      it "should write concated additions string to file" do
        subject.concat "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

# begin dotfiles custom additions
[core]
  excludesfile = .gitexcludes
hi there!
# end dotfiles custom additions
        CONTENT
      end
    end

    context "with other named additions" do
      include_context "file with other named additions"

      it "should append additions to file" do
        subject.concat "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

# begin dotfiles other additions
[core]
  excludesfile = .gitexcludes
# end dotfiles other additions
# begin dotfiles custom additions
hi there!
# end dotfiles custom additions
        CONTENT
      end
    end

    context "with several named additions" do
      include_context "file with several named additions"

      it "should write concated string to file while ignoring other additions" do
        subject.concat "hi there!"

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

# begin dotfiles custom additions
[alias]
  lp = log --patch --decorate
  lg = log --graph --pretty=oneline --abbrev-commit
hi there!
# end dotfiles custom additions

# begin dotfiles other additions
[core]
  excludesfile = .gitexcludes
# end dotfiles other additions
        CONTENT
      end
    end
  end

  describe "#clear" do
    context "with no existing additions" do
      include_context "file without additions"

      it "should not change the file" do
        old_content = subject.path.open(&:read)
        subject.clear
        subject.path.open(&:read).should == old_content
      end
    end

    context "with existing additions" do
      include_context "file with additions"

      it "should remove additions" do
        subject.clear

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto

        CONTENT
      end
    end

    context "with other named additions" do
      include_context "file with other named additions"

      it "should not change the file" do
        old_content = subject.path.open(&:read)
        subject.clear
        subject.path.open(&:read).should == old_content
      end
    end

    context "with several named additions" do
      include_context "file with several named additions"

      it "should clear correct additions" do
        subject.clear

        subject.path.open(&:read).should == <<-CONTENT
# Set color
[color]
  ui = auto


# begin dotfiles other additions
[core]
  excludesfile = .gitexcludes
# end dotfiles other additions
        CONTENT
      end
    end
  end

  # One way to do this would be to:
  # * only backup once per Addition instance
  # * copy the original file with a timestamp or uuid suffix
  # * include the work dotfiles in the suffix
  it "should backup files"

end
