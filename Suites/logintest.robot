*** Settings ***
Resource            ../Resources/vibecatch.resource

Test Setup          Open VibeCheck
Test Teardown       Close Browser
Test Template       Login Test

Test Tags           smoke


*** Test Cases ***
Login With Correct Credentials    [Documentation]    Login with correct credentials
    ${username}    ${password}    ${TRUE}
Login With Wrong Username    [Documentation]    Login with incorrect username
    Käyttäjä    ${password}    ${FALSE}
Login With Wrong Password    [Documentation]    Login with incorrect password
    ${username}    Salasana    ${FALSE}
