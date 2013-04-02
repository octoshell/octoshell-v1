class ProjectCloser
  def initialize(project, code)
    @project = project
    @code = code
  end
  
  def close
    if @project.name == @code
      @project.close
    else
      false
    end
  end
end
