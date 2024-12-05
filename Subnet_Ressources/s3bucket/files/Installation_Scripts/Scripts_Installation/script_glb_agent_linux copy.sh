#!/bin/bash
#Read input variables
default_value="Empty"
R7_Region=${1:-$default_value}
AWS_Region=${2:-$default_value}
ServerName=${3:-$default_value}
AD_IP=${4:-$default_value}
TimeZoneID=${5:-$default_value}
Bucket_Name=${6:-$default_value}
DomainName=${7:-$default_value}
DomainNetbiosName=${8:-$default_value}
Token=${9:-$default_value}
AdminUser=${10:-$default_value}
AdminPD=${11:-$default_value}
idr_service_account=${12:-$default_value}
idr_service_account_pwd=${13:-$default_value}
VR_Agent_File=${14:-$default_value}
Instance_IP1=${15:-$default_value}
Instance_IP2=${16:-$default_value}
Instance_Mask=${17:-$default_value}
Instance_GW=${18:-$default_value}
Instance_AWSGW=${19:-$default_value}
Agent_Type=${20:-$default_value}
SEOPS_VR_Install=${21:-$default_value}
Coll_IP=${22:-$default_value}
Orch_IP=${23-$default_value}
SiteName=${24:-$default_value}
SiteName_RODC=${25:-$default_value}
RODCServerName=${26:-$default_value}
RODC_IP=${27:-$default_value}
User_Account=${28:-$default_value}
Keyboard_Layout=${29:-$default_value}
MachineType=${30:-$default_value}
Tenant=${31:-$default_value}
VRM_License_Key=${32:-$default_value}
Dummy_Data=${33:-$default_value}
Routing_Type=${34:-$default_value}
Deployment_Mode=${35:-$default_value}
Scenario=${36:-$default_value}
ZoneName=${37:-$default_value}
PhishingName=${38:-$default_value}
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp - Installing Agent"
wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/agent_control_latest.sh
chmod +x agent_control_latest.sh
./agent_control_latest.sh install_start --token $Token
echo "$timestamp - Agent Installed"
cp /tmp/audit.rules /etc/audit/audit.rules && cp /tmp/audispd.conf /etc/audisp/audispd.conf && cp /tmp/af_unix.conf /etc/audisp/plugins.d/af_unix.conf && cp /tmp/af_unix.conf /etc/audit/plugins.d/af_unix.conf && cp /tmp/audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/

FROM linuxkit/alpine:146f540f25cd92ec8ff0c5b0c98342a9a95e479e AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --initdb -p /out alpine-baselayout apk-tools audit busybox tini
RUN apk add --no-cache wget
# Remove apk residuals. We have a read-only rootfs, so apk is of no use.
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /

COPY auditd.conf /etc/audit
COPY audit.rules /etc/audit
COPY runaudit.sh /usr/bin

RUN wget -O /usr/local/bin/agent_control_latest.sh https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/agent_control_latest.sh
RUN chmod +x /usr/local/bin/agent_control_latest.sh

#CMD ["/sbin/tini", "/usr/bin/runaudit.sh"]
#ENTRYPOINT ["/sbin/tini", "/usr/bin/runaudit.sh && /usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && cp /tmp/audit.rules /etc/audit/audit.rules && cp /tmp/audispd.conf /etc/audisp/audispd.conf && cp /tmp/af_unix.conf /etc/audisp/plugins.d/af_unix.conf && cp /tmp/af_unix.conf /etc/audit/plugins.d/af_unix.conf && cp /tmp/audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/ && /tmp/runaudit.sh  && tail -f /opt/rapid7/ir_agent/components/insight_agent/common/agent.log"]
ENTRYPOINT ["/sbin/tini", "/usr/bin/runaudit.sh && /usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && tail -f /opt/rapid7/ir_agent/components/insight_agent/common/agent.log"]



# Use a base image (e.g., Ubuntu, CentOS, etc.)
FROM ubuntu:latest
# Install necessary packages
RUN apt-get update && \
    apt-get install -y auditd \
    && apt-get install -y wget
# Download your application script
RUN wget -O /usr/local/bin/agent_control_latest.sh https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/agent_control_latest.sh
RUN chmod +x /usr/local/bin/agent_control_latest.sh
# Default environment variable
ENV TOKEN=default_value
ENV TERM xterm
ENV HOSTNAME=fake-agent
# Configure auditd (optional, adjust as needed)
COPY audit.rules /tmp
COPY audispd.conf /tmp
COPY af_unix.conf /tmp
COPY af_unix.conf /tmp
COPY audit.conf /tmp
COPY runaudit.sh /tmp
RUN chmod +x /tmp/runaudit.sh
USER root
ENTRYPOINT ["/bin/bash", "-c", "/usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && cp /tmp/audit.rules /etc/audit/audit.rules && cp /tmp/audispd.conf /etc/audisp/audispd.conf && cp /tmp/af_unix.conf /etc/audisp/plugins.d/af_unix.conf && cp /tmp/af_unix.conf /etc/audit/plugins.d/af_unix.conf && cp /tmp/audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/ && /tmp/runaudit.sh  && tail -f /opt/rapid7/ir_agent/components/insight_agent/common/agent.log"]

docker run --rm --cap-add=CAP_AUDIT_CONTROL --cap-add=CAP_AUDIT_READ --cap-add=CAP_AUDIT_WRITE --cap-add=CAP_SYS_NICE -v /var/log:/var/log -e HOSTNAME=fake-agent-y -e TOKEN=us2:c7d3bf04-a145-42c2-8cb2-7592f2e12d72 -h fake-agent-y auditd install_start --token $TOKEN
docker run --rm -v /etc/audit/:/etc/audit/ -v /etc/audisp/:/etc/audisp/ -e HOSTNAME=fake-agent-y -e TOKEN=us2:c7d3bf04-a145-42c2-8cb2-7592f2e12d72 --cap-add SYS_NICE --cap-add SYS_ADMIN --privileged --cap-add AUDIT_CONTROL -h fake-agent-y fake-agent-2204 install_start --token $TOKEN


FROM ubuntu:latest
# Install necessary packages
RUN apt-get update && \
    apt-get install -y auditd \
    && apt-get install -y wget
# Remove apk residuals. We have a read-only rootfs, so apk is of no use.

FROM scratch
WORKDIR /
COPY --from=mirror /out/ /
COPY auditd.conf /etc/audit
COPY audit.rules /etc/audit
COPY runaudit.sh /usr/bin
COPY agent_control_latest.sh /usr/local/bin

ENV TOKEN=default_value
ENV TERM xterm
ENV HOSTNAME=fake-agent

RUN chmod +x /usr/local/bin/agent_control_latest.sh

#CMD ["/sbin/tini", "/usr/bin/runaudit.sh"]
#ENTRYPOINT ["/sbin/tini", "/usr/bin/runaudit.sh && /usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && cp /tmp/audit.rules /etc/audit/audit.rules && cp /tmp/audispd.conf /etc/audisp/audispd.conf && cp /tmp/af_unix.conf /etc/audisp/plugins.d/af_unix.conf && cp /tmp/af_unix.conf /etc/audit/plugins.d/af_unix.conf && cp /tmp/audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/ && /tmp/runaudit.sh  && tail -f /opt/rapid7/ir_agent/components/insight_agent/common/agent.log"]
ENTRYPOINT ["/sbin/tini","/usr/bin/runaudit.sh && /usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && tail -f /dev/null"]

~
~
~
~
~
~
~
~
~
~
~


FROM linuxkit/alpine:146f540f25cd92ec8ff0c5b0c98342a9a95e479e AS mirror
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk update
RUN apk add ca-certificates
RUN update-ca-certificates
RUN apk add --initdb -p /out alpine-baselayout apk-tools audit busybox tini curl
# Remove apk residuals. We have a read-only rootfs, so apk is of no use.
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
WORKDIR /
COPY --from=mirror /out/ /
COPY auditd.conf /etc/audit
COPY audit.rules /etc/audit
COPY runaudit.sh /usr/bin
COPY agent_control_latest.sh /usr/local/bin

ENV TOKEN=default_value
ENV TERM xterm
ENV HOSTNAME=fake-agent

RUN chmod +x /usr/local/bin/agent_control_latest.sh

#CMD ["/sbin/tini", "/usr/bin/runaudit.sh"]
#ENTRYPOINT ["/sbin/tini", "/usr/bin/runaudit.sh && /usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && cp /tmp/audit.rules /etc/audit/audit.rules && cp /tmp/audispd.conf /etc/audisp/audispd.conf && cp /tmp/af_unix.conf /etc/audisp/plugins.d/af_unix.conf && cp /tmp/af_unix.conf /etc/audit/plugins.d/af_unix.conf && cp /tmp/audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/ && /tmp/runaudit.sh  && tail -f /opt/rapid7/ir_agent/components/insight_agent/common/agent.log"]
ENTRYPOINT ["/bin/bash","-c","/usr/bin/runaudit.sh && /usr/local/bin/agent_control_latest.sh uninstall && /usr/local/bin/agent_control_latest.sh install_start --token $TOKEN && tail -f /dev/null"]

~