namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        %w(
          project_groups
          projects
          bills
          partners
          members
          project_files
        ).each { |table| populate(table) }
      end
    end

  private

    def populate(table)
      if ENV['all'].present? || ENV[table].present?
        num = ENV[table]&.to_i
        if num.nil? || num.zero?
          puts "populate #{table}"
          send("populate_#{table}")
        else
          puts "populate #{num} #{table}"
          send("populate_#{table}", num)
        end
      end
    end

    def populate_project_groups(num = 3)
      ProjectGroup.destroy_all
      FactoryGirl.create_list(:project_group, num)
    end

    def populate_projects(num = 10)
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
      Bill.destroy_all

      Project.all.each do |project|
        rand(3).times do |_|
          FactoryGirl.create(:bill, project: project)
        end
      end
    end

    def populate_partners(num = 3, company_num = 10)
      Partner.destroy_all
      company_num.times do
        FactoryGirl.create_list(:partner, num, company_name: Faker::Company.name)
      end
    end

    def populate_members(num = 5)
      Member.destroy_all

      Project.all.each do |project|
        Employee.all.sample(num).each do |employee|
          FactoryGirl.create(:member, employee: employee, project: project)
        end
      end
    end

    def populate_project_files(num = 3)
      ProjectFile.destroy_all

      Project.all.each do |project|
        FactoryGirl.create_list(:project_file, num, project: project)
      end
    end
  end
end
