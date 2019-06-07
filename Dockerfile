FROM python:slim

RUN pip install ansible

WORKDIR /project

VOLUME /project

ENTRYPOINT ["ansible-playbook"]
