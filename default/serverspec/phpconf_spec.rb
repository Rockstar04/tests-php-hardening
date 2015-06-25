# encoding: utf-8
# Copyright 2015, Dominik Richter
# License: Apache v2

require 'spec_helper'

# Some things we don't do:
# * safe_mode
#   reason: deprecated
#   see: http://php.net/manual/de/features.safe-mode.php

# Here are all the common places a php config file can be with system package installations
file_locations = ['/etc/php.ini', '/etc/php5/apache2/php.ini', '/etc/php5/fpm/php.ini', '/etc/php5/cli/php.ini']

file_locations.each do |file|

  next unless ::File.exist?(file)

  describe 'PHP config parameters in ' + file do

    # Base configuration

    context php_config_file('open_basedir', file) do
      its(:value) { should eq '/var/www/:/srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/' }
    end

    # Time / Memory Quota

    context php_config_file('max_execution_time', file) do
      # We will need to grep files to ensure this is not zero (CLI hardcoded to no time limit)
      # its(:value) { should <= 30 }
      # its(:value) { should > 0 }
    end

    context php_config_file('max_input_nesting_level', file) do
      its(:value) { should eq 64 }
    end

    context php_config_file('memory_limit', file) do
      its(:value) { should match(/128m/i) }
    end

    context php_config_file('post_max_size', file) do
      its(:value) { should match(/8m/i) }
    end

    # PHP Capabilities

    # TODO: do we have a recommended minimum-set?
    context php_config_file('disable_functions', file) do
      its(:value) { should eq 'php_uname, getmyuid, getmypid, passthru, leak, listen, diskfreespace, tmpfile, link, ignore_user_abord, shell_exec, dl, set_time_limit, ini_set, exec, system, highlight_file, source, show_source, fpaththru, virtual, posix_ctermid, posix_getcwd, posix_getegid, posix_geteuid, posix_getgid, posix_getgrgid, posix_getgrnam, posix_getgroups, posix_getlogin, posix_getpgid, posix_getpgrp, posix_getpid, posix, _getppid, posix_getpwnam, posix_getpwuid, posix_getrlimit, posix_getsid, posix_getuid, posix_isatty, posix_kill, posix_mkfifo, posix_setegid, posix_seteuid, posix_setgid, posix_setpgid, posix_setsid, posix_setuid, posix_times, posix_ttyname, posix_uname, proc_open, proc_close, proc_get_status, proc_nice, proc_terminate, phpinfo' }
    end

    # TODO: do we have a recommended minimum-set?
    # context php_config_file('disable_classes', file) do
    #   its(:value) { should eq '...' }
    # end

    context php_config_file('expose_php', file) do
      its(:value) { should eq false }
    end

    context php_config_file('enable_dl', file) do
      its(:value) { should eq false }
    end

    context php_config_file('default_charset', file) do
      its(:value) { should match(/utf-8/i) }
    end

    context php_config_file('default_mimetype', file) do
      its(:value) { should match(%r{text/html}i) }
    end

    # removed as of PHP5.4, so... (Debian 6 and Ubuntu 12.04 are pinned to 5.3)
    # remove these test?
    context php_config_file('register_globals', file) do
      its(:value) { should eq false }
    end
    context php_config_file('magic_quotes_gpc', file) do
      its(:value) { should eq false }
    end
    context php_config_file('magic_quotes_sybase', file) do
      its(:value) { should eq false }
    end

    # # removed // how to test this?
    # context php_config_file('magic_quotes_runtime', file) do
    #   its(:value) { should eq false}
    # end

    # Upload / Open

    context php_config_file('allow_url_fopen', file) do
      its(:value) { should eq false }
    end

    context php_config_file('allow_url_include', file) do
      its(:value) { should eq false }
    end

    context php_config_file('file_uploads', file) do
      its(:value) { should eq false }
    end

    # Alternative: restrict upload maximum to prevent
    # system overload:
    # upload_tmp_dir = /var/php_tmp
    # upload_max_filezize = 10M

    # Log // Information Disclosure

    context php_config_file('display_errors', file) do
      its(:value) { should eq false }
    end

    context php_config_file('display_startup_errors', file) do
      its(:value) { should eq false }
    end

    context php_config_file('log_errors', file) do
      its(:value) { should eq true }
    end

    # Session Handling
    case os[:family]
    when 'debian', 'ubuntu'
      context php_config_file('session.save_path', file) do
        its(:value) { should eq '/var/lib/php5' }
      end
    when 'redhat', 'centos', 'oracle', 'scientific'
      context php_config_file('session.save_path', file) do
        its(:value) { should eq '/var/lib/php/session' }
      end
    else
      context php_config_file('session.save_path', file) do
        its(:value) { should eq '/var/lib/php' }
      end
    end

    context php_config_file('session.use_only_cookies', file) do
      its(:value) { should eq true }
    end

    context php_config_file('session.cookie_httponly', file) do
      its(:value) { should eq true }
    end

    # Mail

    context php_config_file('mail.add_x_header', file) do
      its(:value) { should eq false }
    end
  end
end
