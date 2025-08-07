*** Settings ***
Suite Setup    Setup Session
Library        Collections
Library        RequestsLibrary
Library        DateTime

*** Variables ***
${base_url}                 https://reqres.in
${USERS}                    ${base_url}/api/users?page=2
${SINGLE USER}              ${base_url}/api/users/2
${SINGLE USER NOT FOUND}    ${base_url}/api/users/23
${CREATE}                   ${base_url}/api/users
${REGISTER}                 ${base_url}/api/register
${LOGIN}                    ${base_url}/api/login
${DELAY}                    ${base_url}/api/users?delay=3
${KEY}                      reqres-free-v1         

*** Keywords ***
Setup Session
    ${headers}=    create dictionary    x-api-key=${KEY}    Content-Type=application/json
    create session    session1    ${base_url}    headers=${headers}


*** Test Cases ***
Testing for reqres website
    Log    hello world

List Users
    ${response}=  get request  session1  ${USERS} 
    log to console  ${response.status_code}
    # log to console  ${response.content}
    # log to console  ${response.headers}

    #kind of assertion
    ${STATUS_CODE}=  convert to string   ${response.status_code}
    should be equal  ${STATUS_CODE}  200

    ${CONTENT}=  convert to string  ${response.text}
    should contain  ${CONTENT}  Lindsay

    ${header}=    get from dictionary    ${response.headers}    Content-Type
    should be equal  ${header}  application/json; charset=utf-8

    ${json}=    set variable    ${response.json()}
    ${id}=    get from dictionary    ${json['data'][0]}    id
    should be equal as integers    ${id}    7



Single User
    ${response}=     get on session    session1    ${SINGLE USER}
    log to console   ${response.status_code}
    # log to console  ${response.content}

    ${STATUS_CODE}=    convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    200

    ${json}=    set variable  ${response.json()}
    ${idd}=    get from dictionary    ${json['data']}  id
    should be equal as integers    ${idd}    2


Single User Not FOUND
    ${response}=    get on session    session1    ${SINGLE USER NOT FOUND}      expected_status=any
    log to console    ${response.status_code}
    # log to console    ${response.content}

    ${status_code}=    convert to string     ${response.status_code}
    should be equal    ${status_code}    404

Create
    ${body}=    Create Dictionary    name=Hannah    job=Architect

    ${response}=    post on session    session1    ${CREATE}    json=${body}     
    
    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=    convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    201
    ${res_body}=    convert to string    ${response.text}
    should contain    ${res_body}   createdAt

Update Put
    ${body}=    Create Dictionary    name=Josh  
    ${response}=    put on session    session1    ${SINGLE USER}    json=${body}

    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=    convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    200

    ${response_body}=    convert to string    ${response.text}
    should contain    ${response_body}    updatedAt

Update Patch
    ${body}    Create Dictionary    name=Jenny    job=Architect
    ${response}=    patch on session    session1    ${SINGLE USER}    json=${body}

    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=    convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    200

    ${response_body}=    convert to string    ${response.text}
    should contain    ${response_body}    updatedAt

Delete
    ${response}=    delete on session    session1    ${SINGLE USER}
    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=    convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    204

Registration Successful
    ${body}=     Create Dictionary    email=eve.holt@reqres.in    password=pistol
    ${response}=    post on session    session1    ${REGISTER}     json=${body}

    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=     convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    200

    ${response_body}=    set variable   ${response.json()}
    dictionary should contain key    ${response_body}    id
    dictionary should contain key    ${response_body}    token

Registration Unsuccessful
    ${body}=    Create Dictionary    email=sydney@fife
    ${response}=    post on session    session1   ${REGISTER}     json=${body}    expected_status=any
    
    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=     convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    400

    ${response_body}=    set variable    ${response.json()}
    dictionary should contain key    ${response_body}    error
    # dictionary should contain value    ${response_body}    Missing password

Login Successful
    ${body}=    Create Dictionary    email=eve.holt@reqres.in    password=cityslicka
    ${response}=    post on session    session1    ${LOGIN}    json=${body}    

    log to console    ${response.status_code}
    #log to console    ${response.text}

    ${STATUS_CODE}=     convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    200

    ${resp_body}=    set variable    ${response.json()}
    dictionary should contain key    ${resp_body}    token

Login Un-Successful
    ${body}=    Create Dictionary    password=peter@klaven    
    ${response}=    post on session    session1    ${LOGIN}    json=${body}    expected_status=any

    log to console    ${response.status_code}
    # log to console    ${response.text}

    ${STATUS_CODE}=     convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    400

    ${resp_body}=    set variable    ${response.json()}
    dictionary should contain key    ${resp_body}    error
    dictionary should contain value    ${resp_body}    Missing email or username

Delay    
    ${before}=    get time    epoch
    ${response}=    get on session    session1    ${DELAY} 
    ${after}=    get time    epoch
    ${delay}=    evaluate    ${after}-${before}
    log to console    ${response.status_code}
    log to console    ${delay}
    log to console    ${before}
    log to console    ${after}

    # log to console    ${response.text}

    ${STATUS_CODE}=     convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    200

    should be true    ${delay} >= 3













    