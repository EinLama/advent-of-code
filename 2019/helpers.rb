def filepath(filename)
  File.join(File.dirname(__FILE__), "riddle_inputs", filename)
end

def readlines(filename)
  File.readlines(filepath(filename))
end
