# Server Classics
# Book to finish:  Data Wrangling with Python
# Bryan Kennedy : https://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers
# Before going ahead add your ssh key

source ~/.bashrc
Login as root
# Install fail2ban #to save your machine
sudo apt-get install fail2ban
adduser deploy #to handle all deploys
# Create a ssh directory for deploy user
mkdir /home/deploy/.ssh
# copy all root keys in
cp /root/.ssh/authorized_keys /home/directory/.ssh/
# Change permissions on the deploy .ssh dir
chmod 700 /home/deploy/.ssh/
# Change dir ownership
chown deploy:deploy -R /home/deploy/
# Add deploy to sudoers -- same as root
visud
# Turn ssh root login
vi /etc/ssh/sshd_config
# Change PermitRootLogin
PermitRootLogin no

# Change Password Authention to not allow clear text passwords.  Only keys allowed
PasswordAuthentication no

# Add a line at the very END
AllowUsers deploy

# Restart ssh services
service ssh restart

