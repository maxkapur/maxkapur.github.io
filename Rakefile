require "tmpdir"
require "rake/clean"

desc "Install dependencies"
multitask configure: [:bundle_install, :ibm_plex_fonts, :katex_files]

desc "Print environment and package information"
task info: [:configure] do
  sh(*"which ruby bundle".split)
  sh(*"ruby --version".split)
  sh(*"bundle list".split)
end

desc "Format source files"
task format: [:bundle_install] do
  # Currently all does is format this Rakefile; haven't found a formatter for
  # other filetypes that works for me yet.
  puts "# Format Ruby files"
  sh(*"bundle exec standardrb --fix".split)
end

desc "Preview site locally"
task preview: [:configure] do
  # Use a temp dir to distinguish preview from production build in _site/
  Dir.mktmpdir do |tempd|
    sh(*"bundle exec jekyll serve --open-url --future --destination".split, tempd)
  end
end

desc "Build site for publication"
task build: [:configure] do
  sh(*"bundle exec jekyll build".split)
end

desc "Check various source and build issues"
multitask check: [:check_source, :check_build]

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

# Bundle/Ruby dependency installation
begin
  task bundle_install: [TASK_SENTINELS[:bundle_install]]

  file TASK_SENTINELS[:bundle_install] => ["./Gemfile"] do
    try_install_apt_dependencies
    puts "# Install Ruby dependencies"
    sh(*"bundle install".split)
  end

  def try_install_apt_dependencies
    unless system "apt-get", "--version", out: File::NULL
      joined = APT_DEPENDENCIES.join(" ")
      warn "Unable to check for apt dependencies as system is not Debian-like, but here's what I would have tried to install in case it's useful: #{joined}"
      return
    end

    print "# Check if apt dependencies are present: "
    if system "dpkg-query", "-s", *APT_DEPENDENCIES, out: File::NULL
      puts "OK"
      return
    end

    puts "Not yet"
    puts "# Attempting sudo install (you may be prompted for password)"
    sh(*"sudo apt-get install --yes --no-upgrade".split, *APT_DEPENDENCIES)
  end
end

# IBM Plex fonts
begin
  task ibm_plex_fonts: [TASK_SENTINELS[:ibm_plex_download_extract]]

  file TASK_SENTINELS[:ibm_plex_download_extract] => [FONT_ASSETS_DIR] do
    puts "# Download & extract IBM Plex fonts"
    sources = {
      ibm_plex_mono: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip",
      ibm_plex_sans: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip",
      ibm_plex_sans_kr: "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-kr%401.1.0/ibm-plex-sans-kr.zip"
    }
    Dir.mktmpdir do |tempd|
      sources.map do |basename, url|
        puts "# Download #{url.split("/")[-1]}"
        zipfile = "#{tempd}/#{basename}.zip"
        # -s: silent mode
        # -S: but show errors
        # -L: follow redirect
        sh "curl", "-sSL", url, "-o", zipfile
        zipfile
      end.each do |zipfile|
        puts "# Unzip #{zipfile} to #{FONT_ASSETS_DIR}"
        # -q: quiet mode
        # -o: overwrite existing without prompting
        # -DD: force current timestamp (else Rake keeps rerunning this task)
        sh "unzip", "-qoDD", zipfile, "*.css", "*.woff2", "-d", FONT_ASSETS_DIR
      end
    end
    # Check that this actually created the sentinel file
    File.file?(TASK_SENTINELS[:ibm_plex_download_extract]) || fail
    # Some files are errantly marked executable (probably compiled on Windows)
    # TODO: glob inside ruby
    sh "chmod a-x $(find '#{FONT_ASSETS_DIR}' -type f)"
  end
end

# KaTeX CSS and fonts
begin
  task katex_files: ["./assets/katex.css", TASK_SENTINELS[:katex_woff2s_copy]]

  def css_src
    candidates = Dir.glob("./vendor/**/vendor/katex/stylesheets/katex.css")
    unless candidates.length == 1
      puts candidates
      raise "Found #{candidates.length} katex.css files, expected 1"
    end
    candidates[0]
  end

  file "./assets/katex.css" => [TASK_SENTINELS[:bundle_install]] do
    print "# Copy #{File.basename(css_src)} to ./assets/: "
    FileUtils.cp(css_src, "./assets/katex.css")
    puts "OK"
  end

  file TASK_SENTINELS[:katex_woff2s_copy] => [TASK_SENTINELS[:bundle_install], FONT_ASSETS_DIR] do
    puts "# Copy KaTeX fonts to #{FONT_ASSETS_DIR}"
    katex_fonts_src = Dir.glob("./vendor/**/vendor/katex/fonts/*.woff2")
    katex_fonts_src.each do |src|
      print "# Copy #{File.basename(src)} to #{FONT_ASSETS_DIR}: "
      FileUtils.cp(src, FONT_ASSETS_DIR)
      puts "OK"
    end
    # Check that this actually created the file
    File.file?(TASK_SENTINELS[:katex_woff2s_copy]) || fail
  end
end

# Lint source files
begin
  multitask check_source: [:standard, :trailing_whitespace, :bundle_outdated]

  task standard: [:bundle_install] do
    puts "# Check formatting with standardrb"
    # NOTE: Need to bundle exec this (instead of using standard/rake) because
    # the standardrb gem may not have been installed yet
    sh(*"bundle exec standardrb".split)
  end

  task :trailing_whitespace do
    puts "# Ensure no source files contain trailing whitespace"
    system(*"git grep -IE \\s$".split) && fail
  end

  task bundle_outdated: [:bundle_install] do
    puts "# Ensure bundler dependencies are updated"
    sh(*"bundle outdated --only-explicit".split)
  end
end

# Lint site build
begin
  multitask check_build: [:html_proofer, :url_schema, :jekyll_doctor]

  task html_proofer: [:build] do
    puts "# Check build with HTML-Proofer"
    options = ["--disable-external"]
    sh(*"bundle exec htmlproofer ./_site/".split, *options)
  end

  task url_schema: [:build] do
    print "# Check stability of URL schema: "
    f = "./_site/2022/06/25/migrating-to-jekyll.html"
    File.file?(f) || fail
    puts "#{f} exists"
  end

  task jekyll_doctor: [:build] do
    puts "# Check for deprecation warnings with Jekyll doctor"
    sh(*"bundle exec jekyll doctor".split)
  end
end
