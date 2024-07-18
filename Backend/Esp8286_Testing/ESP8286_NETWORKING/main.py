# This is your main script.
import machine
import time
import boot
from api_testing import getRequest
from env import SERVER_URL, firebaseUID
led = machine.Pin(2, machine.Pin.OUT)

print("Connection stablished, start testing API")


if boot.bConnectionStablished:
    response = None
    led.on()
    try:
        print("Comienzo Petición")
        
        response = getRequest(SERVER_URL+'test', timeout=10,firebaseUID=firebaseUID)
        print("Body: ",response["body"])
        print("Headers: ",response["headers"])
        print("JSON: ",response["json"])
        print("Fin Petición")
    except Exception as e:
        print("An error occurred:", e)
    finally:
        led.off()