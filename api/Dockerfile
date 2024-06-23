FROM python:3.9-slim

RUN pip install 'uvicorn[standard]'

WORKDIR /app

COPY requirements.txt /app/

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY . /app

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
