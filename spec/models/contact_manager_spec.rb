#!/usr/bin/env ruby

APP_ROOT = File.dirname(__FILE__)

$:.unshift( File.join(APP_ROOT, 'lib') )
require 'contact_manager'

RSpec.describe ContactManager, :type => :model do

  subject { ContactManager.new('sample.csv') }

  describe "file" do

    it "is found" do
      expect(subject.contacts).to_not be nil
    end

    it "is not found" do
      manager = ContactManager.new('not_found.csv')
      expect(manager.contacts).to be nil
    end

  end

  describe "manager" do
    
    it "handles duplicates" do
      manager = ContactManager.new('sample_duplicates.csv')
      expect(manager.contacts.length).to be == 4
    end

    describe "can list" do
      
      it "all contacts" do
        expect(subject.list.length).to be == 4
      end

      it "by a letter" do
        expect(subject.list("S").length).to be == 2
      end

      it "by a prefix" do
        expect(subject.list("Sa").length).to be == 1
      end

      it "by a wrong prefix" do
        expect(subject.list("X").length).to be == 0
      end

      it "by a nil prefix" do
        expect(subject.list(nil).length).to be == 4
      end

    end

    describe "can search" do

      it "for an existing contact" do
        expect(subject.find("AmyJGhent@dayrep.com").first_name).to be == "Amy"
      end

      it "for a non-existing contact" do
        expect(subject.find("roye.avraham@gmail.com")).to be nil
      end

      it "for a nil E-mail address" do
        expect(subject.find(nil)).to be nil
      end

      it "for an empty E-mail address" do
        expect(subject.find("")).to be nil
      end

    end

  end

end
