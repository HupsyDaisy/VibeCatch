*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser


*** Test Cases ***
Login And Answer QWL Poll
    [Documentation]    Logins and answers QWL Poll's all questions with same default answer.
    [Tags]    QWL Poll
    Login And Return Status    ${USERNAME}    ${PASSWORD} 
    Sleep    3
    Fill QWL Poll    
