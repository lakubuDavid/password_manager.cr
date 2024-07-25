source := "src/main.cr"
output := "build/passman"

default:
    echo 'Hello, world!'

run +command="" :
    crystal run {{source}} -- {{command}}

debug +command="" :
    crystal run --error-trace {{source}} -- {{command}}

build: 
	crystal build {{source}} -o {{output}}
