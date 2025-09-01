*** Settings ***
Documentation       Tests website's accessability standards
Library             SeleniumLibrary
Library             AxeLibrary
Resource            ../Resources/common_var.resource


*** Test Cases ***
Test Accessibility
    [Documentation]    Testing if website meets accessability standards
    [Setup]    Open Browser    ${URL}    chrome
    &{results}=    Run Accessibility Tests    vibecatch.json
    Log    Violations Count: ${results.violations}
    Log Readable Accessibility Result    violations
    [Teardown]    Close Browser
