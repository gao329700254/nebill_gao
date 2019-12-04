class Projects::SortService < BaseService
  def initialize(projects)
    @projects = projects
  end

  def execute
    @projects.sort_by { |p| [status_level(p), category_level(p.cd[2]), p.cd] }
  end

private

  def status_level(project)
    if project.unprocessed
      3
    elsif project.status.finished?
      2
    else
      1
    end
  end

  def category_level(category)
    level = {
      "M" => 1,
      "D" => 2,
      "K" => 3,
      "S" => 4,
      "W" => 5,
      "B" => 6,
    }
    level[category]
  end
end
