

def getRequest(url):
    import urequests
    
    if not url:
        print("URL is empty")
        return {"status_code": None, "response_text": None}
    else:
        try:
            response = urequests.get(url)

            if response.status_code == 200:
                
                result = {"status_code": response.status_code, "response_text": response.text}
            else:
                print("Failed to retrieve data, status code:", response.status_code)
                result = {"status_code": response.status_code, "response_text": None}
            
            response.close()
            return result
        except Exception as e:
            print("An error occurred:", e)
            return {"status_code": None, "response_text": None}