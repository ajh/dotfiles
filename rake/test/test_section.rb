require File.join(File.dirname(__FILE__), 'helper')
require 'fileutils'
require 'find'

class SectionTest < Test::Unit::TestCase
  def setup
    Section.debug = false
  end

  def test_create_should_create_section_for_dot_rc_files
    sections = Section.create_from_files %w(dot_bashrc dot_vimrc)
    assert_equal 2, sections.length
    assert_equal %w(bash vim).sort, sections.collect(&:name).sort
  end

  def test_create_should_create_section_for_dot_directory_files
    sections = Section.create_from_files %w(dot_this/this dot_that/that)
    assert_equal 2, sections.length
    assert_equal %w(this that).sort, sections.collect(&:name).sort
  end

  def test_create_from_files_should_work_with_fixture_area
    setup_fixtures
  
    files = []
    Find.find(fixture_project_dir) { |f| files << f if File.file?(f) }
    sections = Section.create_from_files files

    assert_equal 2, sections.length
    assert_equal %w(this that).sort, sections.collect(&:name).sort

    assert_equal \
      [ \
        "#{@fixture_project_dir}/dot_thisrc",
        "#{@fixture_project_dir}/dot_this/settings",
        "#{@fixture_project_dir}/dot_this/alias",
      ].sort,
      sections.select{|s| s.name == 'this'}.first.files.sort
    
    assert_equal \
      [ \
        "#{@fixture_project_dir}/dot_that/plugins/foo", 
        "#{@fixture_project_dir}/dot_that/plugins/bar",
      ].sort, 
      sections.select{|s| s.name == 'that'}.first.files.sort
  end

  def test_create_should_accumulate_files_in_correct_sections
    sections = Section.create_from_files %w(dot_bashrc dot_bash/that dot_bash/this)
    assert_equal 1, sections.length
    assert_equal %w(dot_bashrc dot_bash/that dot_bash/this).sort, sections.first.files.sort
  end

  def test_install_should_symlink_dot_rc_files
    setup_fixtures

    section = Section.new :name => 'thing', 
      :project_dir => fixture_project_dir, 
      :files => [File.join(fixture_project_dir, 'dot_thisrc')]

    assert section.install(fixture_home_dir)
    assert_symlink File.join(fixture_home_dir, '.thisrc'), File.join(fixture_project_dir, 'dot_thisrc')
  end

  def test_install_should_symlink_deep_files
    setup_fixtures

    section = Section.new :name => 'thing', 
      :project_dir => fixture_project_dir, 
      :files => [File.join(@fixture_project_dir, 'dot_this', 'settings')]

    assert section.install(fixture_home_dir)
    assert_symlink File.join(fixture_home_dir, '.this', 'settings'), File.join(fixture_project_dir, 'dot_this', 'settings')
  end

  def test_should_install_all_fixtures
    setup_fixtures

    files = []
    Find.find(fixture_project_dir) { |f| files << f if File.file?(f) }

    section = Section.new :name => 'thing', 
      :project_dir => fixture_project_dir, 
      :files => files

    assert section.install(fixture_home_dir)
    assert_symlink "#{@fixture_home_dir}/.thisrc",            "#{@fixture_project_dir}/dot_thisrc"
    assert_symlink "#{@fixture_home_dir}/.this/settings",     "#{@fixture_project_dir}/dot_this/settings"
    assert_symlink "#{@fixture_home_dir}/.this/alias",        "#{@fixture_project_dir}/dot_this/alias"
    assert_symlink "#{@fixture_home_dir}/.that/plugins/foo",  "#{@fixture_project_dir}/dot_that/plugins/foo"
    assert_symlink "#{@fixture_home_dir}/.that/plugins/bar",  "#{@fixture_project_dir}/dot_that/plugins/bar"
  end

  def teardown
    if fixture_project_dir or fixture_home_dir
      FileUtils.rm_rf @fixture_dir
    end
  end

  private

    attr_accessor :fixture_project_dir, :fixture_home_dir

    def setup_fixtures
      @fixture_dir = File.join '/tmp', "dotfiles_#{$$}"
      @fixture_project_dir = FileUtils.mkdir_p File.join(@fixture_dir, "project_dir")
      @fixture_home_dir = FileUtils.mkdir_p File.join(@fixture_dir, "home_dir")

      FileUtils.touch File.join(@fixture_project_dir, 'dot_thisrc')
      FileUtils.mkdir_p File.join(@fixture_project_dir, 'dot_this')
      FileUtils.touch File.join(@fixture_project_dir, 'dot_this', 'settings')
      FileUtils.touch File.join(@fixture_project_dir, 'dot_this', 'alias')
      
      FileUtils.mkdir_p File.join(@fixture_project_dir, 'dot_that', 'plugins')
      FileUtils.touch File.join @fixture_project_dir, 'dot_that', 'plugins', 'foo'
      FileUtils.touch File.join @fixture_project_dir, 'dot_that', 'plugins', 'bar'
    end

    def assert_symlink(link, target)
      assert File.symlink?(link)
      assert_equal File.expand_path(target), File.expand_path(File.readlink(link))
    end
end
