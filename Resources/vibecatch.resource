*** Settings ***
Library          String
Library          Browser
Library          ../Libs/CustomLibrary.py
Variables        locators.py
Variables        env_vars.py

*** Variables ***
${URL}            https://env-5369504.paas.datacenter.fi/
${STATUS}         ${TRUE}
@{QUESTIONS}      I like my job\n     I like my colleagues\n    
...    Amount of work is reasonable\n    My opinion is valued\n
${NAME_POLL}    QWL Poll
${NAME_360_POLL}    360Poll

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
    Fill Text    ${USERNAME_FIELD}    ${username}
    Fill Text    ${PASSWORD_FIELD}   ${password}
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
    Sleep    10
    Wait For Elements State    //*[contains(text(), "${pollname}")]    visible    timeout=120s

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

Create 360 Poll 
    [Documentation]    Generates new 360 Poll with random name automatically and adds one random question.        
    Click                      ${ADD_NEW_PROJECT}
    ${random_string}=     Generate Random String        5        [LOWER]
    Type Text                  ${ADD_PROJECT_NAME}      360Poll ${random_string}
    Click                      ${CREATE_360_POLL_BUTTON}
    Wait For Elements State    ${ADD_QUESTION_BUTTON}    visible    timeout=20s
    VAR    ${status}    ${False}
    WHILE    not ${status}    limit=5
        Click                  ${ADD_QUESTION_BUTTON} 
        ${status}    Run Keyword And Return Status    Wait For Elements State    ${SELECT_NEW_QUESTION}    visible    timeout=3
    END
    Sleep    2
    Wait For Elements State    ${SELECT_NEW_QUESTION}    visible    timeout=30s
    Click                      ${SELECT_NEW_QUESTION} 
    ${random_index}    Get Random Index Answer
    Select Options By           ${SELECT_NEW_QUESTION}    index      ${random_index}     
    Click                       ${CLICK_FIRST_CHOICE}
    Click                       ${ADD_SELECTED_QUESTION}   
    RETURN    360Poll ${random_string}

Fill 360 Poll
    [Documentation]    Fill 360 Poll with given answers in Poll_answers.csv
    [Arguments]    
    Click    //div[contains(@class,"projectRow")][div/span/a[contains(text(),"${NAME_360_POLL}")]]//a[@mattooltip="View poll form"]
    Sleep    5
    Switch Page    NEW
    ${firstname}    Get Random First Name
    Type Text    ${ENTER_NAME_POLL_ANSWER}    ${firstname}
    ${email}    Get Email    ${firstname}
    Type Text    ${ENTER_EMAIL_POLL_ANSWER}    ${email}
    Click        ${NEXT_BUTTON_FEEDBACK}
    Sleep    5
    ${visible_elements}    Get Element Count    ${NEXT_PAGE_BUTTON_QWL_POLL} 
    ${poll_data}=    Read Poll Data    ${CURDIR}/../Libs/Poll_answers.csv
    Log    ${poll_data}
    VAR    ${i}    0
    WHILE    True    
        ${current_question}    Get Text    //h3 >> nth=${i}
        ${row}    Evaluate    next(d for d in ${poll_data} if d["question"] == "${current_question}")
        Log    ${row}
        ${answer}=      Set Variable    ${row['answer']}
        Click    xpath=//a/span[contains(text(), "${answer}")] >> nth=${i}
        Sleep    1
        ${i}     Evaluate    ${i} + 1
        ${visible_elements}    Get Element Count    ${SEND_FEEDBACK_BUTTON}
        IF    ${visible_elements} >= 1
            Click    ${SEND_FEEDBACK_BUTTON}
            BREAK
        ELSE
            Click    ${NEXT_PAGE_BUTTON_QWL_POLL}
        END
    END                                                        
    #Verify that poll is answered
    Sleep    3
    Wait For Elements State         ${CONTAINS_EVALUATION_REPORT}     timeout=10

Remove Polls
    [Documentation]    This removes all the polls that are created
    ...                Waits added so polls can be removed even when page is slowly working
    Login                                         ${USERNAME}    ${PASSWORD}
    Wait For Elements State                       ${PROJECT_ROW} >> nth=0    
    WHILE    ${True}
        Wait For Elements State                   ${CHANGE_POLL_SETTINGS}      visible    timeout=3s
        Click                                     ${CHANGE_POLL_SETTINGS}    
        Wait For Elements State                   ${DELETE_POLL_BUTTON}    visible    timeout=120s
        Click                                     ${DELETE_POLL_BUTTON}
        Wait For Elements State                   ${DELETE_PROJECT_BUTTON}    visible    timeout=120s
        Click                                     ${DELETE_PROJECT_BUTTON} 
        Wait For Elements State                   ${DELETE_NOW_POLL_BUTTON}    visible    timeout=120s
        Click                                     ${DELETE_NOW_POLL_BUTTON} 
        Type Text                                 ${TYPE_DESTROY_FIELD}    DESTROY
        Wait For Elements State                   ${VERIFY_REMOVAL_OK_BUTTON}   visible    timeout=120s
        Click                                     ${VERIFY_REMOVAL_OK_BUTTON}
        Wait For Elements State                   ${ADD_NEW_PROJECT} >> nth=0    visible    timeout=120s
        ${count}=   Browser.Get Element Count     ${PROJECT_ROW} 
        IF    ${count} == 0                       BREAK
    END

Fill QWL Poll
    [Documentation]    Fill QWL Poll with random answers
    Click    //div[contains(@class,"projectRow")][div/span/a[contains(text(),"${NAME_POLL}")]]//a[@mattooltip="View poll form"]
    Sleep    5
    Switch Page    NEW
    Click        ${NEXT_BUTTON_FEEDBACK}
    ${visible_elements}    Get Element Count    ${NEXT_PAGE_BUTTON_QWL_POLL}
    WHILE    ${True}
        ${visible_elements}    Get Element Count    ${NEXT_PAGE_BUTTON_QWL_POLL}
        ${random_locator}    Get Random Xpath Answer    
        Click    ${${random_locator}}
        IF    ${visible_elements} >= 1
            Click    ${NEXT_PAGE_BUTTON_QWL_POLL}
        ELSE
            BREAK
        END
    END
    Click                           ${SEND_FEEDBACK_BUTTON}
    Wait For Elements State         ${THANK_YOU_FEEDBACK_MESSAGE}     timeout=10
    