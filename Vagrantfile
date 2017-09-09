Vagrant.configure("2") do |config|
  config.vm.provider "docker" do |d|
    d.build_dir = "."
    vol = Dir.pwd + ':/helloawsnode' 
    d.volumes = [vol, "/var/run/docker.sock:/var/run/docker.sock"]
    d.name = "helloawsnode-dev-container" 
    d.dockerfile = "Dev-Dockerfile"
    d.build_args = ["-t", "helloawsnode-dev-image"]
    d.create_args = ["--net", "host"]
  end
end
