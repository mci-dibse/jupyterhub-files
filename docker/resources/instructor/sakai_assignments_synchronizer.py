#!/usr/bin/env python3

import sys
import subprocess
import os
from zeep import Client
import base64
import xml.etree.ElementTree as ET

if len(sys.argv) != 2:
    print("Usage: ", sys.argv[0] + " sakai_course_id")
    exit(1)

course_id = sys.argv[1]
course_dir = "."
source_dir = os.path.join(course_dir, "source")
base_url='https://sakai.mci4me.at'
login_url = base_url + "/sakai-ws/soap/login?wsdl"
soap_url='/sakai-ws/soap'
assignment_url = base_url + soap_url + "/assignments?wsdl"
#https://sakai.mci4me.at/sakai-ws/soap/login?wsdl
try:
    login_proxy = Client(login_url)
except Exception as e:
    print(e)

try:
    session_id = login_proxy.service.login(id='dd1337', pw='jDsG6Cy4wwWcZ4yZ9ZAA4uh')
    service_proxy = Client(assignment_url)
    body = service_proxy.service.getAssignmentsForContext(session_id, course_id)
    root = ET.fromstring(body)
    for child in root:
        os.makedirs(os.path.join(source_dir, child.attrib['title']), exist_ok=True)
        command = "nbgrader db assignment add " + child.attrib['title']
        # + " --duedate \"" + child.attrib['dueTime'] + "\""
        print(command)
        process = subprocess.Popen(command.split(), stdout=subprocess.PIPE, cwd=course_dir)
        stdout, stderr = process.communicate()
        print("stdout: ", stdout)
        print("stderr: ", stderr)

    login_proxy.service.logout(session_id)

except Exception as e:
    print(e)
    login_proxy.service.logout(session_id)
