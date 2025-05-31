def bash(*commands)
    sh "bash -c '#{commands.join(' && ')}'"
end

def common_run(*commands)
    bash('source "./_scripts/common.sh"', *commands)
end

def conda_run(*commands)
    bash('source "./_scripts/common.sh"', 'activate_conda_environment', *commands)
end

def bundle_exec(command)
    # TODO: splat
    conda_run("bundle exec #{command}")
end


desc "Ensure mamba command is available"
task :ensure_mamba do
    common_run("command -v mamba")
end

begin
    # List of files used to indicate presence of conda environment and whether
    # it is updated
    conda_env_files = FileList[
        "./.conda/conda-meta/*.json",
        "./.conda/conda-meta/history",
    ]

    file conda_env_files => [:ensure_mamba] do
        commands=[
            # Location of the conda environment definition YML
            'CONDA_ENV_YML=$(realpath "./_conda_environment.yml")',
            # Install destination for the conda environment
            'CONDA_PREFIX=$(realpath "./.conda")',
            # Set CI=True to prevent weird progress bar in mamba update/create:
            # https://github.com/mamba-org/mamba/issues/1478
            'export CI="True"',
            'mamba env create --prefix "$CONDA_PREFIX" --file "$CONDA_ENV_YML" --yes',
        ]
        common_run(commands)
    end

    desc "Create conda environment (mamba env create)"
    file configure_conda_environment: conda_env_files do
    end
end

desc "Install Ruby dependencies (bundle install/update)"
task configure_ruby_bundle: [:configure_conda_environment] do
    conda_run("bundle install")
end

desc "Install dependencies"
task :configure do
    # TODO
end

desc "Print environment and package information"
task info: [:configure] do
    conda_run 'conda info'
    conda_run 'conda list'
    conda_run 'bundle list'
end

desc "Preview site locally"
task preview: [:configure] do
    bundle_exec 'jekyll serve -o --future'
end

desc "Build site for publication"
task build: [:configure] do
    bundle_exec 'jekyll build'
end

desc "Lint source files"
namespace :check_source do
    desc "Lint shell scripts with shellcheck"
    task shellcheck: [:configure] do
        # TODO: Perform globbing within Ruby
        conda_run(
            'SHELL_SCRIPTS=$(find . -maxdepth 2 -iname "*.sh")',
            'echo ${SHELL_SCRIPTS[@]}',
            'shellcheck ${SHELL_SCRIPTS[@]}',
        )
    end

    desc "Ensure no source files contain trailing whitespace"
    task trailing_whitespace: [:configure] do
        common_run('check_trailing_whitespace')
    end

    desc "Ensure conda dependencies are updated"
    task conda_updated: [:configure] do
        common_run('check_conda_updated')
    end

    desc "Ensure bundler dependencies are updated"
    task bundler_updated: [:configure] do
        common_run('check_bundler_updated')
    end

    multitask all: [:shellcheck, :trailing_whitespace, :conda_updated]
end

desc "Lint site build"
namespace :check_build do
    desc "Check build with HTML-Proofer"
    task html_proofer: [:build] do
        options=["--disable-external"].join(" ")
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
task check: [:"check_source:all", :"check_build:all"] do
end
