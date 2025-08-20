*** Settings ***
Resource         ../Resources/vibecatch.resource
Suite Setup       Open And Login VibeCheck
Suite Teardown    Close Browser
Test Template    Create And Verify 360 Poll

*** Test Cases ***

360 Poll Case 1        360 Poll    5    [LOWER]     7     3    12
    [Documentation]    Log in and creates 360 Poll with parametric name and chosen index inbetween 3-12
    [Tags]    Poll

360 Poll Case 2        360 Poll    7    [UPPER]     RANDOM     3    12
    [Documentation]    Log in and creates 360 Poll with parametric name and random index inbetween 3-12
    [Tags]    Poll

360 Poll Case 3        360 Poll    8    [NUMBERS]     2     3    12
    [Documentation]    Log in and creates 360 Poll with parametric name and chosen index inbetween 3-12
    [Tags]    Poll