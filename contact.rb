require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email
  
  # Creates a new contact object
  def initialize(name, email)
    @name = name
    @email = email
  end

  def to_s
    "#{name} : #{email}"
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    def all
      all_contacts = CSV.read('contacts.csv')
      all_contacts.map {|arr| Contact.new(arr[0], arr[1])}
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    def create(name, email)
    # Instantiates a Contact, adds its data to the 'contacts.csv' file, and returns it.
      CSV.open('contacts.csv', 'a') { |csv| csv << [name, email] }
      Contact.new(name, email)
    end
    
    # Finds the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      all_contacts = self.all
      all_contacts[id-1] if id.between (0, all_contacts.length)
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(search_string)
    # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      self.all.select {|entry| entry.to_s.downcase.strip.include?(search_string)}
    end

  end

end

