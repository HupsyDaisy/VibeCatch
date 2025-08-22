# VibeCatch

These test cases in SUITES folder are for testing website VibeCheck (https://env-5369504.paas.datacenter.fi/) and needed resources in Resources folder

In order to run tests, you need to install first test environment with following commands:

```shell
python -m venv venv
venv\Scripts\activate
```

Install dependencies with included dependencies in requirements.txt with following command:

```shell
pip install -r requirements.txt
```

Initialize robot framework browser:

```shell
rfbrowser init
```

Secrets are hold in .env file and add there:

```
USER=<YOUR_USERNAME>
PASSWORD=<YOUR_PASSWORD>
QWL_API=api/v1/feedbacks?apiKey=<YOUR_API_KEY>
```
In order to do API test to polls you need to create API key for polls:

## Creating API keys for polls
- Each api key needs to be created separately for each poll.
- Where to find the Open API button varies depending on poll type.
 
### Creating an API key for QWL poll
- On the dashboard open the poll
- Go to Collected feedback
- Click Open API button
- Click Create API key
 
### Creating an API key for 360 feedback poll
- On the dashboard open the poll
- Click Evaluation Trends button
- Click Open API button
- Click Create API key
 
### Creating an API key for Custom poll
- On the dashboard open the poll
- Scroll to the bottom of the page and Click Open API button
- Click Create API key

