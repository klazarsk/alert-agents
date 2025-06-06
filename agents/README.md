# alert-agents

# alert_syslog.sh: Sample Pacemaker Syslog Alert Agent 

## Derived from alert_smtp.sh in the pacemaker package

 Adapted from alert_smtp.sh from the pacemaker package 
 by klazarsk@redhat.com for one of our users, May 2025

 Compare to alert_smtp.sh.sample to see how trivial this was to adapt. 
 The complication arises in filtering and steering the alerts for
 users who want to the filtering done at the origin service rather
 than on the syslog aggregator.

 You can improve upon the granularity of the alerting by matching 
 substrings in variables such as CRM_alert_desc and testing other
 variables and creating more complex cases to drive filtering and 
 turning individual alerts off and on. In this user's case, they 
 only wanted fencing notices and wanted it to be filtered at the 
 the alert generation stage rather than at the aggregator.
 
 In this example, we override the user-defined priority setting in
 cases where the services actually fail to start, in which case we
 set the script to flag the notices as `crit`
 
## Sample configuration (cib fragment in xml notation)

```
  <alert id="alert_webcluster1" path="/var/lib/pacemaker/alert_syslog.sh">
     <instance_attributes id="alert_webcluster1-instance_attributes">
       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_facility" name="RHA_syslog_facility" value="local2"/>
       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_port" name="RHA_syslog_port" value="2514"/>
       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_priority" name="RHA_syslog_priority" value="err"/>
       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_proto" name="RHA_syslog_proto" value="tcp"/>
       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_server" name="RHA_syslog_server" value="nodea.private.example.com"/>
       <nvpair id="alert_webcluster1-instance_attributes-RHA_syslog_tag" name="RHA_syslog_tag" value="FIRSTWEB"/>
     </instance_attributes>
  </alert>
```

## Supported agent options 
      
### RHA_syslog_server

Either a resolvable hostname or the IP address of your syslog server. If this
is omitted from the alert definition, the alert agent will assume that it will
get routed to the syslog daemon on localhost.

### RHA_syslog_port

This is the port the syslog aggregator is listening on.

RHA_syslog_port - this only applies if also specifying the RHA_syslog_server. If not 
provided, the requests should be routed to port 514.

### RHA_syslog_protocol

The script will assume tcp in the interest of security, and applies only if 
RHA_syslog_server variable is initialized.

### RHA_syslog_facility

This is to specify the syslog alert facility `man 3 syslog`

**Examples**

    LOG_AUTH, AUTHPRIV, LOG_LOCAL0, local5, etc.

    LOCAL0 - LOCAL7 are for custom use, for alerting mechanisms such as this script

    Note it is typical for sysadmins to specify these in lower case and not include the LOG_ prefix:

    LOG_AUTH ≌ auth, and local0 ≌ LOG_LOCAL0

### RHA_syslog_priority

### This is to specify the syslog alert log level `man 3 syslog`

**Examples**

        LOG_EMERG, LOG_ALERT, LOG_CRIT, ERR, WARNING, NOTICE, INFO, DEBUG

        Note it is typical for sysadmins to specify these in lower case and not include the LOG_ prefix:
        
        LOG_CRIT ≌ crit, and LOG_ERR ≌ err

### RHA_syslog_tag

    This is the syslog "tag" attribute which is supported by many aggreggators and by `logger`, useful 
    for driving more precise filtering. For example, to direct error routing for different service groups


### RHA_syslog_proto
   
This is the protocol syslog is listening for; valid values are tcp or udp 

_See `man 3 syslog` for detailed info on syslog facility and priority_

   
If you've worked with syslog.conf files before you'll recall it's normal for 
the facility to be specified in all lower case, and the LOG_ prefix to be 
dropped. So these examples would be typical:

**Sample entries for /etc/rsyslog.conf**
```   
local2.*    /var/log/pacemaker/syslog # Capture ALL notices sent to LOG_LOCAL2 to /var/log/pacemaker/syslog

local2.err  /var/log/pacemaker/errorlog # capture all notices of ERR or greater priority to /var/log/paceemaker/errorlog
```
   
## Installation

### Place alert_syslog.sh in pacemaker lib dirctory (typically /var/lib/pacemaker)

```
scp alert_syslog.sh root@host:/var/lib/pacemaker/alert_syslog.sh
```

### chown it the pacemaker user and group (typically hacluster:haclient on a default install)

```
chmod 0750 /var/lib/pacemaker/alert_syslog.sh
```

### Create the alert

For this example, our syslog aggregator is fqdn.syslog.example.com, the 
port is 2514, the protocol is tcp, the syslog facility we want to use is 
local2, the syslog priority is err, the scope of the logs is limited to 
fencing and nodes, and the tag is webcluster1: 

```
pcs alert create id=alert_webcluster1 path=/var/lib/pacemaker/alert_syslog.sh options \
RHA_syslog_facility=local2 RHA_syslog_priority=err RHA_syslog_tag=webcluster1 \
RHA_alert_server=fqdn.syslog.example.com RHA_syslog_protocol=tcp RHA_syslog_port=2514 \
RHA_alert_kinds="fencing,nodes"
```


### Adjust syslog alert scoping globally

If you know you want to limit the scope of syslog alerts globally across all service
groups or your entire fleet, you can omit the RHA_alert_kinds edit the optAlertKinds 
line of the alert agent script. For example, this limits any alerts by this agent 
strictly to fencing alerts:

```
# optAlertKinds="fencing,node,resource,attribute"
optAlertKinds="fencing"
```

Note that the provided agent does NOT exclude unhandled alerts; unhandled alerts that 
are not of type fencing, node, resource, or attributes, WILL be generated and forwarded
to your syslog server.

# alert_syslog_debug.sh

## About 

This script is simply a wrapper which is installed when debugging, purely to enable
a debug log for development purposes to help you more rapidly customize the solution.

Do not use this in production because the log will grow rather quickly. The code listing is extremely simple:

```
#!/bin/bash

bash -x /var/lib/pacemaker/alert_smtp_actual.sh 2>> /var/log/pacemaker/alert_smtp.debug
```

The reason we took this approach is that the production alert agent requires no modification to enable debug mode, which reduces the chance of introducing an error. The debug script uses bash to invoke the alert agent with the -x option which enables debug output, which is then redirected to a log file located in /var/log/pacemaker. 

## Installation 

_On each node:_

### Place the debug script at the location where the production agent belongs 

`scp alert_syslog_debug.sh host@node:/var/lib/pacemaker/alert_syslog.sh`

### Place the alert agent in the usual directory, but alternate filename

`scp alert_syslog.sh host@node:/var/lib/pacemaker/alert_syslog_actual.sh`

### Set the ownership and permission on the files

```
chown hacluster:haclient /var/lib/pacemaker/alert_syslog{.sh,_actual.sh}
chmod 0750 /var/lib/pacemaker/alert_syslog{.sh,_actual.sh}
```

### Set up the alert agent 

_Follow the usual instructions; this debug wrapper can work dropped in place over an already-running alert_syslog.sh agent._

# alert_smtp.sh

This is an adaptation of the original alert_agent.smtp.sample in the pacemaker 
package, extended to enable scoping of alert types similar to what the above alert_syslog.sh
agent is doing. In the interest of fostering good practices, backtick-notation 
subshell notation has been replaced with the more modern `$( )` notation as the 
modern notation handles nested subshell invocations far more gracefully.

# alert_smtp_debug.sh

This script is simply a wrapper which is installed when debugging, purely to enable
a debug log for development purposes to help you more rapidly customize the solution.
Do not use this in production.

# alert_smtp_debug.sh

## About 

As with the syslog debug wrapper script, this script is simply a wrapper which is 
installed when debugging, purely to enablea debug log for development purposes to 
help you more rapidly customize the solution.

Do not use this in production because the log will grow rather quickly. The code listing is extremely simple:

```
#!/bin/bash

bash -x /var/lib/pacemaker/alert_smtp_actual.sh 2>> /var/log/pacemaker/alert_smtp.debug
```

The reason we took this approach is that the production alert agent requires no modification to enable debug mode, which reduces the chance of introducing an error. The debug script uses bash to invoke the alert agent with the -x option which enables debug output, which is then redirected to a log file located in /var/log/pacemaker. 

## Installation 

_On each node:_

### Place the debug script at the location where the production agent belongs 

`scp alert_smtp_debug.sh host@node:/var/lib/pacemaker/alert_smtp.sh`

### Place the alert agent in the usual directory, but alternate filename

`scp alert_smtp.sh host@node:/var/lib/pacemaker/alert_smtp_actual.sh`

### Set the ownership and permission on the files

```
chown hacluster:haclient /var/lib/pacemaker/alert_smtp{.sh,_actual.sh}
chmod 0750 /var/lib/pacemaker/alert_smtp{.sh,_actual.sh}
```

### Set up the alert agent 

_Follow the usual instructions; this debug wrapper can work dropped in place over an already-running alert_smtp.sh agent._
