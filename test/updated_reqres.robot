*** Settings ***
Suite Setup    Session Setup
Library        Collections
Library        DateTime
Library        RequestsLibrary

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
${Username}                 eve.holt@reqres.in
${Username1}                sydney@fife
${PASSWORD}                 pistol

*** Keywords ***
Session Setup
    ${headers}=    create dictionary    x-api-key=${KEY}    Content-Type=application/json
    create session    session1    ${base_url}     headers=${headers}

Status Code Should be
    [Arguments]    ${response}    ${expected}
    ${STATUS_CODE}=    convert to string    ${response.status_code}
    should be equal    ${STATUS_CODE}    ${expected}
    log to console  ${response.status_code}

Content Should be
    [Arguments]    ${response}    ${expected}
    ${CONTENT}=  convert to string  ${response.text}
    should contain  ${CONTENT}      ${expected}

Header Should be
    [Arguments]    ${response}    ${expected}
    ${headers}=    get from dictionary    ${response.headers}    Content-Type
    should be equal    ${headers}    ${expected}

User Registration Should Succeed
    [Arguments]    ${email}    ${password}
    ${body}=    create dictionary    email=${email}    password=${password}
    ${response}=    post on session    session1    ${REGISTER}    json=${body}
    Status Code Should be     ${response}    200
    ${response_body}=    set variable    ${response.json()}
    dictionary should contain key    ${response_body}    id
    dictionary should contain key    ${response_body}    token

User Registration Should Not Succeed
    [Arguments]    ${email}    
    ${body}=    create dictionary    email=${email}    
    ${response}=    post on session    session1    ${REGISTER}    json=${body}    expected_status=any
    Status Code Should be     ${response}    400
    ${response_body}=    set variable    ${response.json()}
    dictionary should contain key    ${response_body}    error

User Login Should Succeed
    [Arguments]    ${email}    ${password}
    ${body}=    create dictionary    email=${email}    password=${password}
    ${response}=    post on session    session1    ${LOGIN}    json=${body}
    Status Code Should Be    ${response}    200
    ${response_body}=    set variable    ${response.json()}
    dictionary should contain key    ${response_body}    token

User Login Should Not Succeed
    [Arguments]    ${email}   
    ${body}=    create dictionary    email=${email}    
    ${response}=    post on session    session1    ${LOGIN}    json=${body}    expected_status=any
    Status Code Should Be    ${response}    400
    ${response_body}=    set variable    ${response.json()}
    dictionary should contain key    ${response_body}    error
    #log to console    ${response_body}
    # dictionary should contain value    ${response_body}   Missing password
    


*** Test Cases ***
Testing for reqres website
    Log    hello world

List Users   
    ${response}=             get on session    session1    ${USERS}
    Status Code Should be    ${response}    200
    Content Should be        ${response}    Lindsay
    Header Should be         ${response}    application/json; charset=utf-8

    ${json}=    set variable    ${response.json()}
    ${idd}=    get from dictionary    ${json['data'][0]}    id
    should be equal as integers    ${idd}    7

Single User
    ${response}=    get on session    session1    ${SINGLE USER}
    Status Code Should be    ${response}    200
    ${json}=     set variable    ${response.json()}
    ${id}=       get from dictionary    ${json['data']}    id
    should be equal as integers    ${id}    2

Single User Not FOUND
    ${response}=    get on session    session1    ${SINGLE USER NOT FOUND}      expected_status=any
    Status Code Should be    ${response}    404

Create
    ${body}=    Create Dictionary    name=Hannah    job=Architect
    ${response}=    post on session    session1    ${CREATE}    json=${body}
    Status Code Should be     ${response}    201
    Content Should be         ${response}   createdAt

Update Put
    ${body}=    Create Dictionary    name=Josh  
    ${response}=    put on session    session1    ${SINGLE USER}    json=${body}
    Status Code Should be     ${response}    200
    Content Should be         ${response}   updatedAt

Update Patch
    ${body}    Create Dictionary    name=Jenny    job=Architect
    ${response}=    patch on session    session1    ${SINGLE USER}    json=${body}
    Status Code Should be     ${response}    200
    Content Should be         ${response}   updatedAt

Delete
    ${response}=    delete on session    session1    ${SINGLE USER}
    Status Code Should be     ${response}    204
    
Registration Successful
    User Registration Should Succeed    ${Username}    ${PASSWORD}

Registration Un-Successful
    User Registration Should Not Succeed    ${Username1}

Login Successful
    User Login Should Succeed    ${Username}    ${PASSWORD}

Login Unsuccessful
    User Login Should Not Succeed        ${Username1}
    User Login Should Not Succeed        josh@kflab
    

Delay    
    ${before}=    get time    epoch
    ${response}=    get on session    session1    ${DELAY} 
    ${after}=    get time    epoch
    ${delay}=    evaluate    ${after}-${before}
    Status Code Should be     ${response}    200
    should be true    ${delay} >= 3

    log to console    ${delay}
    log to console    ${before}
    log to console    ${after}


