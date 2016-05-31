require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
    command = ARGV
    case 
    when command == ['list']
      Contact.all.each_with_index do |entry, i|
        puts "#{i + 1}. #{entry}"
      end

    when command == ['new']
      puts "Enter name: "
      name = STDIN.gets.chomp
      loop do
        puts "Enter email"
        email = STDIN.gets.chomp
        if !(email =~ /.*@.*/)
          puts "Invalid email."
        elsif Contact.all.include?(email)
          puts "Cannot add duplicate email."
        else
        Contact.create(name, email)
        break
        end
      end

    when command.length == 2 && command[0] == 'show'
      
      id = command[1].to_i
      contact = Contact.find(id)
      
      if contact
        puts "#{id}.  #{contact}"
      else
        puts "No contact matching ID #{id}."
      end

    when command.length >= 2 && command[0] == 'search'
      
      search_string = command[1..-1].join(' ').downcase.strip
      puts Contact.search(search_string)
    
    else
    puts "Here is a list of available commands:
      new    - Create a new contact
      list   - List all contacts
      show   - Show a contact
      search - Search contacts"
    end
end