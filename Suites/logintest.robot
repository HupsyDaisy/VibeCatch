*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Template    Login Test
Test Setup       Open VibeCheck
Test Teardown    Close Browser

*** Test Cases ***
Login With Correct Credentials     ${username}    ${password}    ${TRUE}
    [Documentation]    Login with correct credentials
    [Tags]    smoke

Login With Wrong Username          Käyttäjä       ${password}    ${FALSE}
    [Documentation]    Login with incorrect username
    [Tags]    smoke

Login With Wrong Password          ${username}    Salasana       ${FALSE}
    [Documentation]    Login with incorrect password
    [Tags]    smoke