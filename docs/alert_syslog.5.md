 alert_syslog.sh 5 "July 2025" alert_syslog.sh "User Manual"
==================================================

# NAME

 alert_syslog.sh - Sample Syslog alert agent for pacemaker with filtering

# SYNOPSIS

 pcs alert create id=alert_cluster  \
 path=**/var/lib/pacemaker/alert_syslog.sh**  options \
 **RHA_syslog_facility**=local2 **RHA_syslog_priority**=err \
 **RHA_syslog_tag**=SERVICEGROUP **RHA_alert_server**=syslog.example.com

# DESCRIPTION

**alert_syslog.sh** provides a means to filter pacemaker syslog alerts at the 
 source and direct them to the desired syslog server without having to tweak 
 your syslog or rsyslog configuration on the cluster nodes.
 
 Filtering, syslog target, facility, priority, and syslog tag are all driven by
 variables which are set by PCS alert options

# OPTIONS

**path=**_/var/lib/pacemaker/alert_syslog.sh_

 This is the path to the alert agent on the nodes' filesystems - the path 
 should match to wherever you've installed the file. By default they're placed
 in /usr/share/pacemaker/alerts/ when installing from rpm, and they're usually
 manually placed in /var/lib/pacemaker/ for runtime when the agents are 
 configured.

**RHA_syslog_facility=**_facility_

This is in relation to the the syslog alert facility (man 3 syslog)

 Syslog _facility_ Examples:

  LOG_AUTH, AUTHPRIV, LOG_LOCAL0, local5, etc.
  LOCAL0 - LOCAL7 are for custom use, for alerting mechanisms such as 
  this script

**RHA_syslog_priority=**_RHA_syslog_priority_

This is in relation to the syslog priority level (man 3 syslog)

 Syslog _priority_ examples:
 LOG_EMERG, LOG_ALERT, LOG_CRIT, ERR, WARNING, NOTICE, INFO, DEBUG

(there are more facilities and levels than included above)
   
If you've worked with syslog.conf files before you'll recall it's normal for 
 the facility to be specified in all lower case, and the LOG_ prefix to be 
 dropped. So these examples would be typical:

local2.*    /var/log/pacemaker/syslog # Capture ALL notices sent to LOG_LOCAL2
 to /var/log/pacemaker/syslog

local2.err  /var/log/pacemaker/errorlog # capture all notices of ERR or 
 greater priority to /var/log/paceemaker/errorlog
   
**RHA_syslog_tag=**_tag_

This is in relation to the syslog _tag_ level (_man 5 rsyslog.conf, man 1 logger_)

This is the syslog "tag" attribute which is supported by many aggreggators, 
 useful for additional filtering
         
**RHA_syslog_port=**_port_

This is the port the syslog aggregator is listening on if it's anything other
 than the standard syslog port of _514_
                  
         
**RHA_syslog_proto=**_protocol_

This is the protocol syslog is listening for; valid values are _tcp_ or _udp_ 
         
**RHA_alert_kind=**_"fencing,node,resource"_

This option sets the RHA_alert_kind variable in the alert_syslog alert
 agent, to specify the criteria on which alerts to allow to send to the email
 recipient.

Note that otherwise-unspecified alert types will be sent to the recipient 
 regardless of the filter specification.

_fencing_

These alerts are generated when a node is fenced, whether automatically or 
 automatically.

_node_

These alerts when a node is suspended, unsuspended, rebooted, joins the 
 cluster, etc. 
    
_resource_
    
These alerts are generated when a resource is started, stopped, or fails to
 start. 

# INSTALLATION

Place alert_syslog.sh in pacemaker lib dirctory (typically /var/lib/pacemaker/)
 chown it the pacemaker user and group (typically hacluster:haclient on a 
 default install); chmod it 0750

```
[root@nodea ~]# cp /usr/share/pacemaker/alerts/alert_syslog.sh.sample \
  /var/lib/pacemaker/alart_syslog.sh
[root@nodea ~]# chown hacluster:haclient /var/lib/pacemaker/alert_syslog.sh
[root@nodea ~]# chmod 0750 /var/lib/pacemaker/alert_syslog.sh
```

Proceed to EXAMPLES section for alert configuration

# EXAMPLES

Example which sends all alerts:

```
~] # pcs alert create id=alert_webcluster1 path=/var/lib/pacemaker/alert_syslog.sh
 options RHA_syslog_facility=local2 RHA_syslog_priority=err \
 RHA_syslog_tag=webcluster1 RHA_alert_server=fqdn.syslog.example.com
```

Example which sends only fencing and unhandled alerts:

```
~] # pcs alert create id=alert_webcluster1 path=/var/lib/pacemaker/alert_syslog.sh
 options RHA_syslog_facility=local2 RHA_syslog_priority=err \
 RHA_syslog_tag=webcluster1 RHA_alert_server=fqdn.syslog.example.com \
 RHA_alert_kind="fencing"
```

This example will send alerts of kind node, resource, and "unhandled"
 alerts, but not fencing notifications:
 
```
~] # pcs alert create id=alert_webcluster1 path=/var/lib/pacemaker/alert_syslog.sh
 options RHA_syslog_facility=local2 RHA_syslog_priority=err \
 RHA_syslog_tag=webcluster1 RHA_alert_server=fqdn.syslog.example.com \
 RHA_alert_kind="node,resource"
```


# HISTORY
July 2025, Originally compiled by Kimberly Lazarski (klazarsk@redhat.com)
