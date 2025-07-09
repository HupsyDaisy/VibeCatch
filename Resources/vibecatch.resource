*** Settings ***
Library          String
Library          Browser
Variables        locators.py

*** Variables ***
${URL}            https://env-5369504.paas.datacenter.fi/
${USERNAME}       jutta.rautio@brightstraining.com
${PASSWORD}       Vibecheck1!
${STATUS}         ${TRUE}
@{QUESTIONS}      I like my job\n     I like my colleagues\n    
...    Amount of work is reasonable\n    My opinion is valued\n


*** Keywords ***
Open VibeCheck
    [Documentation]    Open website with given url
    [Arguments]    ${browser}=chromium    ${headless}=${false}     
    New Browser    browser=${Browser}     headless=${Headless}
    New Page    ${URL}

Login
    [Documentation]    Login to website 
    [Arguments]  ${username}     ${password}    
    Click        ${LOGIN_BUTTON}  
    Type Text    ${USERNAME_FIELD}    ${username}
    Type Text    ${PASSWORD_FIELD}   ${password}
    Click        ${LOGIN_BUTTON2}

Login And Return Status
    [Documentation]    Login to website and return status if login was successful or fail if given element state found
    [Arguments]  ${username}     ${password}    
    Login        ${username}     ${password}   
    TRY
        Wait For Elements State        ${LOG_OUT_ELEMENT}     timeout=10
        VAR    ${status}    ${TRUE}
    EXCEPT    TimeoutError*    type=GLOB
        VAR    ${status}    ${FALSE}
    END
    RETURN    ${status}
  
Login Test
    [Documentation]    Compares given status to expected result indicates if login failed or successful
    [Arguments]    ${username}    ${password}    ${expected_result}
    ${status}    Login And Return Status    ${username}    ${password}
    Should Be Equal    ${status}    ${expected_result}

Create QWL Poll 
    [Documentation]    Generates new Default QWL Poll with random name automatically and saves it. 
    [Arguments]    ${type}=complete    ${organization_type}=traditional
    ...    ${hide_vector_graphs}=${TRUE}    ${number_of_questions}=All
    Click                      ${ADD_NEW_PROJECT}
    ${random_string}=     Generate Random String        5        [LOWER]
    Type Text                  ${ADD_PROJECT_NAME}      QWL Poll ${random_string}
    Click                      ${CREATE_QWL_POLL_BUTTON}
    Select Options By          ${QWL_TYPE_OPTIONS}    value    ${type}
    Select Options By          ${ORGANIZATION_TYPE_OPTIONS}    label    ${organization_type}
    IF     ${hide_vector_graphs}
        Check Checkbox           ${HIDE_VECTOR_GRAPHS_CHECKBOX}
    ELSE
        Uncheck Checkbox         ${HIDE_VECTOR_GRAPHS_CHECKBOX}
    END
    Click                       //button[contains(text(),"${number_of_questions}")]
    Click                      //a[@id="save" and contains(text(), "Save changes")]
    RETURN                      QWL Poll ${random_string}

Verify Poll Created 
    [Documentation]    Verify that poll is created
    [Arguments]       ${pollname}
    Go To             ${URL}
    Wait For Elements State    //*[contains(text(), "${pollname}")]

Create Custom Poll
    [Documentation]    Generates new Custom Poll with own questions and saves it. 
    Click                      ${ADD_NEW_PROJECT}
    ${random_string}=     Generate Random String        5        [LOWER]
    Type Text                  ${ADD_PROJECT_NAME}       Custom Poll ${random_string}
    Click                      ${CREATE_CUSTOM_POLL_BUTTON}
    Sleep    5                #this should be changed later better
    Click                      ${ADD_QUESTIONS_BUTTON}
    FOR    ${question}    IN     @{QUESTIONS}
        Type Text                  ${TYPE_QUESTIONS_FIELD}    ${question}    clear=False
        Sleep     1            #don't work without
    END
    Click                       ${ADD_QUESTIONS_BUTTON2}
    RETURN                      Custom Poll ${random_string}

Remove Polls
    [Documentation]    This removes all the polls that are created
    ...                Waits added so polls can be removed even when page is slowly working
    Login To VibeCatch                            ${USERNAME}    ${PASSWORD}
    Wait For Elements State                       ${PROJECT_LIST_ROW} >> nth=0    visible    timeout=120s
    WHILE    ${True}
        Wait For Elements State                   ${PROJECT_ROW_SETTINGS_BUTTON} >> nth=0    visible    timeout=120s
        Click                                     ${PROJECT_ROW_SETTINGS_BUTTON} >> nth=0
        Wait For Elements State                   ${REMOVE_POLL_BUTTON}    visible    timeout=120s
        Click                                     ${REMOVE_POLL_BUTTON}
        Wait For Elements State                   ${REMOVE_POLL_BUTTON_SECOND}    visible    timeout=120s
        Click                                     ${REMOVE_POLL_BUTTON_SECOND}
        Wait For Elements State                   ${REMOVE_POLL_BUTTON_THIRD}    visible    timeout=120s
        Click                                     ${REMOVE_POLL_BUTTON_THIRD}
        Type Text                                 ${REMOVE_POLL_TEXT_INPUT}    DESTROY
        Wait For Elements State                   ${REMOVE_POLL_BUTTON_FINAL}    visible    timeout=120s
        Click                                     ${REMOVE_POLL_BUTTON_FINAL}
        Wait For Elements State                   ${CREATE_NEW_POLL_BUTTON} >> nth=0    visible    timeout=120s
        ${count}=   Browser.Get Element Count     ${PROJECT_LIST_ROW}
        IF    ${count} == 0                       BREAK
    END