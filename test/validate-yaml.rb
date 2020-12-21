#!/usr/bin/env ruby

require 'yaml'

Dir.glob('**/*{yml,yaml}') { |file|
    begin
        YAML.parse(File.open(file))
        puts "#{file} \e[32mvalid\e[0m"
    rescue => exception
        puts "#{file} \e[31minvalid\e[0m"
        fail
    end
}
