FROM python:3.8-slim-buster

COPY ./server.py /opt/websocket-server.py
COPY ./requirements.txt /opt/requirements.txt 

RUN pip install -r /opt/requirements.txt
RUN chmod +x /opt/websocket-server.py

WORKDIR /opt

EXPOSE 8080
CMD ["python", "websocket-server.py"]