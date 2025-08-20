*** Settings ***
Resource         ../Resources/vibecatch.resource
Suite Setup       Open And Login VibeCheck
Suite Teardown    Close Browser
Test Template    Answer QWL Poll

*** Test Cases ***

Answer QWL Poll Case 1       QWL Poll    ALL    ${NONE}       ${NONE}
    [Documentation]    Answers QWL Poll randomily from pool of answers.

Answer QWL Poll Case 2       QWL Poll    QUALITY    ${NONE}       QUALITY_2
    [Documentation]    Answers QWL Poll with Quality_2 answers only

Answer QWL Poll Case 3       QWL Poll    NEQATIVE    42       ${NONE}
    [Documentation]    Answers QWL Poll with negative answers only and can be reproduced with seed 42.

Answer QWL Poll Case 4       QWL Poll    POSITIVE    ${NONE}       ${NONE}
    [Documentation]    Answers QWL Poll with positive answers only