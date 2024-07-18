# This is your main script.
import machine
import time
import boot
from api_testing import getRequest

led = machine.Pin(2, machine.Pin.OUT)

print("Connection stablished, start testing API")


if boot.bConnectionStablished:
    response = None
    led.on()
    try:
        print("Comienzo Petición")
        
        response = getRequest('http://example.com')
        #print("Text: ",response["response_text"])
        print("Fin Petición")
    finally:
        print("Response status:", response["status_code"])
        led.off()