# encoding: utf-8
# Copyright 2015, Dominik Richter
# License: Apache v2

require 'spec_helper'

describe 'PHP config parameters' do
  # Some things we don't do:
  # * safe_mode
  #   reason: deprecated
  #   see: http://php.net/manual/de/features.safe-mode.php


  # Here are all the common places a php config file can be with system package installations
  file_locations = ["/etc/php.ini","/etc/php5/apache2/php.ini","/etc/php5/fpm/php.ini","/etc/php5/cli/php.ini"]

  file_locations.each do |file|

    next unless File.file?(file)

    # Base configuration
    describe file(file) do
      it { should contain('/var/www/:/srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/').after('open_basedir = ') }
    end

    # PHP Capabilities

    # Ensure unsafe functions are disabled
    describe file(file) do
      it { should contain('php_uname').after('disable_functions = ') }
      it { should contain('getmyuid').after('disable_functions = ') }
      it { should contain('getmypid').after('disable_functions = ') }
      it { should contain('passthru').after('disable_functions = ') }
      it { should contain('leak').after('disable_functions = ') }
      it { should contain('listen').after('disable_functions = ') }
      it { should contain('diskfreespace').after('disable_functions = ') }
      it { should contain('tmpfile').after('disable_functions = ') }
      it { should contain('link').after('disable_functions = ') }
      it { should contain('ignore_user_abord').after('disable_functions = ') }
      it { should contain('shell_exec').after('disable_functions = ') }
      it { should contain('dl').after('disable_functions = ') }
      it { should contain('set_time_limit').after('disable_functions = ') }
      it { should contain('ini_set').after('disable_functions = ') }
      it { should contain('exec').after('disable_functions = ') }
      it { should contain('system').after('disable_functions = ') }
      it { should contain('highlight_file').after('disable_functions = ') }
      it { should contain('source').after('disable_functions = ') }
      it { should contain('show_source').after('disable_functions = ') }
      it { should contain('fpaththru').after('disable_functions = ') }
      it { should contain('virtual').after('disable_functions = ') }
      it { should contain('posix_ctermid').after('disable_functions = ') }
      it { should contain('posix_getcwd').after('disable_functions = ') }
      it { should contain('posix_getegid').after('disable_functions = ') }
      it { should contain('posix_geteuid').after('disable_functions = ') }
      it { should contain('posix_getgid').after('disable_functions = ') }
      it { should contain('posix_getgrgid').after('disable_functions = ') }
      it { should contain('posix_getgrnam').after('disable_functions = ') }
      it { should contain('posix_getgroups').after('disable_functions = ') }
      it { should contain('posix_getlogin').after('disable_functions = ') }
      it { should contain('posix_getpgid').after('disable_functions = ') }
      it { should contain('posix_getpgrp').after('disable_functions = ') }
      it { should contain('posix_getpid').after('disable_functions = ') }
      it { should contain('posix').after('disable_functions = ') }
      it { should contain('_getppid').after('disable_functions = ') }
      it { should contain('posix_getpwnam').after('disable_functions = ') }
      it { should contain('posix_getpwuid').after('disable_functions = ') }
      it { should contain('posix_getrlimit').after('disable_functions = ') }
      it { should contain('posix_getsid').after('disable_functions = ') }
      it { should contain('posix_getuid').after('disable_functions = ') }
      it { should contain('posix_isatty').after('disable_functions = ') }
      it { should contain('posix_kill').after('disable_functions = ') }
      it { should contain('posix_mkfifo').after('disable_functions = ') }
      it { should contain('posix_setegid').after('disable_functions = ') }
      it { should contain('posix_seteuid').after('disable_functions = ') }
      it { should contain('posix_setgid').after('disable_functions = ') }
      it { should contain('posix_setpgid').after('disable_functions = ') }
      it { should contain('posix_setsid').after('disable_functions = ') }
      it { should contain('posix_setuid').after('disable_functions = ') }
      it { should contain('posix_times').after('disable_functions = ') }
      it { should contain('posix_ttyname').after('disable_functions = ') }
      it { should contain('posix_uname').after('disable_functions = ') }
      it { should contain('proc_open').after('disable_functions = ') }
      it { should contain('proc_close').after('disable_functions = ') }
      it { should contain('proc_get_status').after('disable_functions = ') }
      it { should contain('proc_nice').after('disable_functions = ') }
      it { should contain('proc_terminate').after('disable_functions = ') }
      it { should contain('phpinfo').after('disable_functions = ') }
    end

    # Ensure unsafe classes are disabled
    # TODO: do we have a recommended minimum-set?
    #describe file(file) do
    #  it { should contain('php_uname').after('disable_classes = ') }
    #end

  end

  # Time / Memory Quota

  context php_config('max_execution_time') do
    its(:value) { should <= 30 }
    its(:value) { should > 0 }
  end

  context php_config('max_input_nesting_level') do
    its(:value) { should eq 64 }
  end

  context php_config('memory_limit') do
    its(:value.downcase) { should match(%r{128m}i) }
  end

  context php_config('post_max_size') do
    its(:value.downcase) { should match(%r{8m}i) }
  end

  # TODO: do we have a recommended minimum-set?
  context php_config('disable_functions') do
    its(:value) { should eq 'php_uname, getmyuid, getmypid, passthru, leak, listen, diskfreespace, tmpfile, link, ignore_user_abord, shell_exec, dl, set_time_limit, ini_set, exec, system, highlight_file, source, show_source, fpaththru, virtual, posix_ctermid, posix_getcwd, posix_getegid, posix_geteuid, posix_getgid, posix_getgrgid, posix_getgrnam, posix_getgroups, posix_getlogin, posix_getpgid, posix_getpgrp, posix_getpid, posix, _getppid, posix_getpwnam, posix_getpwuid, posix_getrlimit, posix_getsid, posix_getuid, posix_isatty, posix_kill, posix_mkfifo, posix_setegid, posix_seteuid, posix_setgid, posix_setpgid, posix_setsid, posix_setuid, posix_times, posix_ttyname, posix_uname, proc_open, proc_close, proc_get_status, proc_nice, proc_terminate, phpinfo' }
  end

  # TODO: do we have a recommended minimum-set?
  # context php_config('disable_classes') do
  #   its(:value) { should eq '...' }
  # end

  context php_config('expose_php') do
    its(:value) { should eq '' }
  end

  context php_config('enable_dl') do
    its(:value) { should eq '' }
  end

  context php_config('default_charset') do
    its(:value.downcase) { should match(%r{utf-8}i) }
  end

  context php_config('default_mimetype') do
    its(:value) { should match(%r{text/html}i) }
  end

  # removed as of PHP5.4, so... (Debian 6 and Ubuntu 12.04 are pinned to 5.3)
  # remove these test?
  context php_config('register_globals') do
    its(:value) { should eq '' }
  end
  context php_config('magic_quotes_gpc') do
    its(:value) { should eq '' }
  end
  context php_config('magic_quotes_sybase') do
    its(:value) { should eq '' }
  end

  # # removed // how to test this?
  # context php_config('magic_quotes_runtime') do
  #   its(:value) { should eq ''}
  # end

  # Upload / Open

  context php_config('allow_url_fopen') do
    its(:value) { should eq '' }
  end

  context php_config('allow_url_include') do
    its(:value) { should eq '' }
  end

  context php_config('file_uploads') do
    its(:value) { should eq '' }
  end

  # Alternative: restrict upload maximum to prevent
  # system overload:
  # upload_tmp_dir = /var/php_tmp
  # upload_max_filezize = 10M

  # Log // Information Disclosure

  context php_config('display_errors') do
    its(:value) { should eq '' }
  end

  context php_config('display_startup_errors') do
    its(:value) { should eq '' }
  end

  context php_config('log_errors') do
    its(:value) { should eq 1 }
  end

  # Session Handling
  case os[:family]
    when 'debian', 'ubuntu'
      context php_config('session.save_path') do
        its(:value) { should eq '/var/lib/php5' }
      end
    when 'redhat', 'centos', 'oracle','scientific'
      context php_config('session.save_path') do
        its(:value) { should eq '/var/lib/php/session' }
      end
    else
      context php_config('session.save_path') do
        its(:value) { should eq '/var/lib/php' }
      end
  end

  context php_config('session.cookie_httponly') do
    its(:value) { should eq 1 }
  end

  # Mail

  context php_config('mail.add_x_header') do
    its(:value) { should eq '' }
  end

end
