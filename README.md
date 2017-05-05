# ansible-docker-example

In a nutshell, we wrap an Ansible playbook in a Dockerfile so that the end user need not know Ansible nor Docker. They can simply copy and paste 2 commands to execute a playbook. If the playbook is self-contained and passed around easy, say via email or file transfer, it's even easier to accomplish (see example #2)

## Example 1

Here we have a playbook with hosts file and such. It could contain roles, vars, etc. We version control it in git. To execute the playbook, we first build the Docker image then run it.

```bash
$ docker build -t deploy https://github.com/ntwrkguru/ansible-docker-example.git
Sending build context to Docker daemon 64.51 kB
Step 1/5 : FROM williamyeh/ansible:alpine3
 ---> c1db0908ef99
Step 2/5 : WORKDIR /playbook
 ---> d0f7f8e515e9
Removing intermediate container 9100dad47d0c
Step 3/5 : ADD playbook /playbook
 ---> f037b9eb6853
Removing intermediate container 44e6682360b5
Step 4/5 : ENTRYPOINT ansible-playbook
 ---> Running in 561483b57d22
 ---> 1b44dece8572
Removing intermediate container 561483b57d22
Step 5/5 : CMD -i hosts deploy.yml
 ---> Running in 204ae17f4a28
 ---> 824f8174ab5e
Removing intermediate container 204ae17f4a28
Successfully built 824f8174ab5e
```

Next we run it.

```bash
$ docker run deploy

PLAY [localhost] ***************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [ping] ********************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0
```

## Example 2

If we were to distribute a simple playbook, this becomes even easier. From the directory that contains the playbook, run:

```bash
$ docker run -v $PWD:/playbook deploy

PLAY [localhost] ***************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [ping] ********************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0
```

The `-v $PWD:/playbook` switch bind mounts the current working dir (`$PWD`) to the `WORKDIR` of the container; `/playbook`. This will expose the playbook to the container's filesystem and allow Ansible to execute it.