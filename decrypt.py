import os
import sqlite3
import shutil
from Cryptodome.Cipher import AES
import argparse
import csv
 
def generate_cipher(aes_key, iv):
    return AES.new(aes_key, AES.MODE_GCM, iv)
 
def decrypt_payload(cipher, payload):
    return cipher.decrypt(payload)
 
def decrypt_password(buff, master_key):
    try:
        iv = buff[3:15]
        payload = buff[15:]
        cipher = generate_cipher(master_key, iv)
        decrypted_pass = decrypt_payload(cipher, payload)
        decrypted_pass = decrypted_pass[:-16].decode()  # remove suffix bytes
        return decrypted_pass
    except Exception as e:
        return "Chrome < 80"
 
def display_credentials(url, username, decrypted_password):
    separator = "-" * 60
    print(separator)
    print(f"URL: {url}")
    print(f"User Name: {username}")
    print(f"Password: {decrypted_password}")
    print(separator)
    print("\n")
 
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Retrieve Chrome credentials.")
    parser.add_argument("-f", "--file", help="Path to the Chrome login data.", required=True)
    parser.add_argument("-k", "--key", help="Path to the master key file.", required=True)
     
    args = parser.parse_args()
 
    # Reading master key from the provided file
    with open(args.key, 'rb') as f:
        master_key = f.read()
 
    temp_db = "Loginvault.db"
    shutil.copy2(args.file, temp_db)  # making a temp copy since Login Data DB is locked while Chrome is running
    conn = sqlite3.connect(temp_db)
    cursor = conn.cursor()
 
    try:
        cursor.execute("SELECT action_url, origin_url, username_value, password_value FROM logins")
                
        for r in cursor.fetchall():
            action_url = r[0]
            origin_url = r[1]
            url = action_url if action_url else origin_url
            username = r[2]
            encrypted_password = r[3]
            decrypted_password = decrypt_password(encrypted_password, master_key)
            #display_credentials(url, username, decrypted_password)
            with open('decrypted_password.csv', 'w', newline='') as csvfile:
                fieldnames = ['URL', 'Username', 'Password']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                writer.writerow({'URL': url, 'Username': username, 'Password': decrypted_password})
    except Exception as e:
        print("Error:", e)
 
    cursor.close()
    conn.close()
 
    try:
        os.remove(temp_db)
    except Exception as e:
        print("Error removing temp DB:", e)