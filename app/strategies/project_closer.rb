class ProjectCloser
  def initialize(project, code)
    @project = project
    @code = code
  end
  
  def close
    if @project.title == @code
      @project.close
    else
      false
    end
  end
end
