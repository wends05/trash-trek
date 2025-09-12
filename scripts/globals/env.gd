extends Node

var data: Dictionary = {}


func get_data():

  if data.size() > 0:
    return data

  var file = FileAccess.open("res://.env", FileAccess.READ)
  if not file:
    print_debug("Failed to open .env file")
    return
  
  while not file.eof_reached():
    var line = file.get_line()
    if line.begins_with("#"):
      continue
    
    var key_value = line.split("=")
    if key_value.size() != 2:
      continue
    
    var key = key_value[0].strip_edges()
    var value = key_value[1].strip_edges()
    data[key] = value
  file.close()

  return data
