*** Settings ***
Documentation       API test to check respond from answered QWL Poll questions
Resource        ../Resources/vibecatch.resource

Test Tags       api


*** Test Cases ***
Get Feedback For QWL Poll Question Case 1
    [Documentation]    You can get poll feedback from pool of list:
    ...    ${QUESTION} ["Organisaatiomme huolehtii ihmisten työhyvinvoinnista",
    ...    "Sisäinen viestintämme toimii hyvin koko organisaatiossa",
    ...    "Ylin johto tekee oikeita asioita, jotta organisaatiomme on valmistautunut tulevaisuutta varten"]
    Answers For One Question    ${URL}    ${QWL_API_URL}    Organisaatiomme huolehtii ihmisten työhyvinvoinnista

Get Feedback For QWL Poll Question Case 2
    [Documentation]    How many answers have one question in QWL Poll received:
    ...    ${QUESTION} ["Organisaatiomme huolehtii ihmisten työhyvinvoinnista",
    ...    "Sisäinen viestintämme toimii hyvin koko organisaatiossa",
    ...    "Ylin johto tekee oikeita asioita, jotta organisaatiomme on valmistautunut tulevaisuutta varten"]
    Answers For One Question    ${URL}    ${QWL_API_URL}    Sisäinen viestintämme toimii hyvin koko organisaatiossa
