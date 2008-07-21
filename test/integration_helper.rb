require 'rubygems'
require 'test/spec'
require 'mocha'

#require File.dirname(__FILE__) + '/../lib/braid'

require 'tempfile'
require 'fileutils'
require 'pathname'

#tmp_file = Tempfile.new("braid")
#tmp_file_path = tmp_file.path
#tmp_file.unlink
#TMP = File.basename(tmp_file_path)

TMP_PATH = File.join(Dir.tmpdir, "braid_integration")
BRAID_PATH = Pathname.new(File.dirname(__FILE__)).parent.realpath
FIXTURE_PATH = File.join(BRAID_PATH, "test", "fixtures")
FileUtils.mkdir_p(TMP_PATH)

#def exec(cmd)
#  `cd #{TMP} && #{cmd}`
#end

def in_dir(dir = TMP_PATH)
  Dir.chdir(dir)
  yield
end

def run_cmds(ary)
  ary.each do |cmd|
    cmd = cmd.strip!
    out = `#{cmd}`
  end
end

def create_git_repo_from_fixture(fixture_name)
  git_repo = File.join(TMP_PATH, fixture_name)
  FileUtils.cp_r(File.join(FIXTURE_PATH, fixture_name), TMP_PATH)
  in_dir(git_repo) do
    run_cmds(<<-EOD)
      git init
      git add *
      git commit -m "initial commit of #{fixture_name}"
    EOD
  end
  git_repo
end

def create_svn_repo_from_fixture(fixture_name)
  svn_wc = File.join(TMP_PATH, fixture_name + "_repo")
  svn_repo = File.join(TMP_PATH, fixture_name)
  run_cmds(<<-EOD)
    svnadmin create #{svn_repo}
    svn co file://#{svn_repo} #{svn_wc}
  EOD
  FileUtils.cp_r("#{FIXTURE_PATH}/#{fixture_name}/.", svn_wc)
  in_dir(svn_wc) do
    run_cmds(<<-EOD)
      svn add *
      svn commit -m "initial commit of #{fixture_name}"
    EOD
  end
  "file://#{svn_repo}"
end


