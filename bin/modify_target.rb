#!/usr/bin/env ruby
require 'xcodeproj'

project_path, target_name, disable_patch_index_store, disable_patch_module, disable_patch_bitcode = ARGV
puts "Modifying build settings: #{project_path}, target: #{target_name}"
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
  if target.name == target_name
    puts "Found target: #{target_name}"
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_MODULE_DEBUGGING'] = 'NO'
      if disable_patch_module == '0'
        puts "patching module setting"
        config.build_settings['CLANG_ENABLE_MODULES'] = 'NO'
      end
      if disable_patch_index_store == '0'
        puts "patching index store setting"
        config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = 'NO'
      end
      if disable_patch_bitcode == '0'
        puts "patching bitcode setting"
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
    puts "Did modify target: #{target_name}"
  end
end
project.save
