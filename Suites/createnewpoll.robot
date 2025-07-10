*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser


*** Test Cases ***
Login And Create New QWL Poll
    [Documentation]    Test case logins and creates new QWL Poll
    [Tags]    Poll
    Login        ${username}     ${password}  
    ${pollname}    Create QWL Poll     
    Verify Poll Created    ${pollname}

Login And Create New Custom Poll
    [Documentation]    Test case logins and creates new Custom Poll
    [Tags]    Poll
    Login        ${username}     ${password}  
    ${pollname}    Create Custom Poll      
    Verify Poll Created    ${pollname}
