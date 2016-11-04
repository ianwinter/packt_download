require "bundler/setup"

CONFIG_FILES = FileList["config/*.yml.example"].ext("")

desc "Initialize default config files"
task bootstrap: "bootstrap:all"
namespace :bootstrap do
  task all: :config
  task config: CONFIG_FILES
end
rule ".yml" => ".yml.example" do |task|
  cp task.source, task.name
end

require "rake/clean"
CLEAN.include(CONFIG_FILES)
