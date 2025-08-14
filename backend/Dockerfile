
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN apt-get update && apt-get install -y build-essential libxml2-dev libxslt-dev python3-dev libjpeg-dev zlib1g-dev && \
    pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app", "--workers", "2"]
