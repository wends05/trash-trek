# Setup for TrashTrek API

## Installation

- Ensure that you have at least Python 3.8 or above installed on your system.
- Enable the virtual environment by running `python -m venv venv` and `source venv/bin/activate` on Linux / MacOS or `venv\Scripts\activate` on Windows.
- Install the required dependencies by running `pip install -r requirements.txt`
- Set up the environment variables by creating a `.env` file in the root directory and adding the following variables:
    - `MONGO_URL`: The URL of your MongoDB instance. You may use the default value `mongodb://localhost:27017` if you are using MongoDB locally.

## Running the API

- Run the API by running `fastapi run main.py`
