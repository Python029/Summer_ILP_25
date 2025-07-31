read -p "What website are you creating a username/password for? " site
read -p "Enter your username: " user
echo -e "\nGenerating random password" 

pass=$(openssl rand -base64 12)

echo -e "$site,$user,$pass\n" >> passwords.txt

echo -e "\nPasswords Saved"
