#!/usr/bin/env ruby

#### Contact Manager ####
#
# Launch this Ruby file from the command line 
# to get started.
#

APP_ROOT = File.dirname(__FILE__)

$:.unshift( File.join(APP_ROOT, 'lib') )
require 'contact_manager'

contact_manager = ContactManager.new(File.join(APP_ROOT, 'sample.csv'))
contact_manager.launch!
