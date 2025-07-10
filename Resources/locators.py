#Login
LOGIN_BUTTON = '//a[contains(@class, "login")]'
USERNAME_FIELD = '//*[@id="username"]'
PASSWORD_FIELD = '//*[@id="password"]'
LOGIN_BUTTON2 =  '//input[@value= "Login"]'
LOG_OUT_ELEMENT = '//a[contains(text(), "Log out")]'
#Createnewpoll
ADD_NEW_PROJECT = '(//a[contains(@class, "add-project")])[1]'
ADD_PROJECT_NAME = '//*[@id="addProjectName"]'
#QWL
CREATE_QWL_POLL_BUTTON = 'text="Create a QWL poll"'
QWL_TYPE_OPTIONS = '//select[option[@value="complete"]]'
ORGANIZATION_TYPE_OPTIONS = '//select[option[contains(text(),"traditional")]]'
HIDE_VECTOR_GRAPHS_CHECKBOX = '//input[@type="checkbox"]'
#Custompoll
CREATE_CUSTOM_POLL_BUTTON = 'text="Create a custom poll"'
ADD_QUESTIONS_BUTTON = '//a[contains(text(),"Add questions")]'
TYPE_QUESTIONS_FIELD = '//*[@id="customQuestionText"]'
ADD_QUESTIONS_BUTTON2 = '//button[contains(text(),"Add questions")]'
#removepolls
PROJECT_ROW = '//div[@id="masterContainer"]//div[contains(@class, "projectRow")]'
CHANGE_POLL_SETTINGS = '(//a[@mattooltip="Change poll\'s settings"])[1]'
DELETE_POLL_BUTTON = '//vibe-settings-advanced-button[@icon="trash"]'
DELETE_PROJECT_BUTTON = '//a[contains(@class, "delete-project")]'
DELETE_NOW_POLL_BUTTON = '//button[contains(text(), "Delete now")]'
TYPE_DESTROY_FIELD = '//input[@vibeselecttext]'
VERIFY_REMOVAL_OK_BUTTON = '//button[contains(@class, "promptOkButton")]'
PROJECT_ROW = '//div[@id="masterContainer"]//div[contains(@class, "projectRow")]'