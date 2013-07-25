require "securerandom"

class ClusterCheck
  attr_reader :result, :div
  
  def run(params)
    id = params[:page].to_s[/\/(\d+)$/, 1]
    @div = params[:div]
    @cluster = Cluster.find(id)
    rand = SecureRandom.hex(4)
    @connection = Server::Connection.new(@cluster.host)
    @keypath = "/tmp/octo-#{SecureRandom.hex}"
    
    @result = {
      add_group: {
        cmd: "sudo /usr/octo/add_group octogroup-test",
        expected: "ok"
      },
      add_user: {
        cmd: "sudo /usr/octo/add_user octouser-#{rand} octogroup-test",
        expected: "ok"
      },
      check_user: {
        cmd: "sudo /usr/octo/check_user octouser-#{rand} octogroup-test",
        expected: "active"
      },
      block_user: {
        cmd: "sudo /usr/octo/block_user octouser-#{rand}",
        expected: "ok"
      },
      unblock_user: {
        cmd: "sudo /usr/octo/unblock_user octouser-#{rand}",
        expected: "ok"
      },
      add_key: {
        cmd: "sudo /usr/octo/add_openkey octouser-#{rand} #{@keypath}",
        expected: "ok"
      },
      check_key: {
        cmd: "sudo /usr/octo/check_openkey octouser-#{rand} #{@keypath}",
        expected: "found"
      },
      remove_key: {
        cmd: "sudo /usr/octo/del_openkey octouser-#{rand} #{@keypath}",
        expected: "ok"
      },
      remove_user: {
        cmd: "sudo /usr/octo/del_user octouser-#{rand}",
        expected: "ok"
      }
    }
    
    @result[:add_group][:out]    = @connection.run(@result[:add_group][:cmd])
    @result[:add_user][:out]     = @connection.run(@result[:add_user][:cmd])
    @result[:check_user][:out]   = @connection.run(@result[:check_user][:cmd])
    @result[:block_user][:out]   = @connection.run(@result[:block_user][:cmd])
    @result[:unblock_user][:out] = @connection.run(@result[:unblock_user][:cmd])
    load_key!
    @result[:add_key][:out]      = @connection.run(@result[:add_key][:cmd])
    load_key!
    @result[:check_key][:out]    = @connection.run(@result[:check_key][:cmd])
    load_key!
    @result[:remove_key][:out]   = @connection.run(@result[:remove_key][:cmd])
    @result[:remove_user][:out]  = @connection.run(@result[:remove_user][:cmd])
  end
  
  private
  def load_key!
    Cocaine::CommandLine.new('scp', "-i #{SSH_KEY_PATH} #{CONFIG_PATH}/keys/test octo@#{@cluster.host}:#{@keypath}").run
  end
end
