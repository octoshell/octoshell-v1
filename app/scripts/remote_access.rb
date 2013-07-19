class RemoteAccess
  attr_reader :result
  
  def run(params)
    @access = Access.find(params[:page][%r{/accesses/(\d+)}, 1])
    @result = get_result
  end
  
private
  
  def get_result
    username = @access.cluster_user.username
    public_key = @access.credential.public_key
    path = "/tmp/octo-#{rand(1000000000)}"
    File.open(path, 'w+') { |f| f.write public_key }
    cmd = Cocaine::CommandLine.new('scp', "-i #{SSH_KEY_PATH} #{path} octo@t60.parallel.ru:#{path}")
    $logger.info cmd.command
    cmd.run
    exec = "sudo /usr/octo/check_openkey #{username} #{path}"
    cmd = Cocaine::CommandLine.new('ssh', "-i #{SSH_KEY_PATH} octo@t60.parallel.ru #{exec}")
    $logger.info cmd.command
    cmd.run
    true
  rescue Cocaine::ExitStatusError
    false
  end
end
