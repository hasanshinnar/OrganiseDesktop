# Pull base image
FROM python:3.11-slim

# Set the working directory to /code
WORKDIR /code

# Copy the current directory content into the container at /code
ADD . /code

# Udate and install all in the container
RUN apt-get update && \
    apt-get install -y \\
    xvfb \\
    libx11-6 \\
    libxext6 \\
    xauth \\
    && rm -rf /var/lib/apt/lists/*

# Install pipenv and install all dependency
RUN pip install --upgrade pip
RUN pip install pipenv
COPY ./Pipfile /code/Pipfile
RUN pipenv install --deploy --system --skip-lock --dev

# Set enviroment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1