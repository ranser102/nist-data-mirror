
NIST Data Mirror
================

A simple Java command-line utility to mirror the NVD (CPE/CVE JSON) data from NIST.

The intended purpose of nist-data-mirror is to be able to replicate the NIST vulnerability data 
inside a company firewall so that local (faster) access to NIST data can be achieved.

nist-data-mirror does not rely on any third-party dependencies, only the Java SE core libraries. 
It can be used in combination with [OWASP Dependency-Check] in order to provide Dependency-Check 
a mirrored copy of NIST data.

Upstream project is: https://github.com/stevespringett/nist-data-mirror  


Usage
----------------

### Prerequisite

- Add secret to push images to into container image registry  

- Create proxy repository which will point to https://nvd.nist.gov/feeds/json/cve/  

- 

### Building

Build is through Dockerfile which add maven and build the java program
OpenShift build template is building the image and publishing into docker repository .  
Parameters:  
- NAMESPACE: OpenShift namespace to run the build
- SLEEPTIME: Idle time between iteration of downloading/syncing data from https://\<proxy repository\>/NVD-Proxy/  

Command:
`oc process -f .openshift/templates/build-nvdmirror.yaml -p NAMESPACE=\<your namespace\> -p SLEEPTIME=12h -p TARGET_IMAGE_STREAM_TAG=latest | oc apply -f -`



### Running

The java program is downloading all the CVE json and metadata files, through proxy repository in your proxy repository 
so files are available there.

The java program is running inside OpenShift Pod .

### Packaging the helm chart and deploying into OpenShift

 - (Optional) uninstall previous deployment: `helm uninstall nvdmirror`
 - (One time only) Add helm repo poinhelting to helm repository: `helm repo add <repo name> https://\<your helm repo\>`
 - Package the chart: `helm package nvdmirror/` 
 - Push the chart to helm repository: `curl -u <container image repository credentails>  https://\<your helm repo\> --upload-file ./nvdmirror-<chart version from Chart.yaml>.tgz -v`
 - Update local helm repository: `helm repo update`
 - Installtion: `helm install nvdmirror <repo name>/nvdmirror`
 - Test the deployment: `helm test nvdmirror`


Related Projects
----------------

* [VulnDB Data Mirror](https://github.com/stevespringett/vulndb-data-mirror)


