# VibeCatch

These test cases in SUITES folder are for testing website VibeCheck (https://env-5369504.paas.datacenter.fi/) and needed resources in Resources folder

## In order to run tests, you need to install first test environment with following commands:

```
python -m venv venv
venv\Scripts\activate
```

Install dependencies with included dependencies in requirements.txt with following command:

```
pip install -r requirements.txt
```

Initialize robot framework browser:

```
rfbrowser init
```

## Create .env file and add there:

```
USER=<YOUR_USERNAME>
PASSWORD=<YOUR_PASSWORD>
```

