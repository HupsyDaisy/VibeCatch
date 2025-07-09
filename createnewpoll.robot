*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser


*** Test Cases ***
Login And Create New QWL Poll
    Login        ${username}     ${password}  
    ${pollname}    Create QWL Poll     
    Verify Poll Created    ${pollname}

Login And Create New Custom Poll
    Login        ${username}     ${password}  
    ${pollname}    Create Custom Poll      
    Verify Poll Created    ${pollname}
