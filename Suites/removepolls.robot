*** Settings ***
Resource            ../Resources/vibecatch.resource

Test Setup          Open And Login VibeCheck
Test Teardown       Close Browser


*** Test Cases ***
Removing Polls VibeCheck
    [Documentation]    Test case removes all polls in the project row
    [Tags]    remove
    Remove Polls

Remove Specific Poll By Name
    [Documentation]    Test case removes specific poll by name.
    [Tags]    remove
    Remove Single Poll By Name    360 Poll 83462942    DESTROY    120s
