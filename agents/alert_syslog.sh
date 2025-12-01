#!/bin/sh
#
##############################################################################
# Copyright 2016-2017 the Pacemaker project contributors
#
# The version control history for this file may have further details.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
##############################################################################
#
# Sample configuration (cib fragment in xml notation)
# ================================
#
#  <alert id="alert_webcluster1" path="/var/lib/pacemaker/alert_syslog.sh">
#     <instance_attributes id="alert_webcluster1-instance_attributes">
#       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_facility" name="RHA_syslog_facility" value="local2"/>
#       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_port" name="RHA_syslog_port" value="2514"/>
#       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_priority" name="RHA_syslog_priority" value="err"/>
#       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_proto" name="RHA_syslog_proto" value="tcp"/>
#       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_server" name="RHA_syslog_server" value="fqdn.syslog.example.com"/>
#       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_tag" name="RHA_syslog_tag" value="webcluster1"/>
#     </instance_attributes>
#
##############################################################################
#
# DEBUG
# Uncomment these lines for debug trace logging
#
# set -xv
# exec 2 > /var/log/pacemaker-alert_syslog-debug.log
#
##############################################################################
if tty -s ;
then

MANPAGER= man 5 alert_syslog

exit 1
fi

##############################################################################

if [ ! -z $RHA_alert_kinds ]; then
  optAlertKinds="${RHA_alert_kinds}"
else
  
  #_#########################################################
  # Pass "RHA_alert_kinds" as an option at the pcs alert create
  # stage, otherwise if the variable is null/not set by alert 
  # options assignment, take the value in this stanza
  #_# Take alert types out of optAlertKinds to disable alerts
  # optAlertKinds="fencing,node,resource"
  optAlertKinds="fencing,node,resource"
fi

strNodeName=$(hostname)
strClusterName="$(crm_attribute --query -n cluster-name)"
dtStamp=$(date --date @$CRM_alert_timestamp_epoch +"%F_%T %z")
strNotice="$(echo -e '\nEnvironment variables:' ; env | grep 'CRM_alert_' ; env | grep 'RHA_syslog_')"
if [ ! -z "${RHA_syslog_server}" ]; then
  if [ -z "${RHA_syslog_protocol}" ]; then
    optSyslogServer="--server ${RHA_syslog_server} --tcp"
  else
    optSyslogServer="--server ${RHA_syslog_server} --${RHA_syslog_protocol}"
  fi
fi
if [ ! -z ${RHA_syslog_port} ]; then
  optSyslogPort="--port ${RHA_syslog_port}"
fi
if [ ! -z ${RHA_syslog_tag} ]; then
  optTag="--tag ${RHA_syslog_tag}"
fi



if [ -z ${CRM_alert_version} ]; then
  strSummary="Pacemaker version 1.1.15 or later is required for alerts"
else
  case ${CRM_alert_kind} in
    node)
      if [[ $optAlertKinds == *"node"* ]]; then
        strSummary="${CRM_alert_timestamp} ${cluster_name}: Node '${CRM_alert_node}' is now '${CRM_alert_desc}'"
      fi
    ;;
    fencing)
  		if [[ $optAlertKinds == *"fencing"* ]]; then
        strSummary="${strClusterName} ${dtStamp} (node ${strNodeName} alert time: ${CRM_alert_timestamp}): Fencing ${CRM_alert_desc}"
      fi
      ;;
    resource)
      if [[ $optAlertKinds == *"resource"* ]]; then 
        if [ ${CRM_alert_interval} = "0" ]; then
          CRM_alert_interval=""
        else
          CRM_alert_interval=" (${CRM_alert_interval})"
        fi
  
        if [ ${CRM_alert_target_rc} = "0" ]; then
          CRM_alert_target_rc=""
        else
          CRM_alert_target_rc=" (target: ${CRM_alert_target_rc})"
        fi

        if [[ ${CRM_alert_desc} == "Timed Out" ]]; then 
          RHA_syslog_priority="crit"
          strSummary="CRITICAL FAILURE: ${CRM_alert_timestamp} ${cluster_name}: Resource operation '${CRM_alert_task}${CRM_alert_interval}' for '${CRM_alert_rsc}' on '${CRM_alert_node}' ${CRM_alert_desc}${CRM_alert_target_rc}"
        fi  

        case ${CRM_alert_desc} in
          Cancelled) 
            strSummary="${CRM_alert_timestamp} ${cluster_name}: Resource operation '${CRM_alert_task}${CRM_alert_interval}' for '${CRM_alert_rsc}' on '${CRM_alert_node}': ${CRM_alert_desc}${CRM_alert_target_rc}"
          ;;
        esac
      fi
      ;;
    *)
      strSummary="${CRM_alert_timestamp} ${cluster_name}: Unhandled $CRM_alert_kind alert"
      ;;
  esac
fi


if [ ! -z "${strSummary}" ]; then
  strNotice="${strSummary}::${strNotice}"
  logger  ${optSyslogServer} ${optSyslogPort} -p ${RHA_syslog_facility}.${RHA_syslog_priority} ${optTag} "${RHA_syslog_tag}:(${RHA_syslog_facility}.${RHA_syslog_priority}) :: $( echo \" ${strNotice}\" | tr '\n' ' ')" 
  echo -e "strNotice value: \n {\n${strNotice}\n}" 1>&2
fi

exec 2>&-
