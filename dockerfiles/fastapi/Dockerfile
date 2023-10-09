FROM python:3.11.6-alpine3.18

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE "5001"

CMD ["uvicorn", "main:app", "--proxy-headers","--host", "0.0.0.0", "--port", "5001"]
