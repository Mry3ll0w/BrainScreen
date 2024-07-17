

def get_example(url):
    import urequests
    
    if not url:
        print("URL is empty")
        #return {"status": None, text: None}
    else:
        response = urequests.get(url)

        if response.status_code == 200:
            print("Response:", response.text)
            #return {"status": response.status_code, text: response.text}
        else:
            print("Failed to retrieve data, status code:", response.status_code)
    
    response.close()