require "tmpdir"
require "rake/clean"

directory(FONT_ASSETS_DIR = "./assets/fonts")
directory(CACHE_DIR = "#{Dir.home}/.cache/#{Dir.pwd.split("/")[-1]}")

# Files used to mark completion of various tasks below. In some cases (e.g.
# conda env create), the file is created directly by the underlying build step;
# in other cases (IBM Plex fonts), it's a dummy file that we create manually
# since the actual step involves lots of files with unpredictable names.
TASK_SENTINELS = {
  conda_env_create: "./.conda/conda-meta/history",
  bundle_install: "./Gemfile.lock",
  ibm_plex_download_extract: "#{CACHE_DIR}/ibm_plex_download_extract.done",
  katex_woff2s_copy: "#{CACHE_DIR}/katex_woff2s_copy.done"
}

begin
  CLEAN.include "./_site"
  CLEAN.include "./.conda"
  CLEAN.include "./.jekyll-cache"
  CLEAN.include "./Gemfile.lock"
  CLEAN.include "./vendor"
  CLEAN.include "./assets/katex.css"
  CLEAN.include FONT_ASSETS_DIR
  CLEAN.include CACHE_DIR
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
  namespace :ibm_plex do
    file TASK_SENTINELS[:ibm_plex_download_extract] => [TASK_SENTINELS[:conda_env_create], FONT_ASSETS_DIR, CACHE_DIR] do
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
          commands.append "unzip -uoq '#{zipfile}' -d '#{FONT_ASSETS_DIR}'"
        end
        conda_run(*commands)
        # Spot check
        File.file?("#{FONT_ASSETS_DIR}/ibm-plex-sans-kr/css/ibm-plex-sans-kr-default.min.css") || fail
        FileUtils.touch(TASK_SENTINELS[:ibm_plex_download_extract])
      end
    end

    task remove_unused: [TASK_SENTINELS[:ibm_plex_download_extract]] do
      [
        # Remove SCSS source files from IBM, as they inflate the size of the
        # build for no reason: They are ignored by Jekyll's build pipeline, and
        # we use the compiled CSS files instead
        "#{FONT_ASSETS_DIR}/ibm*/**/*.scss",
        # Remove unnecessary IBM SCSS source files
        "#{FONT_ASSETS_DIR}/ibm*/**/*.eot",
        # Remove OTF versions of fonts (not referenced in the CSS)
        "#{FONT_ASSETS_DIR}/ibm*/**/*.otf"
      ].each do |pattern|
        Dir.glob(pattern).each do |file|
          File.unlink(file)
        end
      end
    end

    task fix_permissions: [TASK_SENTINELS[:ibm_plex_download_extract]] do
      # IBM font LICENSE files are marked executable (probably compiled on
      # Windows); undo this.
      common_run("chmod a-x $(find '#{FONT_ASSETS_DIR}' -type f)")
    end

    desc "Download & extract IBM Plex fonts to #{FONT_ASSETS_DIR}"
    task all: [TASK_SENTINELS[:ibm_plex_download_extract], :remove_unused, :fix_permissions]
  end

  namespace :katex do
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

    file TASK_SENTINELS[:katex_woff2s_copy] => [TASK_SENTINELS[:bundle_install], FONT_ASSETS_DIR, CACHE_DIR] do
      katex_fonts_src = Dir.glob("./vendor/**/vendor/katex/fonts/*.woff2")
      katex_fonts_src.each do |src|
        FileUtils.cp(src, FONT_ASSETS_DIR)
      end
      # Spot check
      File.file?("#{FONT_ASSETS_DIR}/KaTeX_AMS-Regular.woff2") || fail
      FileUtils.touch(TASK_SENTINELS[:katex_woff2s_copy])
    end

    desc "Copy KaTeX CSS & font assets to #{FONT_ASSETS_DIR}"
    task all: ["./assets/katex.css", TASK_SENTINELS[:katex_woff2s_copy]]
  end
  task all: [:"ibm_plex:all", :"katex:all"]
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
