import requests
import json
import jsonpath
import time

headers = {
        "Content-Type": "application/json",
        "x-api-key": "reqres-free-v1"
    }

def test_List_Users():
    user_URL = "https://reqres.in/api/users?page=2"
    response = requests.get(user_URL, headers=headers)

    assert response.status_code == 200
    data = response.json()["data"]
    assert data[0]["id"] == 7
    assert response.headers["Content-Type"] == "application/json; charset=utf-8"
    print("\n",response.status_code)
    # print("User Response: ", response.json())

def test_Single_User():
    single_URL = "https://reqres.in/api/users/2"
    response = requests.get(single_URL, headers=headers)
    
    assert response.status_code == 200
    assert response.json()['data']["id"] == 2
    assert len(response.json()['data'])  == 5
    
    print("\n",response.status_code)
    # print("Single User Response: ", response.json())

def test_Single_User_Not_Found():
    url = "https://reqres.in/api/users/23"
    response = requests.get(url, headers=headers)
    assert response.status_code == 404
    print("\n",response.status_code)
    # print("Single Non existing User's Response: ", response.json())



def test_Create():
    Base_URL = "https://reqres.in/api/users"
    f = open("/Users/mypc/Desktop/test suite/request.json", 'r')
    #print(f)
    request_json = json.load(f)
    #print(request_json)
    
    response = requests.post(Base_URL, json=request_json, headers=headers)
    id = jsonpath.jsonpath(response.json(), 'id')
    


    print("\n",response.status_code)
    assert response.status_code == 201
    # print("Id for newly created user: ", id[0])
    # print("Id for newly created user: ", id1)
    # print("\n The response received for creation is: \n", response.text)
    
def test_Update_Patch():
    update_URL = "https://reqres.in/api/users/2"
    temp = open("/Users/mypc/Desktop/test suite/request_patch_update.json","r")
    request_json = json.load(temp)
    response = requests.patch(update_URL,json=request_json, headers=headers)

    assert response.status_code == 200
    print("\n", response.status_code)
    # print("\n Update response (PATCH): \n", response.text)



def test_Update_Put():
    update_URL = "https://reqres.in/api/users/2"
    temp = open("/Users/mypc/Desktop/test suite/request_updated.json",'r')
    request_json = json.load(temp)
    response = requests.put(update_URL,json=request_json, headers=headers)

    assert response.status_code == 200
    print("\n", response.status_code)
    # print("\n Update response (PUT): \n", response.text)

def test_Delete():
    del_url = "https://reqres.in/api/users/2"
    response = requests.delete(del_url, headers=headers)
    
    assert response.status_code == 204
    print("\n", response.status_code)
    # print("\n Delete response : \n", response)
    
def test_Registration_Successful():
    r_url = "https://reqres.in/api/register"
    obj = open("request_reg_success.json","r")
    request_json = json.load(obj)
    response = requests.post(r_url, json=request_json, headers=headers)

    assert response.status_code == 200
    print("\n", response.status_code)
    # print("\n Reg Successful response : \n", response.text)

def test_Reg_Unsuccessful():
    u_url = "https://reqres.in/api/register"
    object = open("/Users/mypc/Desktop/test suite/request_reg_unsuccessful.json","r")
    request_json = json.load(object)
    response = requests.post(u_url, json=request_json, headers=headers)

    assert response.status_code == 400
    print("\n", response.status_code)
    # print("\n Reg Un-Successful response : \n", response.text)

def test_Login_Successful():
    l_url = "https://reqres.in/api/login"
    object = open("/Users/mypc/Desktop/test suite/request_reg_success.json","r")
    request_json = json.load(object)
    response = requests.post(l_url, json=request_json, headers=headers)

    assert response.status_code == 200
    print("\n", response.status_code)
    # print("\n Successful Login Response: \n", response.text)

def test_Login_Unsuccessful():
    lu_url = "https://reqres.in/api/login"
    object = open("/Users/mypc/Desktop/test suite/request_reg_unsuccessful.json","r")
    request_json = json.load(object)
    response = requests.post(lu_url, json=request_json, headers=headers)

    assert response.status_code == 400
    print("\n", response.status_code)
    # print("\n Un-Successful Login Response: \n", response.text)

def test_Delayed():
    delayed_URL = "https://reqres.in/api/users?delay=3"
    start = time.time()
    response = requests.get(delayed_URL, headers=headers)
    end = time.time()
    delay = end - start

    assert response.status_code == 200
    assert delay >= 3
    print("\n", response.status_code)
    # print("\n Delayed Response: \n", response.text)


# if __name__ == "__main__":
#     test_Create()
