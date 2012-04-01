require 'pathname'

link "#{ENV['HOME']}/.bash/test.sh" do
  to Pathname.new(__FILE__).dirname.join('../test.sh').to_s
end
