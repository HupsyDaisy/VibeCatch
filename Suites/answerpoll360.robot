*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser

*** Test Cases ***
Login And Answer 360 Poll
    Login And Return Status    ${USERNAME}    ${PASSWORD}    
    Sleep    15
    Fill 360 Poll    

