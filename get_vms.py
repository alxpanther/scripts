# Get VMs (listing) from vCenter
##
# Requires:
# pip3 install requests
# pip3 install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git
##
# Change (see below) server, username (full: vasya@pupkin.local), password
##
# use: python3 get_vms.py


from pprint import pprint
import requests
import urllib3
from vmware.vapi.vsphere.client import create_vsphere_client
from com.vmware.vcenter_client import VM, Host
import sys


def createConnection():
    session = requests.session()
    session.verify = False
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

    vsphere_client = create_vsphere_client(
        server='10.73.31.100',
        username='USERNAME',
        password='PASS',
        session=session
    )

    return vsphere_client


def getVMSonHost():
    vsphere_client = createConnection()

    vm_cluster_list = []
    clusters = vsphere_client.vcenter.Cluster.list()
    for cluster_summary in clusters:
        hosts = vsphere_client.vcenter.Host.list(
            Host.FilterSpec(clusters={cluster_summary.cluster}))
        for host_summary in hosts:
            vms = vsphere_client.vcenter.VM.list(
                VM.FilterSpec(hosts={host_summary.host}))
            for vm in vms:
                vm_cluster_list.append([cluster_summary.name, vm.name])

    return vm_cluster_list


giant_vm_list = getVMSonHost()
pprint(giant_vm_list)
