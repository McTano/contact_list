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
    return puts 'Must specify id.' unless id
    contact = Contact.find(id)
    puts contact
  end

  def search(term)
    unless term.is_a? String
      return puts 'Search term must be a string (in quotes).'
    end 
    puts Contact.search(term)
  end

  def update(id)
    return puts 'Must specify id.' unless id
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

  def destroy(id)
    target = Contact.find(id)
    puts target
    exit unless target.is_a? Contact
    puts "Are you sure you want to destroy contact #{id}? (y/n)"
    answer = input
    if answer.downcase == 'y' || answer.downcase == 'yes'
      Contact.destroy(id)
      puts "Contact destroyed"
    else
      puts "Destruction aborted."
    end
  end

end