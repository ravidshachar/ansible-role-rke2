## How to spin a lab:
Use a linux distribution or WSL
You should install: `terraform`, `sshpass` (for using ssh with passwords), `python3-pip`, `azure cli`:

    apt install terraform python3-pip sshpass
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
install required python modules:

    python3 -m pip install pywinrm jinja2 MarkupSafe ansible
The following ansible galaxy collections:

    ansible-galaxy collection install ansible.windows azure.azcollection
clone the repository:

    git clone https://github.com/ravidshachar/ansible-role-rke2
    cd ansible-role-rke2/terraform
Login to azure:

    az login
edit the tfvars file:
   
    vim example.auto.tfvars
finally run terraform init & apply:

    terraform init
    terraform apply
