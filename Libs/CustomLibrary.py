import random
from robot.api.deco import keyword
import os
import pandas as pd

class CustomLibrary:

    def __init__(self):
        pass

    @keyword
    def get_random_xpath_answer(self, pool='ALL', seed=None):
        """
        Returns a locator variable name like 'QUANTATIVE_3' that you can dereference
        in Robot as ${${random_locator}}.
        pool: 'ALL' (default), 'QUANTATIVE', 'QUALITY', 'ALL_GOOD', 'POSITIVE', 'NEGATIVE'
        seed: optional int to make random choice reproducible
        """
        buckets = {
            'ALL': [
                'QUANTATIVE_0','QUANTATIVE_1','QUANTATIVE_2','QUANTATIVE_3',
                'ALL_GOOD_4',
                'QUALITY_3','QUALITY_2','QUALITY_1','QUALITY_0'
            ],
            'QUANTATIVE': ['QUANTATIVE_0','QUANTATIVE_1','QUANTATIVE_2','QUANTATIVE_3'],
            'QUALITY':    ['QUALITY_0','QUALITY_1','QUALITY_2','QUALITY_3'],
            'ALL_GOOD':   ['ALL_GOOD_4'],

            # Convenience “sentiments” (tweak as you like)
            'POSITIVE':   ['ALL_GOOD_4','QUALITY_3','QUANTATIVE_3'],
            'NEGATIVE':   ['QUALITY_0','QUANTATIVE_0']
        }

        items = buckets.get(str(pool).upper(), buckets['ALL'])
        if seed is not None:
            random.seed(int(seed))
        return random.choice(items)
    
    @keyword
    def get_random_index_answer(self):
        """
        Returns random index inbetween 3-12.
        """
        random_index = random.randint(3, 12)  
        return random_index
    
    @keyword
    def get_random_first_name(self, filename='firstname.txt'):
        """
        Returns random first name from firstname.txt
        """
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)),filename)
        with open(path, 'r', encoding="UTF-8") as f:
            lines = f.readlines()
        return random.choice(lines).replace('\n','')
    
    @keyword
    def get_email(self, firstname):
        """
        Returns random email.
        """
        random_number = random.randint(0, 99)
        domains = ['testmaili.fi', 'maili.com', 'netti.fi']
        domain = random.choice(domains)
        email = f"{firstname.lower()}{random_number}@{domain}"
        return email
    
    @keyword
    def read_poll_data(self, filename='Poll_answers.csv'):
        """
        Reads CSV file and returns list of dicts with 'question' and 'answer' keys.
        """
        df = pd.read_csv(filename, delimiter=";")
        return df.to_dict(orient='records')
