import random
from robot.api.deco import keyword
import os
import pandas as pd

class CustomLibrary:

    def __init__(self):
        pass

    @keyword
    def get_random_xpath_answer(self):
        locators = ['QUANTATIVE_0','QUANTATIVE_1','QUANTATIVE_2','QUANTATIVE_3','ALL_GOOD_4','QUALITY_3','QUALITY_2','QUALITY_1','QUALITY_0']
        random_locator = random.choice(locators)
        return random_locator
    
    @keyword
    def get_random_index_answer(self):
        random_index = random.randint(1, 12)  
        return random_index
    
    @keyword
    def get_random_first_name(self, filename='firstname.txt'):
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)),filename)
        with open(path, 'r', encoding="UTF-8") as f:
            lines = f.readlines()
        return random.choice(lines).replace('\n','')
    
    @keyword
    def get_email(self, firstname):
        random_number = random.randint(0, 99)
        domains = ['testmaili.fi', 'maili.com', 'netti.fi']
        domain = random.choice(domains)
        email = f"{firstname.lower()}{random_number}@{domain}"
        return email
    
    @keyword
    def read_poll_data(self, filename='Poll_answers.csv'):
        """Reads CSV file and returns list of dicts with 'question' and 'answer' keys."""
        df = pd.read_csv(filename, delimiter=";")
        return df.to_dict(orient='records')
