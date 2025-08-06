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

otagBold="\e[1m";
ctag="\e[0m";
otagRed='\e[0;31m'
otagRevRed='\e[0;101m'
otagUline="\e[4m"
otagItal="\e[3m"
    echo -e "${otagBuld}Your command line:${ctag}\n";
    echo -e "\t $0 $@ \n";
    echo -e "\t\033[0;31mThis alert agent is intended to be called from pacemaker, not from"
    echo -e "\tan interactive shell.${ctag}\n"

    echo -e "${otagBold}NAME${ctag}\n"
    echo -e "\t\n\n"

    echo -e "${otagBold}SYNOPSIS${ctag}\n"
    echo -e "\t~] $ pcs alert create id=alert_cluster \ "
    echo -e "\t${otagBold}path=${ctag}/var/lib/pacemaker/alert_syslog.sh options \ "
    echo -e "\t${otagBold}RHA_syslog_facility=${ctag}local2 ${otagBold}RHA_syslog_priority=${ctag}err \n"
    echo -e "\t${otagBold}RHA_syslog_tag=${ctag}SERVICEGROUP ${otagBold}RHA_alert_server=${ctag}syslog.example.com \n"

    echo -e "${otagBold}DESCRIPTION${ctag}\n"
    echo -e "\t${otagBold}alert_syslog.sh${ctag} provides a means to filter pacemaker syslog alerts at the"
    echo -e "\tsource and direct them to the desired syslog server without having to tweak"
    echo -e "\tyour syslog or rsyslog configuration on the cluster nodes.\n"
    echo -e "\tFiltering, syslog target, facility, priority, and syslog tag are all driven by "
    echo -e "\tvariables which are set by PCS alert options.\n"

    echo -e "${otagBold}OPTIONS${ctag}\n"

    echo -e "\t${otagBold}path=${ctag}var/lib/pacemaker/alert_syslog.sh\n"
    echo -e "\tThis is the path to the alert agent on the nodes' filesystems - the path "
    echo -e "\tshould match to wherever you've installed the file. By default they're placed "
    echo -e "\tin /usr/share/pacemaker/alerts/ when installing from rpm, and they're usually "
    echo -e "\tmanually placed in /var/lib/pacemaker/ for runtime when the agents are  "
    echo -e "\tconfigured.\n"

    echo -e "\t${otagBold}RHA_syslog_facility=${ctag}${otagItal}facility${ctag}"
    echo -e "\tThis is in relation to the the syslog alert facility (${otagItal}man 3 syslog${ctag})\n"
    echo -e "\tSyslog ${otagItal}facility${ctag} Examples:"
    echo -e "\tLOG_AUTH, AUTHPRIV, LOG_LOCAL0, local5, etc."
    echo -e "\tLOCAL0 - LOCAL7 are for custom use, for alerting mechanisms such as "
    echo -e "\tthis script.\n"

    echo -e "\t${otagBold}RHA_syslog_priority=${ctag}RHA_syslog_priority"
    echo -e "\tThis is in relation to the syslog priority level (man 3 syslog)\n"
    echo -e "\tSyslog ${otagItal}priority${ctag} examples: "
    echo -e "\tLOG_EMERG, LOG_ALERT, LOG_CRIT, ERR, WARNING, NOTICE, INFO, DEBUG\n"

    echo -e "\t(there are more facilities and levels than mentioned above)"
    echo -e "\tIf you've worked with syslog.conf files before you'll recall it's normal for"
    echo -e "\tthe facility to be specified in all lower case, and the ${otagItal}LOG_${ctag} prefix to be "
    echo -e "\tdropped. So these examples would be typical:\n"
    echo -e "\tlocal2.*    /var/log/pacemaker/syslog # Capture ALL notices sent to LOG_LOCAL2"
    echo -e "\t  to /var/log/pacemaker/syslog "
    echo -e "\tlocal2.err  /var/log/pacemaker/errorlog # capture all notices of ERR or"
    echo -e "\t  greater priority to /var/log/paceemaker/errorlog\n"
    echo -e "\t${otagBold}RHA_syslog_tag=${ctag}tag"

    echo -e "\tThis is in relation to the syslog ${otagItal}tag${ctag}  (${otagItal}man 5 rsyslog.conf${ctag}, ${otagItal}man 1"
    echo -e "\tlogger${ctag}). This is usually the name of the process, and by default often"
    echo -e "\tThis is the syslog "tag" attribute which is supported by many aggreggators, "
    echo -e "\tuseful for additional filtering\n"

    echo -e "\t${otagBold}RHA_syslog_port=${ctag}${otagItal}port${ctag}"
    echo -e "\tThis is the port the syslog aggregator is listening on if it's anything other"
    echo -e "\tthan the standard syslog port ${otagItal}514${ctag}\n"

    echo -e "\t${otagBold}RHA_syslog_proto=${ctag}${otagItal}protocol${ctag}"
    echo -e "\tThis is the protocol syslog is listening for; valid values are ${otagItal}tcp${ctag} or ${otagItal}udp${ctag}\n"

    echo -e "\t${otagBold}RHA_alert_kind=${ctag}${otagItal}$\"fencing,node,resource\"${ctag}"
    echo -e "\tThis option sets the ${otagItal}RHA_alert_kind${ctag} variable in the alert_syslog alert"
    echo -e "\tagent, to specify the criteria on which alerts to allow to send to the email"
    echo -e "\trecipient.\n"
    echo -e "\tNote that otherwise-unspecified alert types will be sent to the recipient"
    echo -e "\tregardless of the filter specification.\n"
    echo -e "\t${otagItal}fencing${ctag}"
    echo -e "\tThese alerts are generated when a node is fenced, whether automatically or"
    echo -e "\tautomatically.\n"
    echo -e "\t${otagItal}node${ctag}"
    echo -e "\tThese alerts when a node is suspended, unsuspended, rebooted, joins the"
    echo -e "\tcluster, etc.\n"
    echo -e "\t${otagItal}resource${ctag}"
    echo -e "\tThese alerts are generated when a resource is started, stopped, or fails to"
    echo -e "\tstart.\n"

    echo -e "${otagBold}INSTALLATION${ctag}\n"
    echo -e "\tPlace alert_syslog.sh in pacemaker lib dirctory (typically /var/lib/pacemaker)"
    echo -e "\tchown it the pacemaker user and group (typically hacluster:haclient on a"
    echo -e "\tdefault install); chmod it 0750.\n"

    echo -e "\t${otagBold}EXAMPLES${ctag}\n"
    echo -e "\tExample which sends all alerts:\n"

    echo -e "\t\t~] # pcs alert create id=alert_webcluster1 \ "
    echo -e "\t\t  ${otagBold}path=${ctag}/var/lib/pacemaker/${otagBold}alert_syslog.sh${ctag} \ "
    echo -e "\t\toptions ${otagBold}RHA_syslog_facility=${ctag}local2 ${otagBold}RHA_syslog_priority=${ctag}err \ "
    echo -e "\t\t ${otagBold}RHA_syslog_tag=${ctag}webcluster1 ${otagBold}RHA_alert_server=${ctag}fqdn.syslog.example.com \ "
    echo -e "\t\t ${otagBold}RHA_alert_kind=${ctag}\"${otagItal}fencing${ctag}\" \n"

    echo -e "\tThis example will send alerts of kind ${otagItal}node${ctag}, ${otagBold}resource${ctag}, and \"unhandled\" "
    echo -e "\t alerts (alerts not matching the three categories), but not fencing "
    echo -e "\t notifications:\n"

    echo -e "\t\t~] # pcs alert create id=alert_webcluster1 ${otagBold} \ "
    echo -e "\t\t  path=${ctag}/var/lib/pacemaker/${otagItal}alert_syslog.sh${ctag} \ "
    echo -e "\t\t  options ${otagBold}RHA_syslog_facility=${ctag}local2 ${otagBold}RHA_syslog_priority=${ctag}err \ "
    echo -e "\t\t${otagBold}RHA_syslog_tag=${ctag}webcluster1 ${otagBold}RHA_alert_server=${ctag}fqdn.syslog.example.com \ "
    echo -e "\t\t${otagBold}RHA_alert_kind=${ctag}\"${otagItal}node,resource${ctag}\"\n"
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
