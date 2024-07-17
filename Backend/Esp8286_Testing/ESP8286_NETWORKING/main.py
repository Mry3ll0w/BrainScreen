# This is your main script.
import machine
import time
import boot
from api_testing import get_example

led = machine.Pin(2, machine.Pin.OUT)

print("Connection stablished, start testing API")


while boot.bConnectionStablished:
    response = None
    led.on()
    try:
        print("Comienzo Petición")
        get_example("https://dummyjson.com/c/f6da-c2e4-4394-8c73")
        #response = get_example("https://dummyjson.com/c/f6da-c2e4-4394-8c73")
        #print("Status: ",response["status"])
        #print("Text: ",response["text"])
        #print("Fin Petición")
    finally:
        #print("Response status:", response["status"])
        led.off()