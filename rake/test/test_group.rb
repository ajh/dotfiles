require 'find'

module DotFiles
  class SectionTest < Test::Unit::TestCase

    def setup
      setup_fixtures
      DotFiles.debug = false
    end

    def test_new_should_take_name_from_directory
      assert_equal 'vim', Group.new('groups/vim').name
    end

    def test_new_should_find_files_and_build_config_files
      group = Group.new fixture_group_dir
      assert_equal \
        %w(dot_thingrc dot_thing/settings).collect{|f| "#{fixture_group_dir}/#{f}"}.sort, 
        group.files.collect(&:project_file).sort

      assert_equal [fixture_group_dir], group.files.collect(&:project_dir).uniq
    end

    def test_install_should_install_config_files
      group = Group.new fixture_group_dir
      group.install fixture_install_dir

      assert_symlink "#{fixture_install_dir}/.thingrc", "#{fixture_group_dir}/dot_thingrc"
      assert_symlink "#{fixture_install_dir}/.thing/settings", "#{fixture_group_dir}/dot_thing/settings"
    end

    def teardown
      if File.directory? @fixture_dir
        FileUtils.rm_rf @fixture_dir
      end
    end

    private

      attr_accessor :fixture_group_dir
      attr_accessor :fixture_install_dir

      def setup_fixtures
        @fixture_dir = File.join '/tmp', "dotfiles_#{$$}"
        @fixture_group_dir = FileUtils.mkdir_p File.join(@fixture_dir, "groups/thing")
        @fixture_install_dir = FileUtils.mkdir_p File.join(@fixture_dir, "home")


        FileUtils.touch File.join(@fixture_group_dir, 'dot_thingrc')
        FileUtils.mkdir_p File.join(@fixture_group_dir, 'dot_thing')
        FileUtils.touch File.join(@fixture_group_dir, 'dot_thing', 'settings')
      end

      def assert_symlink(link, target)
        assert File.symlink?(link)
        assert_equal File.expand_path(target), File.expand_path(File.readlink(link))
      end
  end
end
