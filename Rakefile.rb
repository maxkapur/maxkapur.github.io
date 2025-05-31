def bash(commands)
    sh "bash -c '#{commands.join(' && ')}'"
end

def common_run(command)
    bash(['source "./_scripts/common.sh"', command])
end

def conda_run(command)
    bash(['source "./_scripts/common.sh"', 'activate_conda_environment', command])
end

desc "Install dependencies"
task :configure do
    # TODO
end

desc "Print environment and package information"
task info: [:configure] do
    conda_run "conda info"
    conda_run "conda list"
    conda_run "bundle list"
end

desc "Preview site locally"
task preview: [:configure] do
    conda_run "bundle exec jekyll serve -o --future"
end
