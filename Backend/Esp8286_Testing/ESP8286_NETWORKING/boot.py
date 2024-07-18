# This is script that run when device boot up or wake from sleep.
import network
from env import WIFI_PASSWORD, WIFI_SSID
import urequests

sta_if = network.WLAN(network.STA_IF) # Create object to connecto to wifi

sta_if.active(True) # Activate wlan interface

# Checking if wifi is active and wifi variables are set
if not WIFI_SSID or not WIFI_PASSWORD:
    print('Wifi variables are not set')  
elif not sta_if.isconnected():
    print('connecting to network...')
    sta_if.connect(WIFI_SSID, WIFI_PASSWORD)
    while not sta_if.isconnected():
        print("...")
        pass
    print('network config:', sta_if.ifconfig())
global bConnectionStablished
bConnectionStablished = sta_if.isconnected()
    
print("Probando request en boot.py")
# Intenta hacer una solicitud GET simple aquí para verificar la conexión
try:
    response = urequests.get('http://example.com')
    print("Response value:", response.text)
except Exception as e:
    print(e)


