import requests

url = 'http://127.0.0.1:8000/upload'  # Replace with the URL of your Django view for file upload
file_path = 'config.wxcfg'  # Replace with the path to the file you want to upload
param = {'deviceID': '9bZKIAVhD4SM7MkFAay1'}

with open(file_path, 'rb') as file:
    files = {'file': file}
    response = requests.post(url, data=param, files=files)

if response.status_code == 200:
    print("File uploaded successfully.")
else:
    print("File upload failed.")
