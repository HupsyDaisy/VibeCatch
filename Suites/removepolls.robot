*** Settings ***
Resource         ../Resources/vibecatch.resource
Test Setup       Open VibeCheck
Test Teardown    Close Browser

*** Test Cases ***
Removing Polls VibeCheck
    [Documentation]    Test case removes all polls in the project row
    Remove Polls


