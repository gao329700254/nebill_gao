namespace :remove_a_and_b_from_project_cd do
  task run: :environment do
    desc 'when project.cd ends with A or B'
    Project.all.each { |p| p.update_attribute(:cd, p.cd.chop) if p.cd.end_with?('A', 'B') }
  end
end
