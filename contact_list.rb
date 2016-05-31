require_relative 'contact'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def self.command(argument)
    case argument
      when []
        puts "Here is a list of available commands:
          new    - Create a new contact
          list   - List all contacts
          show   - Show a contact
          search - Search contacts"

      when ['list']
        Contact.all.each_with_index do |entry, i|

          puts "#{i + 1}. #{entry}"
        end
      when ['new']
        puts "Enter name: "
        name = STDIN.gets.chomp
        puts "Enter email"
        email = STDIN.gets.chomp
        Contact.create(name, email)
      when ['show']
      when ['search']
    end
  end
end

ContactList.command(ARGV)