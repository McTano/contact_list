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
      result = Contact.connection.exec('INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;', [name, email])
      @id = result.first['id'].to_i
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
          Contact.new(contact['name'], contact['email'], contact['id'])
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
      return 'Not found.' if result.nil?
      Contact.new(result['name'], result['email'], result['id'])
    end

    def search(term)
      results = connection.exec('SELECT * FROM contacts WHERE UPPER(name) LIKE $1 OR UPPER(email) LIKE $1', ["%#{term.upcase}%"]).map do |result|
        Contact.new(result['name'], result['email'], result['id'])
      end
      results.empty? ? 'No matches found.' : results
    end

    def destroy(id)
      connection.exec('DELETE FROM contacts WHERE id = $1::int', [id])
    end
  end
end