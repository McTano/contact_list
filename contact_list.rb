#!/usr/bin/env ruby
require_relative 'contact'


class ContactList

    command = ARGV
    case 
    when command == ['list']
      id = 1
      stop = 5
      loop do
        until id > stop
        contacts = Contact.list 
          puts "#{id}. #{contacts[id - 1  ]}"
          id += 1
          exit if id > contacts.length
        end 
        stop += 5
        puts "'y' for next page. 'q' or 'n' to quit."
        input = STDIN.gets.chomp.strip.downcase
        case input
        when 'n', 'q'
          break
        end
      end


    when command == ['new']
      puts "Enter name: "
      name = STDIN.gets.chomp.strip
      
# loop validates email and checks if it is already present in the csv before
# creating the new contact. Asks again if email is invalid.
      email = ''
      loop do
        puts "Enter email"
        email = STDIN.gets.chomp.strip.downcase
        if !(email =~ /.*@.*/)
          puts "Invalid email."
        elsif Contact.list.any? {|entry| entry.include?(email)}
          puts "Contact is already present."
          exit
        else
          break
        end
      end
# loop adds as many phone numbers as user wants
      phone_numbers = {}
      puts "Add a phone number? (y/n)"
      loop do
        answer = STDIN.gets.chomp.strip.downcase
        if answer == 'y'
          puts "Enter a label. (e.g. 'mobile')"
          label = STDIN.gets.chomp.strip.downcase.to_sym
          puts "Enter the phone number."
          number = STDIN.gets.chomp
          phone_numbers[label] = number
          puts "Add another phone number? (y/n)"
        elsif answer == 'n'
          break
        else
          puts "Please answer 'y' or 'n'."
        end
      end

      Contact.create(name, email, phone_numbers)

    when command.length == 2 && command[0] == 'show'
      
      id = command[1].to_i
      contact = Contact.show(id)
      
      if contact
        puts "#{id}.  #{contact}"
      else
        puts "No contact matching ID"
      end

    when command.length >= 2 && command[0] == 'search'
      
      search_string = command[1..-1].join(' ').downcase.strip
      puts Contact.search(search_string)
    
    else
      puts "Here is a list of available commands:
        new    - Create a new contact
        list   - List all contacts
        show [id]   - Show a contact
        search [string] - Search contacts"
    end
end