mruby-embeddable
=========

## Description

Run mruby in micro-controllers in an easy way. Support: Arduino Due and others (soon!) 

## Features

* mirb connected to the microcontrollers to rapid development.

## Requires

* Arduino 1.5.4 IDE
* Arduino Due board (An outstanding ARM 32 bit computer with 84MHZ, 96KB RAM and 512KB FLASH)

## Install

```ruby
# it will clone and compile mruby cross compiling to Arduino
ruby make_mruby.rb
# it will compile the Arduino sketch and flash it to the Arduino due board
ruby make_arduino.rb compile USB_PORT
```

## Usage
```ruby
ruby make_arduino.rb connect USB_PORT
```

```shell
Connecting to the board on usb port /dev/cu.usbmodemfa131
mirb-hostbased - Hostbased Interactive mruby Shell
  waiting for target on /dev/cu.usbmodemfa131...
(target):NON SOH r  chipKIT detected. reopening port..
(target):TOTAL_ALLOCATED : 89047
target is ready.
> #file fib.rb
 => :fib
> fib(10)
 => 89
```

## License

```
mruby-embeddable - A mruby utility for embed mruby on micro-controllers.
The MIT License (MIT)

Copyright (c) 2013 Luis Silva

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```