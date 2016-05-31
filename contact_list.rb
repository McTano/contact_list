require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def self.command(arg)
    case
    when arg == []
      puts "Here is a list of available commands:
        new    - Create a new contact
        list   - List all contacts
        show   - Show a contact
        search - Search contacts"

    when arg == ['list']
      Contact.all.each_with_index do |entry, i|
        puts "#{i + 1}. #{entry}"
      end

    when arg == ['new']
      puts "Enter name: "
      name = STDIN.gets.chomp
      puts "Enter email"
      email = STDIN.gets.chomp
      Contact.create(name, email)

    when arg.length == 2 && arg[0] == 'show'
      
      id = arg[1].to_i
      contact = Contact.find(id)
      
      if contact == false
        puts "No contact matching ID #{id}."
      else
        puts "#{id}.  #{contact}"
      end

    when arg.length >= 2 && arg[0] == 'search'
      
      search_string = arg[1..-1].join(' ').downcase.strip
      puts Contact.search(search_string)
    
    else
      puts "Oh no! #{arg}"
    end
  end
end

ContactList.command(ARGV)