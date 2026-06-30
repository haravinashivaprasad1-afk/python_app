FROM python:3.12-slim AS base
WORKDIR /app
COPY requirements.txt .
EXPOSE 5000
CMD ["python", "app.py"]
