namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        populate_project_groups
        populate_projects
        populate_bills
        populate_partners
        populate_members
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

    def populate_partners(company_num = 10, num = 3)
      puts 'populate partners'
      Partner.destroy_all
      company_num.times do
        FactoryGirl.create_list(:partner, num, company_name: Faker::Company.name)
      end
    end

    def populate_members(num = 5)
      puts 'populate members'
      Member.destroy_all

      Project.all.each do |project|
        Employee.all.sample(num).each do |employee|
          FactoryGirl.create(:member, employee: employee, project: project)
        end
      end
    end
  end
end
