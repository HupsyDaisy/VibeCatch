*** Settings ***
Library          String
Library          Browser
Library         Collections
Library        RequestsLibrary
Library          ../Libs/CustomLibrary.py
Variables        locators.py
Variables        env_vars.py


*** Variables ***
${URL}            https://env-5369504.paas.datacenter.fi/
${STATUS}         ${TRUE}



*** Keywords ***
Open VibeCheck
    [Documentation]    Open website with given url
    [Arguments]    ${browser}=chromium    ${headless}=${false}     
    New Browser    browser=${Browser}     headless=${Headless}
    New Page    ${URL}

Login
    [Documentation]    Login to website 
    [Arguments]  ${username}     ${password}
    Wait For Elements State        ${LOGIN_BUTTON}     timeout=10    
    Click        ${LOGIN_BUTTON}
    Fill Text    ${USERNAME_FIELD}    ${username}
    Fill Text    ${PASSWORD_FIELD}   ${password}
    Click        ${LOGIN_BUTTON2}

Open And Login VibeCheck
    [Documentation]    Open website with given url and logins
    Open VibeCheck
    Login    ${username}     ${password}

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
    [Arguments]    ${project_prefix}=QWL Poll    ${rand_len}=5    ${charset}=[LOWER]    ${type}=complete    ${organization_type}=traditional
    ...    ${hide_vector_graphs}=${TRUE}    ${number_of_questions}=All
    # Build a unique poll name
    ${suffix}=         Generate Random String      ${rand_len}    ${charset}
    ${poll_name}=      Set Variable                ${project_prefix} ${suffix}
    Wait For Elements State        ${ADD_NEW_PROJECT}     timeout=15 
    Click                      ${ADD_NEW_PROJECT}
    Type Text                  ${ADD_PROJECT_NAME}      ${poll_name}
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
    RETURN                      ${poll_name}

Verify Poll Created 
    [Documentation]    Verify that poll is created
    [Arguments]       ${pollname}
    Go To             ${URL}
    Sleep    10
    Wait For Elements State    //*[contains(text(), "${pollname}")]    visible    timeout=120s

Create And Verify QWL Poll
    [Arguments]    ${project_prefix}=QWL Poll    ${rand_len}=5    ${charset}=[LOWER]    ${type}=complete    ${organization_type}=traditional
    ...    ${hide_vector_graphs}=${TRUE}    ${number_of_questions}=All
    ${pollname}=    Create QWL Poll    ${project_prefix}    ${rand_len}    ${charset}   
    Verify Poll Created    ${pollname}

Create Custom Poll
    [Documentation]    Creates a new Custom Poll with a generated name and a list of questions.
    ...                Returns the full poll name so tests can assert on it.
    [Arguments]        ${project_prefix}=Custom Poll    ${rand_len}=5    ${charset}=[LOWER]    @{questions}
    # Build a unique poll name
    ${suffix}=         Generate Random String      ${rand_len}    ${charset}
    ${poll_name}=      Set Variable                ${project_prefix} ${suffix}

    # Create project/poll
    Wait For Elements State    ${ADD_NEW_PROJECT}          visible    timeout=15
    Click                      ${ADD_NEW_PROJECT}
    Wait For Elements State    ${ADD_PROJECT_NAME}         visible    10s
    Type Text                  ${ADD_PROJECT_NAME}         ${poll_name}
    Wait For Elements State    ${CREATE_CUSTOM_POLL_BUTTON}    enabled    10s
    Click                      ${CREATE_CUSTOM_POLL_BUTTON}
    # Add questions
    Wait For Elements State    ${ADD_QUESTIONS_BUTTON}     visible    10s
    Click                      ${ADD_QUESTIONS_BUTTON}
    VAR    ${status}    ${False}
    WHILE    not ${status}    limit=5
        Click                  ${ADD_QUESTIONS_BUTTON} 
        ${status}    Run Keyword And Return Status    Wait For Elements State    ${TYPE_QUESTIONS_FIELD}    visible    timeout=3
    END
    FOR    ${q}    IN    @{questions}
        Wait For Elements State    ${TYPE_QUESTIONS_FIELD}    visible    5s
        Type Text                  ${TYPE_QUESTIONS_FIELD}    ${q}    clear=False
    END
    Wait For Elements State    ${ADD_QUESTIONS_BUTTON2}    enabled    10s
    Click                      ${ADD_QUESTIONS_BUTTON2}
    RETURN                  ${poll_name}

Create And Verify Custom Poll
    [Arguments]    ${project_prefix}    ${rand_len}    ${charset}    @{questions}
    ${pollname}=    Create Custom Poll    ${project_prefix}    ${rand_len}    ${charset}    @{questions}
    Verify Poll Created    ${pollname}

Create 360 Poll 
    [Documentation]    Generates new 360 Poll with random name automatically and adds one random question.
    [Arguments]    ${project_prefix}=360 Poll    ${rand_len}=5    ${charset}=[LOWER]    ${question_index}=RANDOM    ${min_index}=3    ${max_allowed}=12
    ${suffix}=         Generate Random String      ${rand_len}    ${charset}
    ${poll_name}=      Set Variable                ${project_prefix} ${suffix}
    Wait For Elements State    ${ADD_NEW_PROJECT}        visible    timeout=20s      
    Click                      ${ADD_NEW_PROJECT}
    Type Text                  ${ADD_PROJECT_NAME}       ${poll_name}
    Click                      ${CREATE_360_POLL_BUTTON}
    Wait For Elements State    ${ADD_QUESTION_BUTTON}    visible    timeout=20s
    VAR    ${status}    ${False}
    WHILE    not ${status}    limit=5
        Click                  ${ADD_QUESTION_BUTTON} 
        ${status}    Run Keyword And Return Status    Wait For Elements State    ${SELECT_NEW_QUESTION}    visible    timeout=3
    END
    Wait For Elements State    ${SELECT_NEW_QUESTION}    visible    timeout=30s
    Click                      ${SELECT_NEW_QUESTION} 
    IF    '${question_index}' == 'RANDOM' or '${question_index}' == '${EMPTY}'
        ${random_index}=    Get Random Index Answer
    ELSE
        ${random_index}=    Set Variable    ${question_index}
    END
    Select Options By           ${SELECT_NEW_QUESTION}    index      ${random_index}     
    Click                       ${CLICK_FIRST_CHOICE}
    Click                       ${ADD_SELECTED_QUESTION}   
    RETURN    ${poll_name}

Create And Verify 360 Poll
    [Documentation]    Generates new 360 Poll with random name automatically, adds one random question and verifies it. 
    [Arguments]    ${project_prefix}    ${rand_len}    ${charset}    ${question_index}    ${min_index}    ${max_allowed}
    ${pollname}=    Create 360 Poll    ${project_prefix}    ${rand_len}    ${charset}    
    Verify Poll Created    ${pollname}

Fill 360 Poll
    [Documentation]    Fill a 360 Poll with answers from a CSV mapping {question, answer}.
    [Arguments]    ${poll_name}
    Wait For Elements State    //div[contains(@class,"row") and contains(@class,"projectRow")][ .//a[contains(@class,"project-name")][contains(normalize-space(.),"${poll_name}")] ][1]//a[@mattooltip="View poll form"]    visible    20s
    Click    //div[contains(@class,"row") and contains(@class,"projectRow")][ .//a[contains(@class,"project-name")][contains(normalize-space(.),"${poll_name}")] ][1]//a[@mattooltip="View poll form"]
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
    Sleep    10
    Wait For Elements State                       (//div[@class='row projectRow'])[1]      visible    timeout=120s     #${PROJECT_ROW} >> nth=0    
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

Remove Single Poll By Name
    [Documentation]    Opens settings for the given poll name and completes the deletion flow.
    [Arguments]        ${poll_name}    ${destroy_text}=DESTROY    ${wait_timeout}=120s
    Click    //div[contains(@class,"row") and contains(@class,"projectRow")][ .//a[contains(@class,"project-name")][contains(normalize-space(.),"${poll_name}")] ][1]//a[@mattooltip="Change poll's settings"]
    # Deletion dialog flow (reuse your existing variables)
    Wait For Elements State    ${DELETE_POLL_BUTTON}      visible    ${wait_timeout}
    Click                      ${DELETE_POLL_BUTTON}
    Wait For Elements State    ${DELETE_PROJECT_BUTTON}   visible    ${wait_timeout}
    Click                      ${DELETE_PROJECT_BUTTON}
    Wait For Elements State    ${DELETE_NOW_POLL_BUTTON}  visible    ${wait_timeout}
    Click                      ${DELETE_NOW_POLL_BUTTON}
    Type Text                  ${TYPE_DESTROY_FIELD}      ${destroy_text}
    Wait For Elements State    ${VERIFY_REMOVAL_OK_BUTTON}    visible    ${wait_timeout}
    Click                      ${VERIFY_REMOVAL_OK_BUTTON}
    # Ensure the row is gone before proceeding
    Wait For Elements State    ${PROJECT_ROW}     detached    ${wait_timeout}

Fill QWL Poll
    [Documentation]    Fill QWL Poll with random or seeded answers from a chosen pool.
    [Arguments]        ${name_poll}=QWL Poll    ${pool}=ALL    ${seed}=${NONE}     ${fixed_answer}=${NONE}
    Wait For Elements State    //div[contains(@class,"row") and contains(@class,"projectRow")][ .//a[contains(@class,"project-name")][contains(normalize-space(.),"${name_poll}")] ][1]//a[@mattooltip="View poll form"]    visible    10s
    Click     //div[contains(@class,"row") and contains(@class,"projectRow")][ .//a[contains(@class,"project-name")][contains(normalize-space(.),"${name_poll}")] ][1]//a[@mattooltip="View poll form"]  
    Sleep    20    #doesn't work without sleep
    Switch Page    NEW
    Wait For Elements State    ${NEXT_BUTTON_FEEDBACK}    visible    20s
    Click        ${NEXT_BUTTON_FEEDBACK}
    ${visible_elements}    Get Element Count    ${NEXT_PAGE_BUTTON_QWL_POLL}
    WHILE    ${True}
        ${visible_elements}    Get Element Count    ${NEXT_PAGE_BUTTON_QWL_POLL}
        IF    '${fixed_answer}' != '${NONE}'
            ${random_locator}=    Set Variable    ${fixed_answer}
        ELSE
            ${random_locator}=    Get Random Xpath Answer    ${pool}    ${seed}
        END
        Click    ${${random_locator}}
        IF    ${visible_elements} >= 1
            Click    ${NEXT_PAGE_BUTTON_QWL_POLL}
        ELSE
            BREAK
        END
    END
    Click                           ${SEND_FEEDBACK_BUTTON}
    Wait For Elements State         ${THANK_YOU_FEEDBACK_MESSAGE}     timeout=10

Answer QWL Poll
    [Documentation]    Answers QWL Poll's questions with random or seeded answers from chosen pool.
    [Arguments]        ${name_poll}= QWL Poll    ${pool}=ALL    ${seed}=${NONE}       ${fixed_answer}=${NONE}
    Wait For Elements State        ${LOG_OUT_ELEMENT}     timeout=10
    Sleep    10    #doesn't work without
    Fill QWL Poll

Create New Session
    [Arguments]    ${URL}    ${QWL_API_URL}
    Create Session    MySession    ${URL}
    ${resp}=    GET On Session      MySession    ${QWL_API_URL}
    Should Be Equal As Integers    ${resp.status_code}    200

QWL: Answers for one question
    [Documentation]    Returns list of feedback rows for the question.
    [Arguments]   ${URL}    ${QWL_API_URL}    ${QUESTION}
    Create Session    MySession    ${URL}
    ${resp}=    GET On Session      MySession    ${QWL_API_URL}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Turn response into JSON (dict)
    ${data}=    Set Variable    ${resp.json()}
    # 1) Find the question by matching the question text
    ${meta}=          Get From Dictionary    ${data}    meta
    ${qmap}=          Get From Dictionary    ${meta}    questions
    ${qid}=           Set Variable    ${None}
    FOR    ${id}    ${text}    IN    &{qmap}
        IF    '${text}' == '${QUESTION}'
            ${qid}=    Set Variable    ${id}
            BREAK
        END
    END
    Should Not Be Equal    ${qid}    ${None}    # make sure found it

    # 2) Collect all answers for that question
    ${feedbacks}=     Get From Dictionary    ${data}    feedback
    ${answers}=       Create List
    FOR    ${row}    IN    @{feedbacks}
        ${row_qid}=   Get From Dictionary    ${row}    question
        Run Keyword If    '${row_qid}' == '${qid}'    Append To List    ${answers}    ${row}
    END

    # 3) Assert and print a sample
    ${count}=         Get Length    ${answers}
    Log To Console    Found ${count} answers for: ${QUESTION}
    ${first}=         Get From List    ${answers}    0
    Log               ${first}