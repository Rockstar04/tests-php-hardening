# encoding: utf-8
#
# Copyright 2014, Deutsche Telekom AG
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Serverspec::Type

module Serverspec
  module Type
    class PhpConfigFile < Base
      attr_reader :file

      def initialize(name = nil, file = nil)
        @name   = name
        @file   = file
        @runner = Specinfra::Runner
      end

      def value
        @file = ' -c ' + @file unless @file.nil?

        ret = @runner.run_command("php #{@file} -r 'echo get_cfg_var( \"#{@name}\" );'")
        val = ret.stdout
        val = val.to_i if val.match(/^\d+$/)
        val = val.to_bool if val.match(/^(On|Off|1|0|\s)$/i)
        val
      end
    end

    def php_config_file(name, file = nil)
      PhpConfigFile.new(name, file)
    end
  end
end
