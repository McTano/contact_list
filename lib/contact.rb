# require 'csv'

# CONTACTS_PATH = "/home/tristan/LHL/w2/d1/contact_list/contacts.csv"

# class Contact
  
#   # Creates a new contact object
#   def initialize(name, email, phone_numbers)
#     @name = name.strip
#     @email = email
#     @phone_numbers = phone_numbers
#   end

#   def to_s
#     "#{@name} : #{@email}, #{@phone_numbers}"
#   end

#   def include?(string)
#     @name.include?(string) || @email.include?(string)
#   end

#   # Provides functionality for managing contacts in the csv file.
#   class << self

#     # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
#     def list
#       all_contacts = CSV.read(CONTACTS_PATH)
#       all_contacts.map {|arr| Contact.new(arr[0], arr[1], arr[2])}
#     end

#    # Creates a new contact, adding it to the csv file, returning the new contact.
#     def create(name, email, phone_numbers)
#       # Instantiates a Contact, adds its data to the 'contacts.csv' file, and returns
#       # it.
#       CSV.open(CONTACTS_PATH, 'a') { |csv| csv << [name, email, phone_numbers] }
#       Contact.new(name, email, phone_numbers)
#     end
    
#     # Find the Contact in the 'contacts.csv' file with the matching id. IDs start
#     # at 1, rather than zero, so the index = id-1
#     def show(id)
#       all_contacts = self.list
#       all_contacts[id-1] if id.between?(1, all_contacts.length)
#     end
    
#     # Searches the contacts and returns all matches
#     def search(search_string)
#       self.list.select {|entry| entry.to_s.downcase.strip.include?(search_string)}
#     end

#   end

# end

require 'pg'

class Contact
  attr_accessor :name, :email
  attr_reader  :id

  def initialize(name, email, id=nil)
    @name = name
    @email = email
    @id = id
  end

  def to_s
    "#{@id}. #{@name}, #{@email}"
  end

  def save
    if id
      Contact.connection.exec('UPDATE contacts SET name=$1, email=$2 WHERE id = $3;', [name, email, id])
    else
      result = Contact.connection.exec("INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;", [name, email])
      @id = result.first["id"].to_i
    end
    self
  end

  class << self

    def connection
      PG.connect({
        host: 'localhost',
        dbname: 'contacts',
        user: 'development',
        password:'development'
        })
    end

    def all
        connection.exec('SELECT * FROM contacts ORDER BY id ASC;').map do |contact|
          Contact.new(contact["name"], contact["email"], contact["id"])
        end
    end

   # Creates a new contact, adds it to the database file, returns the new contact.
    def create(name, email)
      contact = Contact.new(name, email)
      contact.save
      contact
    end

    def find(id)
      result = connection.exec('SELECT * FROM contacts WHERE id = $1::int;', [id.to_i]).first
      return "Not found." if result.nil?
      Contact.new(result["name"], result["email"], result["id"])
    end

    def search(term)
      results = connection.exec("SELECT * FROM contacts WHERE UPPER(name) LIKE $1 OR UPPER(email) LIKE $1", ["%#{term.upcase}%"]).map do |result|
        Contact.new(result["name"], result["email"], result["id"])
      end
      puts results.empty? ? "No matches found." : results
    end
  end
end