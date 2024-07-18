import urequests

def getRequest(url, timeout=10,params={}):
    """
    Perform a GET request to the specified URL.

    Args:
        url (str): The URL to send the GET request to.
        timeout (int): The timeout in seconds for the request, by default 10 seconds.
    Returns:
        dict: A dictionary containing the following keys:
            - status (int): The HTTP status code of the response.
            - body (str or None): The body of the response as a string, or None if the request failed.
            - headers (dict or None): The headers of the response, or None if the request failed.
            - json (dict or None): The JSON content of the response, or None if the request failed or the response is not JSON.
    """
    
    if not url:
        print("URL is empty")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    elif not url.startswith("http"):
        print("Invalid URL")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    elif timeout <= 0:
        print("Invalid timeout value")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    else:
        try:
            
            if params is None:
                params = {}
    
            # Construye la cadena de parámetros de consulta
            query_string = '&'.join([f'{k}={v}' for k, v in params.items()])
            full_url = f"{url}?{query_string}"
            
            print(full_url)
            response = urequests.get(full_url ,timeout=timeout)

            if response.status_code == 200:
                
                result = {"status": response.status_code, "body": response.text, "headers": response.headers, "json": response.json()}
            else:
                print("Failed to retrieve data, status code:", response.status_code)
                result = {"status": response.status_code, "body": None, "headers": None, "json": None}
            
            response.close()
            return result
        except Exception as e:
            print("An error occurred:", e)
            return {"status": response.status_code, "body": None, "headers": None, "json": None}
        finally:
            response.close()


def postRequest(url, timeout=10,params={},data={}):
    """
    Perform a POST request to the specified URL.

    Args:
        url (str): The URL to send the GET request to.
        timeout (int): The timeout in seconds for the request, by default 10 seconds.
        params(dict): The params that may be needed to complete the request
        data(dict): The data that might be send to with the post request
    Returns:
        dict: A dictionary containing the following keys:
            - status (int): The HTTP status code of the response.
            - body (str or None): The body of the response as a string, or None if the request failed.
            - headers (dict or None): The headers of the response, or None if the request failed.
            - json (dict or None): The JSON content of the response, or None if the request failed or the response is not JSON.
    """
    
    if not url:
        print("URL is empty")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    elif not url.startswith("http"):
        print("Invalid URL")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    elif timeout <= 0:
        print("Invalid timeout value")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    else:
        try:
            
            if params is None:
                params = {}

            # Construye la cadena de parámetros de consulta
            query_string = '&'.join([f'{k}={v}' for k, v in params.items()])
            full_url = f"{url}?{query_string}"
            
            print(full_url)
            response = urequests.post(full_url ,timeout=timeout,json=data)

            if response.status_code == 200:
                
                result = {"status": response.status_code, "body": response.text, "headers": response.headers, "json": response.json()}
            else:
                print("Failed to retrieve data, status code:", response.status_code)
                result = {"status": response.status_code, "body": None, "headers": None, "json": None}
            
            response.close()
            return result
        except Exception as e:
            print("An error occurred:", e)
            return {"status": response.status_code, "body": None, "headers": None, "json": None}
        finally:
            response.close()

def patchRequest(url, timeout=10,params={},data={}):
    """
    Perform a PATCH request to the specified URL.

    Args:
        url (str): The URL to send the GET request to.
        timeout (int): The timeout in seconds for the request, by default 10 seconds.
        params(dict): The params that may be needed to complete the request
        data(dict): The data that might be send to with the post request
    Returns:
        dict: A dictionary containing the following keys:
            - status (int): The HTTP status code of the response.
            - body (str or None): The body of the response as a string, or None if the request failed.
            - headers (dict or None): The headers of the response, or None if the request failed.
            - json (dict or None): The JSON content of the response, or None if the request failed or the response is not JSON.
    """
    
    if not url:
        print("URL is empty")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    elif not url.startswith("http"):
        print("Invalid URL")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    elif timeout <= 0:
        print("Invalid timeout value")
        return {"status": response.status_code, "body": None, "headers": None, "json": None}
    else:
        try:
            
            if params is None:
                params = {}

            # Construye la cadena de parámetros de consulta
            query_string = '&'.join([f'{k}={v}' for k, v in params.items()])
            full_url = f"{url}?{query_string}"
            
            print(full_url)
            response = urequests.patch(full_url ,timeout=timeout,json=data)

            if response.status_code == 200:
                
                result = {"status": response.status_code, "body": response.text, "headers": response.headers, "json": response.json()}
            else:
                print("Failed to retrieve data, status code:", response.status_code)
                result = {"status": response.status_code, "body": None, "headers": None, "json": None}
            
            response.close()
            return result
        except Exception as e:
            print("An error occurred:", e)
            return {"status": response.status_code, "body": None, "headers": None, "json": None}
        finally:
            response.close()

