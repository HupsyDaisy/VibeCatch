*** Settings ***
Documentation       Creates QWL Poll
Resource            ../Resources/vibecatch.resource

Suite Setup         Open And Login VibeCheck
Suite Teardown      Close Browser
Test Template       Create And Verify QWL Poll

Test Tags           poll    smoke


*** Test Cases ***
QWL Poll Case 1    [Documentation]    Test case creates new QWL Poll and verifies it
    QWL Poll    5    [LOWER]    complete    traditional    True    All
QWL Poll Case 2    [Documentation]    Test case creates new QWL Poll and verifies it
    QWL Poll    6    [UPPER]    streamlined    self-governing    False    3
QWL Poll Case 3    [Documentation]    Test case creates new QWL Poll and verifies it
    QWL Poll    7    [NUMBERS]    complete    self-governing    True    15
