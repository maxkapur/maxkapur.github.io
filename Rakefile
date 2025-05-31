require "tmpdir"

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

namespace :configure_conda do
  desc "Ensure mamba command is available"
  task :ensure_mamba do
    common_run("command -v mamba")
  end

  # List of files used to indicate presence of conda environment and whether it
  # is updated
  outputs = FileList["./.conda/conda-meta/*.json", "./.conda/conda-meta/history"]

  file outputs => [:ensure_mamba] do
    commands = [
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
  task all: outputs
end

desc "Install Ruby dependencies (bundle install/update)"
task configure_ruby_bundle: [:"configure_conda:all"] do
  conda_run("bundle install")
end

namespace :configure_fonts do
  font_assets_dir = "./assets/fonts"
  directory font_assets_dir

  namespace :ibm_plex do
    outputs = FileList["#{font_assets_dir}/ibm*/**/*"]

    file outputs => [:"configure_conda:all", font_assets_dir] do
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
          commands.append("curl -L '#{url}' -o '#{basename}.zip'")
          commands.append("unzip -uoq '#{basename}.zip' -d '#{font_assets_dir}'")
        end
        conda_run(*commands)
      end
    end

    task clean_unused_ibm_plex_files: outputs do
      for pattern in [
        # Remove SCSS source files from IBM, as they inflate the size of the
        # build for no reason: They are ignored by Jekyll's build pipeline, and
        # we use the compiled CSS files instead.
        "#{font_assets_dir}/ibm*/**/*.scss",
        # Remove unnecessary IBM SCSS source files
        "#{font_assets_dir}/ibm*/**/*.eot",
        # Remove OTF versions of fonts (not referenced in the CSS)
        "#{font_assets_dir}/ibm*/**/*.otf"
      ]
        for file in Dir.glob(pattern)
          File.unlink(file)
        end
      end
    end

    task fix_ibm_plex_permissions: outputs do
      # IBM font LICENSE files are marked executable (probably compiled on
      # Windows); undo this.
      common_run("chmod a-x $(find '#{font_assets_dir}' -type f)")
    end

    desc "Download/install IBM Plex fonts to #{font_assets_dir}"
    task all: [outputs, :clean_unused_ibm_plex_files, :fix_ibm_plex_permissions]
  end

  namespace :katex do
    katex_css_src = begin
      candidates = Dir.glob("./vendor/**/vendor/katex/stylesheets/katex.css")
      candidates.length == 1 || raise
      candidates[0]
    end

    katex_css_output = "./assets/katex.css"
    file katex_css_output => [:configure_ruby_bundle] do
      FileUtils.cp(katex_css_src, katex_css_output)
    end

    katex_fonts_outputs = FileList["#{font_assets_dir}/*.woff2"]
    file katex_fonts_outputs => [:configure_ruby_bundle, font_assets_dir] do
      katex_fonts_src = Dir.glob("./vendor/**/vendor/katex/fonts/*.woff2")
      katex_fonts_src.each do |src|
        FileUtils.cp(src, font_assets_dir)
      end
    end

    desc "Copy KaTeX CSS & font assets to #{font_assets_dir}"
    task all: [katex_css_output, katex_fonts_outputs]
  end
  task all: [:"ibm_plex:all", :"katex:all"]
end

desc "Install dependencies"
task configure: [:"configure_conda:all", :configure_ruby_bundle, :"configure_fonts:all"]

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
  task standard: [:configure] do
    bundle_exec("standardrb")
  end

  desc "Ensure no source files contain trailing whitespace"
  task trailing_whitespace: [:configure] do
    common_run("check_trailing_whitespace")
  end

  desc "Ensure conda dependencies are updated"
  task conda_updated: [:configure] do
    common_run("check_conda_updated")
  end

  desc "Ensure bundler dependencies are updated"
  task bundler_updated: [:configure] do
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
