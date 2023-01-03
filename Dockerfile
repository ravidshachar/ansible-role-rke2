FROM cytopia/ansible:latest-tools
RUN apk add sshpass
RUN pip install pywinrm
RUN ansible-galaxy collection install ansible.windows
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]