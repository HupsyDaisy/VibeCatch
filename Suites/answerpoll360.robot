*** Settings ***
Resource            ../Resources/vibecatch.resource

Test Setup          Open And Login VibeCheck
Test Teardown       Close Browser

Test Tags           poll


*** Test Cases ***
Answer 360 Poll
    [Documentation]    Fill a 360 Poll with answers from a CSV mapping {question, answer}.
    Fill 360 Poll    360 Poll
