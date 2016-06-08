# class Interface

#     def list
#       id = 1
#       stop = 5
#       loop do

#         until id > stop
#         contacts = Contact.list 
#           puts "#{id}. #{contacts[id - 1  ]}"
#           id += 1
#           exit if id > contacts.length
#         end 

#         stop += 5
#         puts "'y' for next page. 'q' or 'n' to quit."
#         input = STDIN.gets.chomp.strip.downcase

#         case input
#         when 'n', 'q'
#           break
#         end

#       end
#     end

#     def get_email
#       email = ''
#       loop do
#         puts "Enter email"
#         email = STDIN.gets.chomp.strip.downcase
#         if !(email =~ /.*@.*/)
#           puts "Invalid email."
#         elsif Contact.list.any? {|entry| entry.include?(email)}
#           puts "Contact is already present."
#           exit
#         else
#           break
#         end
#       end
#       email
#     end

#     def get_phone_numbers
#       phone_numbers = {}
#       puts "Add a phone number? (y/n)"
#       loop do
#         answer = STDIN.gets.chomp.strip.downcase
#         if answer == 'y'
#           puts "Enter a label. (e.g. 'mobile')"
#           label = STDIN.gets.chomp.strip.downcase.to_sym
#           puts "Enter the phone number."
#           number = STDIN.gets.chomp
#           phone_numbers[label] = number
#           puts "Add another phone number? (y/n)"
#         elsif answer == 'n'
#           break
#         else
#           puts "Please answer 'y' or 'n'."
#         end
#       end
#       phone_numbers
#     end

#     def create
#       puts "Enter name: "
#       name = STDIN.gets.chomp.strip
      
#       # loop validates email and checks if it is already present in the csv before
#       # creating the new contact. Asks again if email is invalid.
#       email = get_email

#       # loop adds as many phone numbers as user wants
#       phone_numbers = get_phone_numbers

#       Contact.create(name, email, phone_numbers)
#     end

    # def show(id)
    #   contact = Contact.show(id)
    #   if contact
    #     puts "#{id}.  #{contact}"
    #   else
    #     puts "No contact matching ID"
    #   end
    # end

#     def search(input)
#       search_string = input.join(' ').downcase.strip
#       results = Contact.search(search_string)
#       if results.empty?
#         puts "No matches."
#       else
#         puts results
#       end
#     end


#   end


module Interface
  def input
    STDIN.gets.chomp.strip
  end

  def get_name
    puts 'Enter new contact name:'
    input
  end

  def get_email
    puts 'Enter new contact email:'
    input
  end

  def create
    name = get_name
    email = get_email
    puts Contact.create(name, email)
  end

  def list
    puts Contact.all
  end

  def show(id)
    return puts "Must specify id." unless id
    contact = Contact.find(id)
    puts contact
  end

  def search(term)
    unless term.is_a? String
      return puts "Search term must be a string (in quotes)."
    end 
    puts Contact.search(term)
  end

  def update(id)
    return puts "Must specify id." unless id
    contact = Contact.find(id)
    puts contact
    exit unless contact.is_a? Contact
    loop do
      puts 'Update which field?
        1.Name
        2.Email
        3.Both
        4.Cancel'
      case input
      when '1'
        contact.name = get_name
        break
      when '2'
        contact.email = get_email
        break
      when '3'
        contact.name = get_name
        contact.email = get_email
        break
      when '4'
        puts 'Goodbye.'
        exit
      else
        puts 'Input must be 1, 2, 3, or 4.'
      end
    end
    puts contact.save
  end

  def print_menu
    puts "Here is a list of available commands:
      new    - Create a new contact
      list   - List all contacts
      show <ID>   - Find contact with given integer ID
      search 'string' - Search for contacts matching 'string'
      update <ID> - update contact with given integer ID"
  end

end