FROM python:3.12-slim AS builder

# Install Postgres client libs required to build psycopg2
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libpq-dev \
    build-essential

WORKDIR /app
COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt


FROM python:3.12-slim

# Install Postgres runtime libs
RUN apt-get update && apt-get install -y libpq5

WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
