#!/usr/bin/env ruby

require 'fileutils'

if ARGV[0] == "connect"
  system "#{File.expand_path("tmp/mruby/bin/mirb-hostbased")} --verbose -p /dev/cu.usbmodemfa131"
  exit
end

puts "Defining the Arduino path"
# Arduino Application Folder
case RUBY_PLATFORM
when /x86_64-darwin/i
  # Mac OS X
  ARDUINO_PATH = '/Applications/Arduino.app/Contents/Resources/Java'
when /darwin/i
  # Mac OS X
  ARDUINO_PATH = "/Applications/Arduino.app/Contents/Resources/Java"
when /x86_64-linux/i
  # GNU Linux
  ARDUINO_PATH = '/opt/arduino'
when /linux/i
  # GNU Linux
  ARDUINO_PATH = '/opt/arduino'
else
  puts "Unsupported host platform"
  exit
end

puts "Patching the Arduino compiler includes"
platform = File.read "#{ARDUINO_PATH}/hardware/arduino/sam/platform.txt"
# lines to edit on the arduino platform.txt file
find1 = "compiler.c.flags=-c -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -Dprintf=iprintf"
find2 = "compiler.cpp.flags=-c -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -Dprintf=iprintf"
find3 = "recipe.c.combine.pattern=\"{compiler.path}{compiler.c.elf.cmd}\" {compiler.c.elf.flags} -mcpu={build.mcu} \"-T{build.variant.path}/{build.ldscript}\" \"-Wl,-Map,{build.path}/{build.project_name}.map\" -o \"{build.path}/{build.project_name}.elf\" \"-L{build.path}\" -lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols -Wl,--start-group \"{build.path}/syscalls_sam3.c.o\" {object_files} \"{build.variant.path}/{build.variant_system_lib}\" \"{build.path}/{archive_file}\" -Wl,--end-group"
# lines with the new content
replace1 = "compiler.c.flags=-c -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -Dprintf=iprintf -I#{File.expand_path("tmp/mruby/include")}"
replace2 = "compiler.cpp.flags=-c -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -Dprintf=iprintf -I#{File.expand_path("tmp/mruby/include")}"
replace3 = "recipe.c.combine.pattern=\"{compiler.path}{compiler.c.elf.cmd}\" {compiler.c.elf.flags} -mcpu={build.mcu} \"-T{build.variant.path}/{build.ldscript}\" \"-Wl,-Map,{build.path}/{build.project_name}.map\" -o \"{build.path}/{build.project_name}.elf\" \"-L{build.path}\" -lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols -Wl,--start-group \"{build.path}/syscalls_sam3.c.o\" {object_files} \"{build.variant.path}/{build.variant_system_lib}\" \"{build.path}/{archive_file}\" -Wl,--end-group  \"-L#{File.expand_path("tmp/mruby/build/Arduino Due/lib")}\" -lmruby"
# replacing the buffer
platform.gsub! find1, replace1
platform.gsub! find2, replace2
platform.gsub! find3, replace3

# making a security copy from the arduino platform.txt file
FileUtils.copy "#{ARDUINO_PATH}/hardware/arduino/sam/platform.txt", "#{ARDUINO_PATH}/hardware/arduino/sam/platform.ori" unless File.exists?("#{ARDUINO_PATH}/hardware/arduino/sam/platform.ori")

# writing the new file
File.open("#{ARDUINO_PATH}/hardware/arduino/sam/platform.txt", "w"){ |f| f.puts platform }

puts "Compiling & Uploading the Arduino binary program"
# compiling the arduino binary and upload
system "open -W -a arduino --args --board arduino:sam:arduino_due_x_dbg --port /dev/cu.usbmodemfa131 --upload #{File.expand_path('tmp/mruby/build/mrbgems/mruby-bin-mirb-hostbased/samples/target/chipKITMax32_ArduinoDue_runner/chipKITMax32_ArduinoDue_runner.pde')}"

puts "Restoring the Arduino compiler includes"
# restore the original platform.txt file
FileUtils.copy "#{ARDUINO_PATH}/hardware/arduino/sam/platform.ori", "#{ARDUINO_PATH}/hardware/arduino/sam/platform.txt"
FileUtils.rm "#{ARDUINO_PATH}/hardware/arduino/sam/platform.ori"

puts "Connecting to the board"
# connect to the board
system "#{File.expand_path("tmp/mruby/bin/mirb-hostbased")} --verbose -p /dev/cu.usbmodemfa131"

