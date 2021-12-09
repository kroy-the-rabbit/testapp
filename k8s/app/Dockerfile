FROM python:3.9

RUN apt-get clean \
    && apt-get -y update \
    && apt-get -y dist-upgrade

RUN apt-get -y install \
    python3-dev \
    build-essential

RUN apt-get -y install redis-server


WORKDIR /app

COPY supervisord.conf /etc/supervisord.conf

COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt --src /usr/local/src


COPY testapp.py /app/testapp.py
COPY index.html /app/index.html
COPY uwsgi.ini /app/uwsgi.ini

EXPOSE 80

ENTRYPOINT ["supervisord"]
#CMD ["uwsgi","uwsgi.ini"]

