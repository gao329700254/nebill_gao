namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        populate_project_groups
        populate_projects
        populate_bills
      end
    end

  private

    def populate_project_groups(num = 3)
      puts "populate project groups"
      ProjectGroup.destroy_all
      FactoryGirl.create_list(:project_group, num)
    end

    def populate_projects(num = 10)
      puts "populate projects"
      un_contracted_project_count = 2
      Project.destroy_all

      (num - un_contracted_project_count).times do
        FactoryGirl.create(:contracted_project, group: ProjectGroup.all.sample)
      end
      un_contracted_project_count.times do
        FactoryGirl.create(:uncontracted_project, group: ProjectGroup.all.sample)
      end
    end

    def populate_bills
      puts 'populate bills'
      Bill.destroy_all

      Project.all.each do |project|
        rand(3).times do |_|
          FactoryGirl.create(:bill, project: project)
        end
      end
    end
  end
end
