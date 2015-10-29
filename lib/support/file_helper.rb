module FileHelper
  
  attr_accessor :filepath

  # Checking for existence
  def file_exists?
    ((self.filepath) && (File.exists?(self.filepath)))
  end
  
  # A usable file is a file that we can read from
  def file_usable?
    return false unless self.file_exists?
    return false unless File.readable?(self.filepath)
    return true
  end

end
