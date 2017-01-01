# Playbook for Managing iPerf3 Server

#### Usage
Launch an iPerf3 server on the host defined in the inventory file (`hosts`)
```bash
ansible-playbook server.yml --extra-vars "state=restarted"
```

Terminate the server
```bash
ansible-playbook server.yml --extra-vars "state=absent"
```
