require "tmpdir"
require "rake/clean"

directory(FONT_ASSETS_DIR = "./assets/fonts")

# Files used to mark completion of tasks like `conda env create`, where the
# underlying build step creates a lot of different files
TASK_SENTINELS = {
  conda_env_create: "./.conda/conda-meta/history",
  bundle_install: "./Gemfile.lock",
  ibm_plex_download_extract: "#{FONT_ASSETS_DIR}/ibm-plex-sans-kr/css/ibm-plex-sans-kr-default.min.css",
  katex_woff2s_copy: "#{FONT_ASSETS_DIR}/KaTeX_AMS-Regular.woff2"
}

begin
  CLEAN.include "./_site"
  CLEAN.include "./.conda"
  CLEAN.include "./.jekyll-cache"
  CLEAN.include "./Gemfile.lock"
  CLEAN.include "./vendor"
  CLEAN.include "./assets/katex.css"
  CLEAN.include FONT_ASSETS_DIR
  TASK_SENTINELS.values.each { |f| CLEAN.include f }
end

# Run a series of commands in bash
def bash(*commands)
  sh "bash -c '#{commands.join(" &&\n")}'"
end

# Run a series of commands after sourcing common functions
def common_run(*commands)
  bash('source "./_scripts/common.sh"', *commands)
end

# Run a series of commands with the conda environment active
def conda_run(*commands)
  bash('source "./_scripts/common.sh"', "activate_conda_environment", *commands)
end

# Run a series of commands via bundle exec (within the conda environment)
def bundle_exec(*commands)
  commands.map! do |command|
    "bundle exec #{command}"
  end
  conda_run(*commands)
end

begin
  file TASK_SENTINELS[:conda_env_create] => ["./_conda_environment.yml"] do
    commands = [
      # Fail early if mamba unavailable
      "command -v mamba",
      # Location of the conda environment definition YML
      'CONDA_ENV_YML=$(realpath "./_conda_environment.yml")',
      # Install destination for the conda environment
      'CONDA_PREFIX=$(realpath "./.conda")',
      # Set CI=True to prevent weird progress bar in mamba update/create:
      # https://github.com/mamba-org/mamba/issues/1478
      'export CI="True"',
      'mamba env create --prefix "$CONDA_PREFIX" --file "$CONDA_ENV_YML" --yes'
    ]
    common_run(*commands)
  end

  desc "Create conda environment (mamba env create)"
  task configure_conda_env: [TASK_SENTINELS[:conda_env_create]]
end

begin
  file TASK_SENTINELS[:bundle_install] => ["./Gemfile", TASK_SENTINELS[:conda_env_create]] do
    conda_run("bundle install")
  end

  desc "Install Ruby dependencies (bundle install/update)"
  task configure_ruby_bundle: [TASK_SENTINELS[:bundle_install]]
end

namespace :configure_fonts do
  begin
    file TASK_SENTINELS[:ibm_plex_download_extract] => [TASK_SENTINELS[:conda_env_create], FONT_ASSETS_DIR] do
      # TODO: Concurrent downloads using native Ruby requests
      sources = {
        ibm_plex_mono: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
        ibm_plex_sans: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
        ibm_plex_sans_kr: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
      }
      # Download font zips from GitHub to temporary directory, then extract to
      # FONT_ASSETS_DIR
      Dir.mktmpdir do |tempd|
        commands = []
        sources.each_pair do |basename, url|
          zipfile = "#{tempd}/#{basename}.zip"
          commands.append "curl -L '#{url}' -o '#{zipfile}'"
          # -o: overwrite existing without prompting
          # -DD: force current timestamp (else Rake keeps rerunning this task)
          commands.append "unzip -oDD '#{zipfile}' '*.css' '*.woff2' -d '#{FONT_ASSETS_DIR}'"
        end
        conda_run(*commands)
        # Check that this actually created the file
        File.file?(TASK_SENTINELS[:ibm_plex_download_extract]) || fail
      end

      # Some files are errantly marked executable (probably compiled on Windows)
      common_run("chmod a-x $(find '#{FONT_ASSETS_DIR}' -type f)")
    end

    desc "Download & extract IBM Plex fonts to #{FONT_ASSETS_DIR}"
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

    desc "Copy KaTeX CSS & font assets to #{FONT_ASSETS_DIR}"
    task katex: ["./assets/katex.css", TASK_SENTINELS[:katex_woff2s_copy]]
  end
  task all: [:ibm_plex, :katex]
end

desc "Install dependencies"
task configure: [:configure_conda_env, :configure_ruby_bundle, :"configure_fonts:all"]

desc "Print environment and package information"
task info: [:configure] do
  conda_run "conda info"
  conda_run "conda list"
  conda_run "bundle list"
end

desc "Preview site locally"
task preview: [:configure] do
  bundle_exec "jekyll serve -o --future"
end

desc "Build site for publication"
task build: [:configure] do
  bundle_exec "jekyll build"
end

desc "Lint source files"
namespace :check_source do
  desc "Lint shell scripts with shellcheck"
  task shellcheck: [:configure] do
    # TODO: Perform globbing within Ruby
    conda_run(
      'SHELL_SCRIPTS=$(find . -maxdepth 2 -iname "*.sh")',
      "echo ${SHELL_SCRIPTS[@]}",
      "shellcheck ${SHELL_SCRIPTS[@]}"
    )
  end

  # NOTE: Need to bundle exec this (instead of using standard/rake) because the
  # Rakefile itself is designed to use only stdlib ruby (and then install
  # standardrb locally)
  desc "Check formatting with standardrb"
  task standard: [:configure_ruby_bundle] do
    bundle_exec("standardrb")
  end

  desc "Ensure no source files contain trailing whitespace"
  task :trailing_whitespace do
    common_run("check_trailing_whitespace")
  end

  desc "Ensure conda dependencies are updated"
  task conda_updated: [:configure_conda_env] do
    common_run("check_conda_updated")
  end

  desc "Ensure bundler dependencies are updated"
  task bundler_updated: [:configure_ruby_bundle] do
    common_run("check_bundler_updated")
  end

  multitask all: [:shellcheck, :standard, :trailing_whitespace, :conda_updated]
end

desc "Lint site build"
namespace :check_build do
  desc "Check build with HTML-Proofer"
  task html_proofer: [:build] do
    options = ["--disable-external"].join(" ")
    bundle_exec("htmlproofer #{options} ./_site")
  end

  desc "Check stability of URL schema"
  task url_schema: [:build] do
    File.file?("./_site/2022/06/25/migrating-to-jekyll.html") || fail
  end

  desc "Check for deprecation warnings with Jekyll doctor"
  task jekyll_doctor: [:build] do
    bundle_exec("jekyll doctor")
  end

  multitask all: [:html_proofer, :url_schema, :jekyll_doctor]
end

desc "Check various source and build issues"
task check: [:"check_source:all", :"check_build:all"]

desc "Format source files"
task format: [:configure_ruby_bundle] do
  # Currently all it does is check the formatting of this Rakefile; haven't
  # found a formatter for other filetypes that works for me yet.
  bundle_exec("standardrb --fix")
end
