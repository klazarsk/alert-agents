alert_smtp.sh 5 "July 2025" alert_smtp.sh "User Manual"
==================================================

# NAME

alert_smtp.sh - Sample SMTP alert agent for pacemaker with filtering

# SYNOPSIS


**pcs alert create id=**_filtered-smtp_ \
 **path=/var/lib/pacemaker/alert\_smtp.sh** **options** \
 **email\_sender=**_noreply@example.com_ [**RHA\_alert\_kind=**"_fencing_,_node_,_resource_"]


# DESCRIPTION

**alert_smtp.sh** is a sample alert agent which implements filtering by
 matching the value of pacemaker's CRM_alert_kind variable that is set when an 
 alert is generated. This agent was built for a client who wished to send 
 receive alerts whenever resources are relocated,.

By default, the email client the script expects is sendmail.

# OPTIONS

**path=**_/var/lib/pacemaker/alert\_smtp.sh_

This is the path to the alert agent on the nodes' filesystems - the path should
 match to wherever you've installed the file. By default they're placed in 
 /usr/share/pacemaker/alerts/ when installing from rpm, and they're usually 
 manually placed in /var/lib/pacemaker/ for runtime when the agents are 
 configured.

**email\_sender=**_user@example.com_

This is what the agent will use as the "FROM" field on email alerts

**RHA\_alert\_kind=**_"fencing,node,resource"_

This option sets the RHA_alert_kind variable in the alert_smtp.sh alert 
 agent, to specify the criteria on which alerts to allow to send to the email 
 recipient.

Note that otherwise-unspecified alert types will be sent to the recipient 
 regardless of the filter specification.

**fencing**

These alerts are generated when a node is fenced, whether automatically or 
 automatically.

**node**

These alerts when a node is suspended, unsuspended, rebooted, joins the 
 cluster, etc. 
    
**resource**

These alerts are generated when a resource is started, stopped, or fails to 
 start. 
    
# INSTALLATION

Place alert_syslog.sh in pacemaker lib dirctory (typically /var/lib/pacemaker)
 chown it the pacemaker user and group (typically hacluster:haclient on a 
 default install); chmod it 0750


 ~]# **cp /usr/share/pacemaker/alerts/alert\_smtp.sh.sample \
  /var/lib/pacemaker/alert\_smtp.sh**
 ~]# chown hacluster:haclient /var/lib/pacemaker/alert\_smtp.sh
 ~]# chmod 0750 /var/lib/pacemaker/alert\_smtp.sh

 
Proceed to EXAMPLES section for alert configuration

# EXAMPLES

The following example will send alert emails whenever a node is fenced and  
 unhandled alerts, but not node or resource alerts. The agent will send the 
 alert emails to sysad@example.com


 ~]# **pcs alert create id=**_filtered-smtp_ \
 **path=/var/lib/pacemaker/alert\_smtp.sh options** \
 **email\_sender=**_noreply@example.com_ **RHA\_alert\_kind=**_"fencing"_
 ~]# **pcs alert recipient add** _filtered-smtp_ \
 **value=**_sysad@example.com@example.com_
 ~]# 


This example will send alerts of kind node, resource, and "unhandled"
 alerts, but not fencing notifications, and the alert emails will go to 
 monitor@example.com:


 ~]# **pcs alert create id=**_filtered-smtp_ \
 **path=/var/lib/pacemaker/alert\_smtp.sh options** \
 **email\_sender=**_noreply@example.com_ **RHA\_alert\_kind=**_"node,resource"_
 ~]# **pcs alert recipient add **_filtered-smtp_ \
**value=**_monitor@example.com  
 ~]# 


# HISTORY
July 2025, Originally compiled by Kimberly Lazarski (klazarsk@redhat.com)
