#!/bin/sh
#
#############################################################
#
# Copyright 2016-2021 the Pacemaker project contributors
#
# The version control history for this file may have further details.
#
# This source code is licensed under the GNU General Public License version 2
# or later (GPLv2+) WITHOUT ANY WARRANTY.
#
#############################################################
#
# Sample configuration (cib fragment in xml notation)
# ================================
# <configuration>
#   <alerts>
#     <alert id="smtp_alert" path="/path/to/alert_smtp">
#       <instance_attributes id="config_for_alert_smtp">
#         <nvpair id="cluster_name" name="cluster_name" value=""/>
#         <nvpair id="email_client" name="email_client" value=""/>
#         <nvpair id="email_sender" name="email_sender" value=""/>
#       </instance_attributes>
#       <recipient id="smtp_destination" value="admin@example.com"/>
#     </alert>
#   </alerts>
# </configuration>

#############################################################
#
# DEBUG
# Uncomment these lines for debug trace logging
#
# set -xv
# exec 2 > /var/log/pacemaker-alert_smtp-debug.log
#
#############################################################
#
# Explicitly list all environment variables used, to make static analysis happy

: ${CRM_alert_version:=""}
: ${CRM_alert_recipient:=""}
: ${CRM_alert_timestamp:=""}
: ${CRM_alert_kind:=""}
: ${CRM_alert_node:=""}
: ${CRM_alert_desc:=""}
: ${CRM_alert_task:=""}
: ${CRM_alert_rsc:=""}
: ${CRM_alert_attribute_name:=""}
: ${CRM_alert_attribute_value:=""}

#############################################################
# Pass "RHA_alert_kinds" as an option at the pcs alert create
# stage, otherwise if the variable is null/not set by alert 
# options assignment, take the value in this stanza
# Take alert types out of optAlertKinds to disable alerts
  if [ -z ${RHA_alert_kinds} ]; then
  
    # ALL alerts (unfiltered)
    optAlertKinds="fencing,node,resource"
    # ONLY fencing alerts:
    # optAlertKinds="fencing"
  
  else
   
    optAlertKinds="${RHA_alert_kinds}"
  
  fi 
#
#############################################################
if tty -s ;
then

otagBold="\033[1m";
ctag="\033[0m";
otagRed='\033[0;31m'
otagRevRed='\e[0;101m'
otagUline="\e[4m"
otagItal="\e[3m"
    echo -e "${otagBuld}Your command line:${ctag}\n";
    echo -e "\t $0 $@ \n";
    echo -e "\t\033[0;31mThis alert agent is intended to be called from pacemaker, not from"
    echo -e "\tan interactive shell.${ctag}\n"

    echo -e "${otagBold}NAME${ctag}\n"
    echo -e "\talert_smtp.sh - Sample SMTP alert agent for pacemaker with filtering\n\n"

    echo -e "${otagBold}SYNOPSIS${ctag}\n"
    echo -e "\t~] $ pcs alert create id=filtered-smtp \ "
    echo -e "\t${otagBold}path=${ctag}/var/lib/pacemaker/alert_smtp.sh options \ "
    echo -e "\t${otagBold}email_sender=${ctag}noreply@example.com ${otagBold}RHA_alert_kind=${ctag}\"fencing\" \n"

    echo -e "${otagBold}DESCRIPTION${ctag}\n"
    echo -e "\t${otagBold}alert_smtp.sh${ctag} is a sample alert agent which implements filtering by"
    echo -e "\t matching the value of pacemaker's CRM_alert_kind variable that is set when an "
    echo -e "\t alert is generated. This agent was built for a client who wished to send "
    echo -e "\t receive alerts whenever resources are relocated.\n"
    echo -e "\tBy default, the email client the script expects is sendmail.\n"

    echo -e "${otagBold}OPTIONS${ctag}\n"
    echo -e "\t${otagBold}path=${ctag}_/var/lib/pacemaker/${otagBold}alert_smtp.sh${ctag}"
    echo -e "\tThis is the path to the alert agent on the nodes' filesystems - the path should"
    echo -e "\tmatch to wherever you've installed the file. By default they're placed in"
    echo -e "\t/usr/share/pacemaker/alerts/ when installing from rpm, and they're usually"
    echo -e "\tmanually placed in /var/lib/pacemaker/ for runtime when the agents areE"
    echo -e "\tconfigured.\n"
    echo -e "\t${otagBold}email_sender=${ctag}user@example.com"
    echo -e "\tThis is what the agent will use as the ${otagItal}FROM${ctag} field on email alerts\n"

    echo -e "\t${otagBold}RHA_alert_kind=${ctag}\"${otagItal}fencing,node,resource${ctag}\""
    echo -e "\tThis option sets the RHA_alert_kind variable in the alert_smtp.sh alert"
    echo -e "\tagent, to specify the criteria on which alerts to allow to send to the email"
    echo -e "\trecipient.\n"
    echo -e "\tNote that otherwise-unspecified alert types will be sent to the recipient"
    echo -e "\tregardless of the filter specification.\n"

    echo -e "\t${otagUline}fencing${ctag}"
    echo -e "\tThese alerts are generated when a node is fenced, whether automatically or"
    echo -e "\tautomatically.\n"
    echo -e "\t${otagUline}node${ctag}"
    echo -e "\tThese alerts when a node is suspended, unsuspended, rebooted, joins the"
    echo -e "\tcluster, etc.\n"
    echo -e "\t${otagUline}resource${ctag}"
    echo -e "\tThese alerts are generated when a resource is started, stopped, or fails to"
    echo -e "\tstart. \n"

    echo -e "\t${otagBold}INSTALLATION${ctag}\n"
    echo -e "\tPlace alert_syslog.sh in pacemaker lib dirctory (typically /var/lib/pacemaker "
    echo -e "\tchown it the pacemaker user and group (typically hacluster:haclient on a "
    echo -e "\tdefault install); chmod it 0750 \n"

    echo -e "\t\t~]# cp /usr/share/pacemaker/alerts/${otagBold}alert_smtp.sh.sample${ctag} \ "
    echo -e "\t\t  /var/lib/pacemaker/${otagBold}alert_smtp.sh${ctag} "
    echo -e "\t\t~]# chown hacluster:haclient /var/lib/pacemaker/${otagBold}alert_smtp.sh${ctag} "
    echo -e "\t\t~]# chmod 0750 /var/lib/pacemaker/${otagBold}alert_smtp.sh${ctag} \n"
    echo -e "\t\tProceed to EXAMPLES section for alert configuration\n"

    echo -e "${otagBold}EXAMPLES${ctag} \n"
    echo -e "\tThe following example will send alert emails whenever a node is fenced and "
    echo -e "\tunhandled alerts, but not node or resource alerts. The agent will send the"
    echo -e "\talert emails to sysad@example.com\n"

    echo -e "\t\t~]# pcs alert create id=filtered-smtp \ "
    echo -e "\t\t  ${otagBold}path=${ctag}/var/lib/pacemaker/${otagBold}alert_smtp.sh${ctag} options \ "
    echo -e "\t\t  ${otagBold}email_sender=${ctag}noreply@example.com ${otagBold}RHA_alert_kind=${ctag}\"${otagItal}fencing${ctag}\" \n"

    echo -e "\tThis example will send alerts of kind node, resource, and "unhandled" "
    echo -e "\talerts, but not fencing notifications, and the alert emails will go to  "
    echo -e "\tmonitor@example.com \n"

    echo -e "\t\t~]# pcs alert create id=filtered-smtp \ "
    echo -e "\t\t  path=/var/lib/pacemaker/${otagBold}alert_smtp.sh${ctag} options \ "
    echo -e "\t\t  ${otagBold}email_sender${ctag}=noreply@example.com ${otagBold}RHA_alert_kind=${ctag}\"${otagItal}node,resource${ctag}\" "
    echo -e "\t\t~]# pcs alert recipient add filtered-smtp \ "
    echo -e "\t\t value=monitor@example.com \n"

exit 1 
fi

email_client_default="sendmail"
email_sender_default="hacluster"
email_recipient_default="root"

: ${email_client=${email_client_default}}
: ${email_sender=${email_sender_default}}
email_recipient="${CRM_alert_recipient-${email_recipient_default}}"

node_name=$(uname -n)
cluster_name=$(crm_attribute --query -n cluster-name -q)
email_body=$(env | grep CRM_alert_ ; env | grep RHA_[as]; echo -e "\n note: Email notifications limited to alert types: ${optAlertKinds}\n")

if [ ! -z "${email_sender##*@*}" ]; then
    email_sender="${email_sender}@${node_name}"
fi

if [ ! -z "${email_recipient##*@*}" ]; then
    email_recipient="${email_recipient}@${node_name}"
fi

if [ -z ${CRM_alert_version} ]; then
    email_subject="Pacemaker version 1.1.15 or later is required for alerts"
else
  case ${CRM_alert_kind} in
    node)
      if [[ $optAlertKinds == *"node"* ]]; then
        email_subject="${CRM_alert_timestamp} ${cluster_name}: Node '${CRM_alert_node}' is now '${CRM_alert_desc}'"
      fi
      ;;
    fencing)
      if [[ $optAlertKinds == *"fencing"* ]]; then
        email_subject="${CRM_alert_timestamp} ${cluster_name}: Fencing ${CRM_alert_desc}"
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

        case ${CRM_alert_desc} in
          Cancelled) ;;
          *)
              email_subject="${CRM_alert_timestamp} ${cluster_name}: Resource operation '${CRM_alert_task}${CRM_alert_interval}' for '${CRM_alert_rsc}' on '${CRM_alert_node}': ${CRM_alert_desc}${CRM_alert_target_rc}"
          ;;
        esac
      fi
      ;;
    *)
        email_subject="${CRM_alert_timestamp} ${cluster_name}: Unhandled $CRM_alert_kind alert"
        ;;

  esac
fi

if [ ! -z "${email_subject}" ]; then
    case $email_client in
        # This sample script supports only sendmail for sending the email.
	# Support for additional senders can easily be added by adding
	# new cases here.
        sendmail)
            sendmail -t -r "${email_sender}" <<__EOF__
From: ${email_sender}
To: ${email_recipient}
Return-Path: ${email_sender}
Subject: ${email_subject}

${email_body}
__EOF__
            ;;
        *)
            ;;
    esac
fi

exec 2>&-
