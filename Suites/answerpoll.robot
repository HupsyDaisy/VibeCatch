*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser


*** Test Cases ***
Login And Answer QWL Poll
    [Documentation]    Logins and answers QWL Poll's all questions with same default answer.
    [Tags]    QWL Poll
    Login    ${USERNAME}    ${PASSWORD} 
    Fill QWL Poll    
