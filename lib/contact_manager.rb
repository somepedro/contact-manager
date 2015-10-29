#!/usr/bin/env ruby

require 'csv'
require 'support/file_helper'
require 'contact'

class ContactManager
  include FileHelper

  attr_accessor :contacts, :duplicates

  @@actions = ['list', 'find', 'quit']

  # Initializes the contact manager with a file 
  def initialize(path = nil)
    
    self.filepath = path

    if self.file_usable?
      self.contacts = load_contacts
    end

  end

  # Launches the text console
  def launch!

    # If contacts loading failed
    if self.contacts.nil?
      puts "ERROR: File not found.\nExiting."
      exit!
    else

      show_introduction
      result = nil

      # Loop until quit requested
      until result == :quit
        action, args = get_action
        result = do_action(action, args)
      end

    end

  end
  
  # Finding a contact in the hash - O(1)
  def find(email)
    contact = self.contacts[email]
  end

  # List all contacts or filter by a first letter/prefix
  def list(prefix = "")  
    
    # Converting to hash to array in order to sort it
    contacts = self.contacts.values
    
    # Filtering by prefix requested
    if prefix
      contacts = contacts.select do |contact|
        contact.last_name &&
        contact.last_name.downcase.start_with?(prefix.downcase)
      end
    end

    # Sorting by last name
    contacts.sort! do |r1, r2|
      r1.last_name.downcase <=> r2.last_name.downcase
    end

  end

  private

  # Returns hash in order to offer O(1) searching
  def load_contacts
    
    contacts = {}
    duplicates = false

    CSV.read(self.filepath, :headers => true).collect do |row|
      hash = row.to_hash
      current_value = contacts[hash["email"]]

      # According to RFC 2821, the local mailbox is considered case-sensitive.
      # Otherwise, it would be better to use downcase for the keys
      # Also, Cannot satisfy O(1) search with multiple values for a key, therefore ignoring.
      if current_value
        duplicates = true
      else
        contacts[hash["email"]] = Contact.new(hash)
      end

    end

    contacts
  
  end
  
  # Input methods
  
  # Retrieves the desired action
  def get_action
    puts "\nActions: " + @@actions.join(", ")
    print "> "
    user_response = gets.chomp
    args = user_response.strip.split(' ')
    action = args.shift
    return action, args
  end
  
  # Handles all the screen output
  def do_action(action, args = [])
    case action
    when 'list', 'l' # List
      
      prefix = args.shift
      
      output_action_header("Listing contacts" + (prefix ? " starting with '#{prefix}'" : ""))
      
      # Finding the matching contacts (or all)
      contacts = list(prefix)

      # Printing the contacts
      output_contact_table(contacts)

      if !prefix
        puts "You can also filter contacts with prefix."
        puts "Example: 'list S'\n\n"
      end

    when 'find', 'f' # Find

      email = args.shift

      output_action_header("Find a contact")

      if (email.nil?) || (email.length == 0)
        puts "Find a contact by E-mail."
        puts "Example: 'find AmyJGhent@dayrep.com'\n\n"
      else

        # Finding the exact match contact
        contact = find(email)

        # Printing the contact
        output_contact_table(contact.nil? ? [] : [contact])
      end

    when 'quit', 'q', 'exit', 'x' # Quit
      return :quit
    else
      puts "\nUnknown command.\n"
    end
  end

  # Output methods

  def show_introduction
    puts "\n\n<<< Welcome to the Contact Manager >>>\n\n"
    puts "This is an interactive contact manager to help you find your contacts.\n\n"
  end
	
	private
	
	def output_action_header(text)
	  puts "\n#{text.upcase.center(100)}\n\n"
	end

  # Printing the contacts in the following format:
  # Last: last_name, First: first_name, Phone: phone, E-Mail: email
  # Input has to be an array and not a hash because it is sorted
	def output_contact_table(contacts = [])
    if contacts.empty?
      puts "No listings found"
    else
      contacts.each do |contact|
        puts "Last: #{contact.last_name}, First: #{contact.first_name}, Phone: #{contact.phone}, E-Mail: #{contact.email}"
      end
      puts ""
    end
  end
  
end
