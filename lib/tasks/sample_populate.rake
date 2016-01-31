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
      Project.destroy_all
      FactoryGirl.create_list(:project, num)
    end
  end
end
