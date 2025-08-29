# VibeCatch

This repository contains automated UI tests and API test for VibeCatch using Robot Framework and the Browser Library.

These tests are part of a training project to automate core poll creation, asnwering polls, fetching data via API Key from Poll, poll deletion, and login functionalities. 

## 📌 What’s Tested?
The following test scenarios are automated:

- Login Test

Verifies login functionality with valid / invalid credentials.

- Create Poll Test

Creates a new poll with a given name.

- Fetching Data From Poll Question Test

Get feedback from poll answers and verifying removals.

- Delete Poll Test

Deletes a poll by locating it by name.

- Accessability Test

Checks how website meets accessability standards. 

## Project Structure

## Setup Instructions


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

Secrets for login and api key are hold in .env file and add there:

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

## Running tests with Docker

NOTE: Tests are not running properly inside docker image due to slow webpage. Adding more sleeps inbetween tests/keywords might solve this problem. 

### Prerequisites

- Docker Desktop

### Build the Docker image:

```
docker build -t vibecatch_tests .
```

### Run the image with headful variable:

```
run --rm -e ROBOT_OPTIONS="-v HEADLESS:true" vibecatch_tests
```
