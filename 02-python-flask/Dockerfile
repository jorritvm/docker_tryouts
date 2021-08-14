FROM python:3.8.11

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

WORKDIR /app/src
CMD [ "python", "-m", "flask", "run", "--host=0.0.0.0" ]