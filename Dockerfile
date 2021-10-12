# pull official base image
FROM python:3.9.5-slim-buster

ENV APP_HOME=/usr/src/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN groupadd --gid 5000 appuser \
    && useradd --home-dir /home/appuser --create-home --uid 5000 \
        --gid 5000 --shell /bin/sh --skel /dev/null appuser

# install dependencies
RUN pip install --upgrade pip --progress-bar off --quiet
COPY ./app/requirements.txt $APP_HOME/requirements.txt
RUN pip install -r requirements.txt --progress-bar off --quiet

COPY ./run_server.sh $APP_HOME
RUN chmod 755 $APP_HOME/run_server.sh

# copy project and set file ownership
COPY . $APP_HOME/
RUN chown -R appuser:appuser $APP_HOME

USER appuser

ENTRYPOINT ["/bin/bash", "/usr/src/app/run_server.sh"]
