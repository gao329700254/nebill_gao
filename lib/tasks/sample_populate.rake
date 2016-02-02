namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        populate_projects
      end
    end

  private

    def populate_projects(num = 10)
      puts "populate projects"
      un_contracted_project_count = 2
      Project.destroy_all
      FactoryGirl.create_list(:contracted_project, num - un_contracted_project_count)
      FactoryGirl.create_list(:un_contracted_project, un_contracted_project_count)
    end
  end
end
