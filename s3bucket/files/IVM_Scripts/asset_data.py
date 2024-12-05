import os
from getpass import getpass
import requests
import json
import socket  
import urllib3
import random
import sys
import pandas as pd
import secrets
import uuid
from datetime import datetime

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

hostname=socket.gethostname()   
IPAddr=socket.gethostbyname(hostname)
bucketname=sys.argv[1]
username=sys.argv[2]
password=sys.argv[3]
hostname=socket.gethostname()   
# bucketname=sys.argv[1]
Port="443"
commands = ['apt install awscli -y',
'apt install unzip -y',
'mkdir /opt/dummy_data && mkdir /opt/dummy_data/scandata',
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Anonymoose.zip /opt/dummy_data/scandata/Anonymoose/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Austin.zip /opt/dummy_data/scandata/Austin/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Belfast.zip /opt/dummy_data/scandata/Belfast/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Boston.zip /opt/dummy_data/scandata/Boston/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Los_Angeles.zip /opt/dummy_data/scandata/Los_Angeles/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Reading.zip /opt/dummy_data/scandata/Reading/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Tokyo.zip /opt/dummy_data/scandata/Tokyo/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/Toronto.zip /opt/dummy_data/scandata/Toronto/",
f"aws s3 cp s3://{bucketname}/IVM_Scripts/VulnLab.zip /opt/dummy_data/scandata/VulnLab/",
'cd /opt/dummy_data/scandata',
#Austin
'cd /opt/dummy_data/scandata/Austin && unzip Austin.zip && cd /opt/dummy_data/scandata',
# #Boston
'cd /opt/dummy_data/scandata/Boston && unzip Boston.zip && cd /opt/dummy_data/scandata',
# #Toronto
'cd /opt/dummy_data/scandata/Toronto && unzip Toronto.zip && cd /opt/dummy_data/scandata',
# #Los_Angeles
'cd /opt/dummy_data/scandata/Los_Angeles && unzip Los_Angeles.zip && cd /opt/dummy_data/scandata',
# #Tokyo
'cd /opt/dummy_data/scandata/Tokyo && unzip Tokyo.zip && cd /opt/dummy_data/scandata',
# #Reading
'cd /opt/dummy_data/scandata/Reading && unzip Reading.zip  && cd /opt/dummy_data/scandata',
#Anonymoose
'cd /opt/dummy_data/scandata/Anonymoose && unzip Anonymoose.zip && cd /opt/dummy_data/scandata',
# #Belfast
'cd /opt/dummy_data/scandata/Belfast && unzip Belfast.zip && cd /opt/dummy_data/scandata',
# #VulnLab
'cd /opt/dummy_data/scandata/VulnLab && unzip VulnLab.zip && cd /opt/dummy_data/scandata',
]
for command in commands:
    process = os.system(command)

sites = ['Boston','Arlington','Austin','Tampa','Reading','Belfast','Dublin','Galway','Munich','Paris','Prague','Melbourne','Singapore','Tel Aviv','Tokyo','Bangalore']
# sites = ['Paris']

site_id = {}
#Create Sites
print(f"Adding sites")
for site in sites:
    print(f"Adding {site} to InsightVM")
    url = f"https://{IPAddr}:{Port}/api/3/sites"
    payload = json.dumps({
    "description": "",
    "name": f"{site}",
    "scan": {
        "assets": {
        "includedAssetGroups": {},
        "includedTargets": {}
        }
    }
    })
    headers = {'Content-Type': 'application/json'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    id = (json_data['id'])
    site_id[site] = id

print(f"Link site/id: {site_id}")

tag_id = {}


##Adding Tags
print(f"Adding Location tags")
for site in sites:
    print(f"Adding tags to InsightVM")
    url = f"https://{IPAddr}:{Port}/api/3/tags"
    payload = json.dumps({
        "color": "defaults",
        "name": f"{site}",
        "type": "location"
    })
    headers = {'Content-Type': 'application/json'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    id_tag = json_data['id']
    
    # #Add tag to site
    url = f"https://{IPAddr}:{Port}/api/3/tags/{id_tag}/sites/{site_id[site]}"
    payload = json.dumps({})
    headers = {'Content-Type': 'application/json'}
    response = requests.request("PUT", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    print(f"Added tag {id_tag} to {site}")

print(f"Adding Location tags")
def get_random_colors():
    colors = ['red','blue','green','orange','purple']
    random_colors = random.choice(colors)	
    return random_colors

custom_list = ['Windows','Linux','Macos','Agent','Database','Production','Server','Workstation','Log4j']
for tag in custom_list:
    print(f"Adding tags {tag} to InsightVM")
    random_colors = get_random_colors()
    url = f"https://{IPAddr}:{Port}/api/3/tags"
    payload = json.dumps({
        "color": f"{random_colors}",
        "name": f"{tag}",
        "type": "custom"
    })
    headers = {'Content-Type': 'application/json'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    id_tag = json_data['id']
    tag_id[tag] = id_tag
print(tag_id)

os_win_work_list = ["Windows 10","Windows 7","Windows 2000"]
os_win_work_id = {}
for os_win_work in os_win_work_list:
    print(f"Adding Windows Workstation Asset group {os_win_work} to InsightVM")
    url = f"https://{IPAddr}:{Port}/api/3/asset_groups"
    payload = json.dumps({
        "description": f"{os_win_work}",
        "name": f"{os_win_work}",
        "searchCriteria": {
            "filters": [
                {
                "field": "operating-system",
                "operator": "contains",
                "value": f"{os_win_work}"
                }
            ],
            "match": "all"
        },
        "type": "dynamic",
        "vulnerabilities": {}
        })
    headers = {'Content-Type': 'application/json'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    print(json_data)
    os_win_work_ag = json_data['id']
    os_win_work_id[os_win_work] = os_win_work_ag
    #Add tags to asset groups
    win_work_tag_list = ["Windows","Workstation"]
    for win_work_tag in win_work_tag_list:
        url = f"https://{IPAddr}:{Port}/api/3/asset_groups/{os_win_work_ag}/tags/{tag_id[win_work_tag]}"
        print(url)
        payload = json.dumps({})
        headers = {'Content-Type': 'application/json'}
        response = requests.request("PUT", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
        json_data = json.loads(response.text)

os_win_list = ["Windows Server 2008","Windows Server 2019","Windows Server 2016"]
os_win_id = {}
for os_win in os_win_list:
    print(f"Adding Windows Asset group {os_win} to InsightVM")
    url13 = f"https://{IPAddr}:{Port}/api/3/asset_groups"
    payload13 = json.dumps({
        "description": f"{os_win}",
        "name": f"{os_win}",
        "searchCriteria": {
            "filters": [
                {
                "field": "operating-system",
                "operator": "contains",
                "value": f"{os_win}"
                }
            ],
            "match": "all"
        },
        "type": "dynamic",
        "vulnerabilities": {}
        })
    headers13 = {'Content-Type': 'application/json'}
    response13 = requests.request("POST", url13, headers=headers13, data=payload13, auth=(username, password),timeout=900,verify=False)
    json_data13 = json.loads(response13.text)
    os_win_ag = json_data13['id']
    os_win_id[os_win] = os_win_ag
    #Add tags to asset groups
    win_serv_tag_list = ["Windows","Server"]
    for win_serv_tag in win_serv_tag_list:
        url = f"https://{IPAddr}:{Port}/api/3/asset_groups/{os_win_ag}/tags/{tag_id[win_serv_tag]}"
        payload = json.dumps({})
        headers = {'Content-Type': 'application/json'}
        response = requests.request("PUT", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
        json_data = json.loads(response.text)
print(os_win_id)

os_lin_list = ["Ubuntu Linux 20.04","Ubuntu Linux 22.04","Ubuntu Linux 12.04","Red Hat Enterprise Linux","Debian Linux","SUSE Linux"]
os_lin_id = {}
for os_lin in os_lin_list:
    print(f"Adding Linux Asset group {os_lin} to InsightVM")
    url = f"https://{IPAddr}:{Port}/api/3/asset_groups"
    payload = json.dumps({
        "description": f"{os_lin}",
        "name": f"{os_lin}",
        "searchCriteria": {
            "filters": [
                {
                "field": "operating-system",
                "operator": "contains",
                "value": f"{os_lin}"
                }
            ],
            "match": "all"
        },
        "type": "dynamic",
        "vulnerabilities": {}
        })
    headers = {'Content-Type': 'application/json'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    os_lin_ag = json_data['id']
    os_lin_id[os_lin] = os_lin_ag
    #Add tags to asset groups
    lin_serv_tag_list = ["Linux","Server"]
    for lin_ser_tag in lin_serv_tag_list:
        url = f"https://{IPAddr}:{Port}/api/3/asset_groups/{os_lin_ag}/tags/{tag_id[lin_ser_tag]}"
        payload = json.dumps({})
        headers = {'Content-Type': 'application/json'}
        response = requests.request("PUT", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
        json_data = json.loads(response.text)
print(os_lin_id)


vuln_list = ["Log4j"]
vuln_list_id = {}
for vuln in vuln_list:
    print(f"Adding Vulnerability Asset group {vuln} to InsightVM")
    url = f"https://{IPAddr}:{Port}/api/3/asset_groups"
    payload = json.dumps({
        "description": f"{vuln}",
        "name": f"{vuln}",
        "searchCriteria": {
            "filters": [
                {
                "field": "cve",
                "operator": "is",
                "value": "CVE-2021-44228"
                },
                    {
                "field": "cve",
                "operator": "is",
                "value": "CVE-2021-45046"
                },
                    {
                "field": "cve",
                "operator": "is",
                "value": "CVE-2021-45105"
                },
            ],
            "match": "all"
        },
        "type": "dynamic",
        "vulnerabilities": {}
        })
    headers = {'Content-Type': 'application/json'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
    json_data = json.loads(response.text)
    print(json_data)
    os_vuln_ag = json_data['id']
    vuln_list_id[vuln] = os_vuln_ag
    #Add tags to asset groups
    vuln_tag_list = ["Log4j"]
    for vuln_tag in vuln_tag_list:
        url = f"https://{IPAddr}:{Port}/api/3/asset_groups/{os_vuln_ag}/tags/{tag_id[vuln_tag]}"
        print(url)
        payload = json.dumps({})
        headers = {'Content-Type': 'application/json'}
        response = requests.request("PUT", url, headers=headers, data=payload, auth=(username, password),timeout=900,verify=False)
        json_data = json.loads(response.text)

##Create TOP 25 Remediations Report
print(f"Creating Top 25 Remediations Reports")
url = f"https://{IPAddr}:{Port}/api/3/reports"
payload = json.dumps({
    "format": "pdf",
    "frequency": {
        "type": "none"
    },
    
    "name": "Top 25 Remediations with Details VulnLab",
    "owner": 1,
    "remediation": {
        "solutions": 25,
        "sort": "riskscore"
    },
    "scope": {
        "sites": [
            site_id['VulnLab']
        ]
    },
    "template": "prioritized-remediations-with-details",
    "timezone": "GMT"
})
headers = {'Content-Type': 'application/json'}
response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),verify=False)
json_data = json.loads(response.text)
print(json_data)
id_report = json_data['id']

# #Add data to sites
print(f"Adding data to Sites")
for site in sites:
    print(f"Adding data to site {site}, id {site_id[site]}, please wait..")
    url = f"https://{IPAddr}:{Port}/api/3/administration/commands"
    payload = f"import scan /opt/dummy_data/scandata/{site}/{site}/scan/ {site_id[site]}"
    headers = {'Content-Type': 'text/plain'}
    response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),timeout=15000,verify=False)
    json_data = json.loads(response.text)
    print(f"Data added to site {site}")

print("Site creation finished")

##Generate Report
url = f"https://{IPAddr}:{Port}/api/3/reports/{id_report}/generate"
payload = json.dumps({})
headers = {'Content-Type': 'application/json'}
response = requests.request("POST", url, headers=headers, data=payload, auth=(username, password),verify=False)
json_data = json.loads(response.text)
print("Generating Report")