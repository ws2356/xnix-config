#!/usr/bin/env ruby
require 'xcodeproj'

project_path, target_name = ARGV
puts "Modifying build settings: #{project_path}, target: #{target_name}"
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
  if target.name == target_name
    puts "Found target: #{target_name}"
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_MODULES'] = 'NO'
      config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
    puts "Did modify target: #{target_name}"
  end
end
project.save
