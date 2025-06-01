require "tmpdir"
require "rake/clean"

begin
  CLEAN.include "./_site"
  CLEAN.include "./.conda"
  CLEAN.include "./.jekyll-cache"
  CLEAN.include "./Gemfile.lock"
  CLEAN.include "./vendor"
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
  conda_env_sentinel = "./.conda/conda-meta/history"
  file conda_env_sentinel => ["./_conda_environment.yml"] do
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
  task configure_conda_env: conda_env_sentinel

  bundle_install_sentinel = "./Gemfile.lock"
  file bundle_install_sentinel => ["./Gemfile", conda_env_sentinel] do
    conda_run("bundle install")
  end

  desc "Install Ruby dependencies (bundle install/update)"
  task configure_ruby_bundle: [bundle_install_sentinel]
end

namespace :configure_fonts do
  font_assets_dir = "./assets/fonts"
  CLEAN.include font_assets_dir
  directory font_assets_dir

  cache_dir = "#{Dir.home}/.cache/#{Dir.pwd.split("/")[-1]}"
  CLEAN.include cache_dir
  directory cache_dir

  namespace :ibm_plex do
    ibm_vendored_files = "#{cache_dir}/ibm_plex_download_extract.done"
    file ibm_vendored_files => [:configure_conda_env, font_assets_dir] do
      # TODO: Concurrent downloads using native Ruby requests
      sources = {
        ibm_plex_mono: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
        ibm_plex_sans: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
        ibm_plex_sans_kr: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
      }
      # Download font zips from GitHub to temporary directory, then extract to
      # font_assets_dir
      Dir.mktmpdir do |tempd|
        commands = []
        sources.each_pair do |basename, url|
          zipfile = "#{tempd}/#{basename}.zip"
          commands.append("curl -L '#{url}' -o '#{zipfile}'")
          commands.append("unzip -uoq '#{zipfile}' -d '#{font_assets_dir}'")
        end
        conda_run(*commands)
      end
    end

    task remove_unused: [ibm_vendored_files] do
      [
        # Remove SCSS source files from IBM, as they inflate the size of the
        # build for no reason: They are ignored by Jekyll's build pipeline, and
        # we use the compiled CSS files instead
        "#{font_assets_dir}/ibm*/**/*.scss",
        # Remove unnecessary IBM SCSS source files
        "#{font_assets_dir}/ibm*/**/*.eot",
        # Remove OTF versions of fonts (not referenced in the CSS)
        "#{font_assets_dir}/ibm*/**/*.otf"
      ].each do |pattern|
        Dir.glob(pattern).each do |file|
          File.unlink(file)
        end
      end
    end

    task fix_permissions: [ibm_vendored_files] do
      # IBM font LICENSE files are marked executable (probably compiled on
      # Windows); undo this.
      common_run("chmod a-x $(find '#{font_assets_dir}' -type f)")
    end

    desc "Download & extract IBM Plex fonts to #{font_assets_dir}"
    task all: [ibm_vendored_files, :remove_unused, :fix_permissions]
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

    katex_css = "./assets/katex.css"
    CLEAN.include katex_css

    # Copy KaTeX CSS from ./vendor/... to ./assets
    file katex_css => [:configure_ruby_bundle] do
      FileUtils.cp(css_src, katex_css)
    end

    woff2_files = "#{cache_dir}/ibm_plex_download_extract.done"
    file woff2_files => [:configure_ruby_bundle, font_assets_dir] do
      katex_fonts_src = Dir.glob("./vendor/**/vendor/katex/fonts/*.woff2")
      katex_fonts_src.each do |src|
        FileUtils.cp(src, font_assets_dir)
      end
    end

    desc "Copy KaTeX CSS & font assets to #{font_assets_dir}"
    task all: [katex_css, woff2_files]
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
