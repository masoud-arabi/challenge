require 'json'

class Company
  def initialize(file_path)
    @companies = []
    @file_path = file_path
    load_json
  end

  def load_json
    begin
      file_companies = File.read(@file_path)
      @companies = JSON.parse(file_companies)
    rescue Errno::ENOENT, JSON::ParserError => e
      puts "Failed to open #{@file_path} or invalid JSON format: #{e.message}"
    end
  end

  def all 
    @companies.sort_by { |company| company['id'] }
  end
 
end


class User
  def initialize(file_path)
    @users = []
    @file_path = file_path
    load_json
  end

  def load_json 
    begin
      file_users = File.read(@file_path)
      @users = JSON.parse(file_users)
    rescue Errno::ENOENT, JSON::ParserError => e
      puts "Failed to open #{@file_path} or invalid JSON format: #{e.message}"
    end
  end

  def all
    @users
  end

end


class Controller 
  def initialize(company_file, user_file)
    @company = Company.new(company_file)
    @user = User.new(user_file)
    @companies_information = []
  end

  def list_all_info
    companies = @company.all
    company_parse(companies)
    full_text_result
  end
  

  private

  def company_parse(companies)
    companies.each do |company|
      user_emailed_unemailed = user_parse(company['id'], company['top_up'])
      total_top_up = company_topup_cal(user_emailed_unemailed, company['top_up'])
      company_info = {
        'name' => company['name'],
        'total_top_up' => total_top_up,
        'top_up' => company['top_up'] ||= 0,
        'emailed' => user_emailed_unemailed[0],
        'un_emailed' =>  user_emailed_unemailed[1],
        'id' => company['id']
      }
      @companies_information << company_info
    end
    @companies_information
  end
  
  def user_parse(company_id, company_topup)
    users_emailed = []
    users_unemailed = []
    @users = @user.all
    @users.each do |user|
      if user['company_id'] == company_id && user['active_status'] == true
        user['new_tokens'] = user['tokens'] + company_topup if user.key?('tokens')
        if user['email_status'] == true
          users_emailed << user
        else
          users_unemailed << user
        end
      end
    end
    return [users_emailed, users_unemailed]
  end

  def full_text_result
    all_companies_text = @companies_information.map do |company|
      user_emailed = user_text_part(company['emailed']) if company.key?('emailed')
      user_unemailed = user_text_part(company['un_emailed']) if company.key?('un_emailed')
      <<~TEXT
        \tCompany_id: #{company['id']}
        \tCompany Name: #{company['name']}
        \tUsers Emailed:\n#{user_emailed}\tUsers Not Emailed:
        #{user_unemailed}\t\tTotal amount of top ups for #{company['name']}: #{company['total_top_up']}\n
      TEXT
    end.join("")
  end

  def user_text_part(user_email_info)
    user_email_info = user_email_info.sort_by { |user| user['last_name'] }
    user_text = user_email_info.map do |item|
      <<~TEXT
        \t\t#{item['last_name']}, #{item['first_name']}, #{item['email']}
        \t\t  Previous Token Balance, #{item['tokens']}
        \t\t  New Token Balance #{item['new_tokens']}
      TEXT
    end.join("")
  end
  
  def company_topup_cal(user_email, top_up)
    emailed, unemailed = user_email[0], user_email[1]
    (emailed.size + unemailed.size) * top_up
  end

end


class Compile
    def initialize(company_file, user_file)
      @controller = Controller.new(company_file, user_file)
      output
    end
    
    def output
      File.open("file.txt", 'w') do |file|
        final_text_info = @controller.list_all_info
        file.write(final_text_info)
      end
    end
end

Compile.new('./data/companies.json', './data/users.json')
