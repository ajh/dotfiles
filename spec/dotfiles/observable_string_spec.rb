require 'spec_helper'

describe Dotfiles::ObservableString do
  it "should include observable" do
    described_class.included_modules.should include(Observable)
  end

  it "should notify observers of changes" do
    observer = double 'observer'
    observer.should_receive(:update).with("hi there!")

    subject.add_observer observer
    subject.replace 'hi there!'
  end
end
