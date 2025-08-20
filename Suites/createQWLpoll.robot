*** Settings ***
Resource         ../Resources/vibecatch.resource
Suite Setup       Open And Login VibeCheck
Suite Teardown    Close Browser
Test Template    Create And Verify QWL Poll

*** Test Cases ***
QWL Poll Case 1    QWL Poll    5    [LOWER]        complete        traditional    True    All
    [Documentation]    Test case creates new QWL Poll and verifies it
    [Tags]    Poll

QWL Poll Case 2    QWL Poll    6    [UPPER]        streamlined    self-governing    False    3
    [Documentation]    Test case creates new QWL Poll and verifies it
    [Tags]    Poll

QWL Poll Case 3    QWL Poll    7    [NUMBERS]      complete        self-governing    True       15
    [Documentation]    Test case creates new QWL Poll and verifies it
    [Tags]    Poll