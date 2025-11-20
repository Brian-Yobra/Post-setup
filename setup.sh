# Add PostgreSQL official repo
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update and install latest PostgreSQL
sudo apt update
sudo apt install postgresql-15 postgresql-client-15 -y

# Start and enable service
sudo systemctl enable --now postgresql

# Create a secure user and database
sudo -i -u postgres psql -c "CREATE USER xeno WITH PASSWORD 'xeno';"
sudo -i -u postgres psql -c "CREATE DATABASE defaultdb OWNER xeno;"

# Allow local and remote access (optional)
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/15/main/postgresql.conf
echo "host    all             all             0.0.0.0/0               md5" | sudo tee -a /etc/postgresql/15/main/pg_hba.conf
sudo systemctl restart postgresql

# Test connection
psql -h localhost -U xeno -d defaultdb
