# Try to determine the terminal with.
# If it is not possible to to so, it returns the default_width.
# <tt>default_width</tt> Defaults to 81
def terminal_width(default_width = 81)
  tiocgwinsz = 0x5413
  data = [0, 0, 0, 0].pack("SSSS")
  if @out.ioctl(tiocgwinsz, data) >= 0 
    rows, cols, xpixels, ypixels = data.unpack("SSSS")
    raise unless cols > 0
    cols
  else
    raise
  end
rescue   
  begin 
    IO.popen('stty -a') do |pipe|
      column_line = pipe.detect { |line| /(\d+) columns/ =~ line }
      raise unless column_line
      $1.to_i
    end
  rescue
    default_width
  end
end

# Copies request-log-analyzer analyzer rake tasks into the /lib/tasks folder of a rails project.
# Raises if it cannot find ./lib/tasks
# <tt>install_type</tt> Defaults to rails.
def install_rake_tasks(install_type = 'rails')
  if install_type == 'rails'
    require 'ftools'
    if File.directory?('./lib/tasks/')
      File.copy(File.dirname(__FILE__) + '/../tasks/request_log_analyzer.rake', './lib/tasks/request_log_analyze.rake')
      puts "Installed rake tasks."
      puts "To use, run: rake log:analyze"
    else
      puts "Cannot find /lib/tasks folder. Are you in your Rails directory?"
      puts "Installation aborted."
    end
  else
    raise "Cannot perform this install type! (#{install_type})"
  end
end

