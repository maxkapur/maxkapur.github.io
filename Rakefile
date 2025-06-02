require "tmpdir"
require "rake/clean"

desc "Install dependencies"
task configure: [:configure_ruby_bundle, :"configure_fonts:all"]

desc "Print environment and package information"
task info: [:configure] do
  sh "ruby --version"
  sh "bundle list"
end

desc "Format source files"
task format: [:configure_ruby_bundle] do
  # Currently all it does is check the formatting of this Rakefile; haven't
  # found a formatter for other filetypes that works for me yet.
  sh "bundle exec standardrb --fix"
end

desc "Preview site locally"
task preview: [:configure] do
  # Use a temp dir to distinguish preview from production build in _site/
  Dir.mktmpdir do |tempd|
    sh "bundle exec jekyll serve --destination #{tempd} --open-url --future"
  end
end

desc "Build site for publication"
task build: [:configure] do
  sh "bundle exec jekyll build"
end

desc "Check various source and build issues"
task check: [:"check_source:all", :"check_build:all"]

desc "Lint input, build, and lint output"
task default: [:build, :check]

FONT_ASSETS_DIR = "./assets/fonts"
directory FONT_ASSETS_DIR

# Files used to mark completion of tasks where the underlying build step creates
# a lot of different files
TASK_SENTINELS = {
  bundle_install: "./Gemfile.lock",
  ibm_plex_download_extract: "#{FONT_ASSETS_DIR}/ibm-plex-sans-kr/css/ibm-plex-sans-kr-default.min.css",
  katex_woff2s_copy: "#{FONT_ASSETS_DIR}/KaTeX_AMS-Regular.woff2"
}

APT_DEPENDENCIES = [
  "build-essential",
  "curl",
  "ruby-bundler",
  "ruby-full",
  "unzip",
  "zlib1g-dev" # or ruby-build
]

begin
  CLEAN.include "./_site"
  CLEAN.include "./.jekyll-cache"
  CLEAN.include "./Gemfile.lock"
  CLEAN.include "./vendor"
  CLEAN.include "./assets/katex.css"
  CLEAN.include FONT_ASSETS_DIR
  TASK_SENTINELS.values.each { |f| CLEAN.include f }
end

begin
  file TASK_SENTINELS[:bundle_install] => ["./Gemfile"] do
    try_install_apt_dependencies
    sh "bundle install"
  end

  # Attempt to install apt dependencies if they are not present
  def try_install_apt_dependencies
    joined = APT_DEPENDENCIES.join(" ")

    unless system "apt-get", "--version", out: File::NULL
      puts "Unable to check for apt dependencies as system is not Debian-like, but here's what I would have tried to install in case it's useful: #{joined}"
      return
    end

    if system "dpkg-query", "-s", *APT_DEPENDENCIES, out: File::NULL
      puts "apt dependencies already present: #{joined}"
      return
    end

    puts "Missing apt dependencies; attempting sudo install (you may be prompted for password)"
    sh "sudo", "apt-get", "install", "--yes", "--no-upgrade", *APT_DEPENDENCIES
  end

  # Wrap as a normal task
  task configure_ruby_bundle: [TASK_SENTINELS[:bundle_install]]
end

namespace :configure_fonts do
  begin
    file TASK_SENTINELS[:ibm_plex_download_extract] => [FONT_ASSETS_DIR] do
      # TODO: Concurrent downloads using native Ruby requests
      sources = {
        ibm_plex_mono: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
        ibm_plex_sans: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
        ibm_plex_sans_kr: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
      }
      # Download font zips from GitHub to temporary directory, then extract to
      # FONT_ASSETS_DIR
      Dir.mktmpdir do |tempd|
        sources.each_pair do |basename, url|
          zipfile = "#{tempd}/#{basename}.zip"
          sh "curl -L '#{url}' -o '#{zipfile}'"
          # -o: overwrite existing without prompting
          # -DD: force current timestamp (else Rake keeps rerunning this task)
          sh "unzip -oDD '#{zipfile}' '*.css' '*.woff2' -d '#{FONT_ASSETS_DIR}'"
        end
        # Check that this actually created the sentinel file
        File.file?(TASK_SENTINELS[:ibm_plex_download_extract]) || fail
      end

      # Some files are errantly marked executable (probably compiled on Windows)
      sh "chmod a-x $(find '#{FONT_ASSETS_DIR}' -type f)"
    end

    # Download & extract IBM Plex fonts to FONT_ASSETS_DIR
    task ibm_plex: [TASK_SENTINELS[:ibm_plex_download_extract]]
  end

  begin
    def css_src
      candidates = Dir.glob("./vendor/**/vendor/katex/stylesheets/katex.css")
      unless candidates.length == 1
        puts candidates
        raise "Found #{candidates.length} katex.css files, expected 1"
      end
      candidates[0]
    end

    # Copy KaTeX CSS from ./vendor/... to ./assets
    file "./assets/katex.css" => [TASK_SENTINELS[:bundle_install]] do
      FileUtils.cp(css_src, "./assets/katex.css")
    end

    file TASK_SENTINELS[:katex_woff2s_copy] => [TASK_SENTINELS[:bundle_install], FONT_ASSETS_DIR] do
      katex_fonts_src = Dir.glob("./vendor/**/vendor/katex/fonts/*.woff2")
      katex_fonts_src.each do |src|
        FileUtils.cp(src, FONT_ASSETS_DIR)
      end
      # Check that this actually created the file
      File.file?(TASK_SENTINELS[:katex_woff2s_copy]) || fail
    end

    # Copy KaTeX CSS & font assets to FONT_ASSETS_DIR
    task katex: ["./assets/katex.css", TASK_SENTINELS[:katex_woff2s_copy]]
  end
  task all: [:ibm_plex, :katex]
end

# Lint source files
namespace :check_source do
  # Check formatting with standardrb
  task standard: [:configure_ruby_bundle] do
    # NOTE: Need to bundle exec this (instead of using standard/rake) because
    # the Rakefile itself is designed to use only stdlib ruby (and then install
    # standardrb locally)
    sh "bundle exec standardrb"
  end

  # Ensure no source files contain trailing whitespace
  task :trailing_whitespace do
    sh "! git grep -IEl '\\s$'"
  end

  # Ensure bundler dependencies are updated
  task bundler_updated: [:configure_ruby_bundle] do
    sh "bundle outdated --only-explicit"
  end

  multitask all: [:standard, :trailing_whitespace]
end

# Lint site build
namespace :check_build do
  # Check build with HTML-Proofer
  task html_proofer: [:build] do
    options = ["--disable-external"].join(" ")
    sh "bundle exec htmlproofer #{options} ./_site"
  end

  # Check stability of URL schema
  task url_schema: [:build] do
    File.file?("./_site/2022/06/25/migrating-to-jekyll.html") || fail
  end

  # Check for deprecation warnings with Jekyll doctor
  task jekyll_doctor: [:build] do
    sh "bundle exec jekyll doctor"
  end

  multitask all: [:html_proofer, :url_schema, :jekyll_doctor]
end
