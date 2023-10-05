# Use Python 3.11 image as the base
FROM python:3.11

# Set the working directory to /app
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt ./

# Install dependencies defined in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# Copy your application code to the working directory
COPY . .

# Expose the port on which the API will listen
EXPOSE "5001"

# Command to run the application
CMD ["uvicorn", "main:app", "--proxy-headers","--host", "0.0.0.0", "--port", "5001"]
