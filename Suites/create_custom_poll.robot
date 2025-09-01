*** Settings ***
Documentation       Creates Custom Poll

Library             ../Libs/CustomLibrary.py
Resource            ../Resources/vibecatch.resource

Suite Setup         Open And Login VibeCheck
Suite Teardown      Close Browser
Test Template       Create And Verify Custom Poll

Test Tags           poll


*** Test Cases ***
Custom Poll Case 1    [Documentation]    Creates a Custom Poll with parametric name and questions.
    Custom Poll    5    [LOWER]    What went well this week?    Any blockers?    Suggestions?
Custom Poll Case 2    [Documentation]    Creates a Custom Poll with parametric name and questions.
    Custom Poll    6    [UPPER]    Highlight of the week?    Improvement idea?
Custom Poll Case 3    [Documentation]    Creates a Custom Poll with parametric name and questions.
    Custom Poll    4    [NUMBERS]    1-10: How do you feel?    Next sprint focus?
