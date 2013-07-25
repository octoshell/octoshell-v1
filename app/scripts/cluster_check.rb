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
      add_group:    false,
      add_user:     false,
      check_user:   false,
      block_user:   false,
      unblock_user: false,
      add_key:      false,
      check_key:    false,
      remove_key:   false,
      remove_user:  false
    }
    
    if @connection.run("sudo /usr/octo/add_group octogroup-test") == "ok"
      @result[:add_group] = true
    end
    
    if @connection.run("sudo /usr/octo/add_user octouser-#{rand} octogroup-test") == "ok"
      @result[:add_user] = true
    end
    
    if @connection.run("sudo /usr/octo/check_user octouser-#{rand} octogroup-#{rand}") == "active"
      @result[:check_user] = true
    end
    
    if @connection.run("sudo /usr/octo/block_user octouser-#{rand}") == "ok"
      @result[:block_user] = true
    end
    
    if @connection.run("sudo /usr/octo/unblock_user octouser-#{rand}") == "ok"
      @result[:unblock_user] = true
    end
    
    load_key!
    if @connection.run("sudo /usr/octo/add_openkey octouser-#{rand} #{@keypath}") == "ok"
      @result[:add_key] = true
    end
    
    load_key!
    if @connection.run("sudo /usr/octo/check_openkey octouser-#{rand} #{@keypath}") == "found"
      @result[:check_key] = true
    end
    
    load_key!
    if @connection.run("sudo /usr/octo/del_openkey octouser-#{rand} #{@keypath}") == "ok"
      @result[:remove_key] = true
    end
    
    if @connection.run("sudo /usr/octo/del_user octouser-#{rand}") == "ok"
      @result[:remove_user] = true
    end
  end
  
  private
  def load_key!
    Cocaine::CommandLine.new('scp', "-i #{SSH_KEY_PATH} #{CONFIG_PATH}/keys/test octo@#{@cluster.host}:#{@keypath}").run
  end
end
