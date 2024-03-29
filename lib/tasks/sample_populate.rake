namespace :db do
  namespace :sample do
    desc "Fill database with sample data"
    task populate: :environment do
      ActiveRecord::Base.transaction do
        %w(
          project_groups
          projects
          bills
          bill_details
          members
          clients
          partners
          project_file_groups
          project_files
          default_expense_items
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
      FactoryBot.create_list(:project_group, num)
    end

    def populate_projects(num = 10)
      un_contracted_project_count = 2
      Project.destroy_all

      (num - un_contracted_project_count).times do
        FactoryBot.create(:contracted_project, group: ProjectGroup.all.sample, contract_type: :lump_sum, end_on: 1.week.ago)
      end
      un_contracted_project_count.times do
        FactoryBot.create(:uncontracted_project, group: ProjectGroup.all.sample, contract_type: :lump_sum)
      end
    end

    def populate_bills
      Bill.destroy_all

      Project.where(contracted: true).all.each do |project|
        bill = FactoryBot.create(:bill, project: project, amount: project.amount)
        FactoryBot.create(:bill_applicant, user: FactoryBot.create(:user), bill: bill)
      end
    end

    def populate_bill_details
      BillDetail.destroy_all

      Bill.all.each do |bill|
        FactoryBot.create(:bill_detail, bill: bill, amount: bill.amount)
      end
    end

    def populate_members(num = 2)
      Member.destroy_all

      Project.all.each do |project|
        Employee.where(actable_type: :User).sample(num).each do |employee|
          FactoryBot.create(:user_member, employee: employee, project: project)
        end
        Employee.where(actable_type: :Partner).sample(num).each do |employee|
          FactoryBot.create(:partner_member, employee: employee, project: project)
        end
      end
    end

    def populate_clients(num = 5)
      Client.destroy_all
      FactoryBot.create_list(:client, num, :published)
    end

    def populate_partners
      Partner.destroy_all
      10.times { FactoryBot.create(:partner, client_id: Client.pluck(:id).sample) }
    end

    def populate_project_file_groups(num = 3)
      ProjectFileGroup.destroy_all

      Project.all.each do |project|
        FactoryBot.create_list(:project_file_group, num, project: project)
      end
    end

    def populate_project_files(num = 3)
      ProjectFile.destroy_all

      Project.all.each do |project|
        num.times do
          FactoryBot.create(:project_file, project: project, group: project.file_groups.sample)
        end
      end
    end

    def populate_default_expense_items
      DefaultExpenseItem.destroy_all

      [
        { name: '交通費',                   standard_amount: nil,    is_routing: true,  is_receipt: false },
        { name: '交通費[領]',               standard_amount: nil,    is_routing: true,  is_receipt: true },
        { name: 'タクシー',                 standard_amount: nil,    is_routing: true,  is_receipt: true },
        { name: '会議費・交際費以外の経費', standard_amount: nil,    is_routing: false, is_receipt: true },
        { name: '出張手当',                 standard_amount: 5000,   is_routing: false, is_receipt: false },
        { name: '宿泊手当',                 standard_amount: 10_000,  is_routing: false, is_receipt: false },
        { name: '交際費',                   standard_amount: 10_000,  is_routing: false, is_receipt: true },
        { name: '仮払い',                   standard_amount: 10_000,  is_routing: false, is_receipt: false },
        { name: '会議費',                   standard_amount: 10_000,  is_routing: false, is_receipt: true },
      ].each do |attrs|
        FactoryBot.create(
          :default_expense_item,
          name:            attrs[:name],
          standard_amount: attrs[:standard_amount],
          display_name:    attrs[:name],
          is_routing:      attrs[:is_routing],
          is_receipt:      attrs[:is_receipt],
          is_quantity:     false,
          note:            attrs[:name],
        )
      end
    end
  end
end
