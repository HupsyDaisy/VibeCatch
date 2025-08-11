*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser

*** Test Cases ***
Login And Create 360 Poll
    [Documentation]    Logins and creates 360 Poll with default questionnaire and adds one ramdom question.
    [Tags]    360
    Login And Return Status    ${USERNAME}    ${PASSWORD}    
    Sleep    15
    ${pollname}    Create 360 Poll
    Verify Poll Created    ${pollname}

