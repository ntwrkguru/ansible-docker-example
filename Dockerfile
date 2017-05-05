## Lightweight Ansible image (I use a custom image, but this one works)
FROM williamyeh/ansible:alpine3

## Set a temp workdir
WORKDIR /playbook

## This is the context of the git repository that holds the playbook(s) and ancillary files
ADD playbook /playbook

## Assume the playbook is called deploy in the playbook dir
ENTRYPOINT ["ansible-playbook","-i","hosts"]
CMD ["deploy.yml"]
