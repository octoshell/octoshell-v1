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
      add_group:    nil,
      add_user:     nil,
      check_user:   nil,
      block_user:   nil,
      unblock_user: nil,
      add_key:      nil,
      check_key:    nil,
      remove_key:   nil,
      remove_user:  nil
    }
    
    @result[:add_group] = @connection.run("sudo /usr/octo/add_group octogroup-test")
    @result[:add_user] = @connection.run("sudo /usr/octo/add_user octouser-#{rand} octogroup-test")
    @result[:check_user] = @connection.run("sudo /usr/octo/check_user octouser-#{rand} octogroup-#{rand}")
    @result[:block_user] = @connection.run("sudo /usr/octo/block_user octouser-#{rand}")
    @result[:unblock_user] = @connection.run("sudo /usr/octo/unblock_user octouser-#{rand}")
    load_key!
    @result[:add_key] = @connection.run("sudo /usr/octo/add_openkey octouser-#{rand} #{@keypath}")
    load_key!
    @result[:check_key] = @connection.run("sudo /usr/octo/check_openkey octouser-#{rand} #{@keypath}")
    load_key!
    @result[:remove_key] = @connection.run("sudo /usr/octo/del_openkey octouser-#{rand} #{@keypath}")
    @result[:remove_user] = @connection.run("sudo /usr/octo/del_user octouser-#{rand}")
  end
  
  private
  def load_key!
    Cocaine::CommandLine.new('scp', "-i #{SSH_KEY_PATH} #{CONFIG_PATH}/keys/test octo@#{@cluster.host}:#{@keypath}").run
  end
end
