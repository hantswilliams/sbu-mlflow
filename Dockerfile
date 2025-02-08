# Use a lightweight Python image
FROM python:3.11-slim

# Set environment variables
ENV MLFLOW_HOME=/opt/mlflow
ENV BACKEND_STORE_URI=sqlite:///mlflow.db
ENV ARTIFACT_STORE=file:/mlruns
ENV HOST=0.0.0.0
ENV PORT=5000

# Set working directory
WORKDIR $MLFLOW_HOME

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install MLflow and other dependencies
RUN pip install --no-cache-dir \
    mlflow \
    gunicorn \
    psycopg2-binary \
    pymysql \
    boto3

# Expose the MLflow port
EXPOSE $PORT

# Default command to run MLflow tracking server
CMD ["gunicorn", "-b", "0.0.0.0:5000", "--timeout", "60", "mlflow.server:app"]
