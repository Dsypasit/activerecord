require 'sqlite3'
require 'active_record'
require 'byebug'
require 'date'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    where(first: 'Candice').all
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    user = where.not(email: nil)
    user.where('email like ?', '%@%')
  end

  # etc. - see README.md for more details
  def self.with_dot_org_email
    user = with_valid_email
    user.where('email like ?', '%.org%')
  end

  def self.with_invalid_email
    user = where.not(email: nil)
    user.where.not('email like ?', '%@%')
  end

  def self.with_blank_email
    where(email: nil)
  end

  def self.born_before_1980
    where('birthdate < ?', '1980-01-01')
  end

  def self.with_valid_email_and_born_before_1980
    user = where('birthdate < ?', '1980-01-01')
    user.where('email like ?', '%@%')
  end

  def self.last_names_starting_with_b
    where('last like ?', 'B%').order('birthdate')
  end

  def self.change_all_invalid_emails_to_blank
    user = where(email: nil)
    user.destroy_all
    user = where.not('email like ?', '%@%')
    user.destroy_all
  end

  def self.delete_meggie_herman
    find_by(first: 'Meggie', last: 'Herman').destroy
  end

  def self.delete_everyone_born_before_1978
    where('birthdate < ?', Time.parse('1 January 1978')).destroy_all
  end

  def self.twenty_youngest
    order('birthdate').reverse_order.limit(20)
  end

  def self.update_gussie_murray_birthdate
    user = find_by(first: 'Gussie')
    user.update(birthdate: Time.parse('9 February 2004'))
  end
end
