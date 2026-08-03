#!/bin/bash
# Script d'initialisation de l'OS (cloud-init)

# 1. Mise à jour des paquets
apt-get update -y
apt-get upgrade -y

# 2. Installation des prérequis pour Ansible (Python) et outils de base
apt-get install -y python3 python3-pip curl sudo

# 3. Création de l'utilisateur dédié à Ansible
USER_ANSIBLE="ansible"
if ! id "$USER_ANSIBLE" &>/dev/null; then
    useradd -m -s /bin/bash "$USER_ANSIBLE"
    
    # Configuration du Sudo sans mot de passe pour Ansible
    echo "$USER_ANSIBLE ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-ansible
    chmod 0440 /etc/sudoers.d/90-ansible
fi

# 4. Configuration de la clé SSH pour l'utilisateur Ansible
# REMPLACEZ la ligne ci-dessous par votre véritable clé publique SSH
SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgq87YJNe2c0uQH8h0HAjGGn088XbOeEpKQcKHERV4u Ansible"

mkdir -p /home/$USER_ANSIBLE/.ssh
echo "$SSH_PUBLIC_KEY" > /home/$USER_ANSIBLE/.ssh/authorized_keys

# Ajustement des permissions
chown -R $USER_ANSIBLE:$USER_ANSIBLE /home/$USER_ANSIBLE/.ssh
chmod 700 /home/$USER_ANSIBLE/.ssh
chmod 600 /home/$USER_ANSIBLE/.ssh/authorized_keys

# 5. Sécurisation rapide de SSH (Optionnel mais recommandé)
# Désactiver l'authentification par mot de passe si ce n'est pas déjà fait
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

echo "Initialisation de l'OS terminée avec succès."
