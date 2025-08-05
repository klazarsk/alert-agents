# alert-agents

These alert agents were recently enhanced by a Red Hat employee in response to 
a request of one of our clients, starting in May 2025. As a result of the 
extension of alert agents to include a syslog agent and ehancement go give 
the sample agents examples of how the alerts may be customize, a decision was 
reached to split the alert agents into their own project.

A help screen and man page have been added for each alert agent. Run the alert
agent in a shell with no arguments to view the help screen for that agent.

# alert_file.sh 

This alert agent will route alerts to a specific file location, driven by the
option logfile_destination. 

## Configurable options: 

logfile_destination

  This is the path to the log file 

 timestamp-format 
    This is the format for the timestamps (man date for format strings)
 
# alert_smtp.sh 

This alert will email alerts to a defined email recipient, driven by the 
"pcs alert recipient" configuration.

## Configurable options:

  RHA_alert_kind

    If filtering alerts, which kinds of alerts to send

  email_sender

    The "from" field of the email

# alert_snmp.sh 

  This alert agent will route alerts to a specific snmp sink, priority, with
  an optionally-configurable tag, and to a remote agggregator, if specified.

## Configurable options

  snmp_destination

    IP address or FQDN of the SNMP sink 

  trap_node_states
  
    which snmp states to send to snmp sink (default is "all")

# alert_syslog.sh 

  This alert agent will route alerts to a specific syslog facility, priority, 
  with an optionally-configurable tag, and to a remote agggregator, if 
  specified.

## Configurable options: 

 RHA_syslog_facility

   This is the syslog alert facility (man 3 syslog)
     Examples:
       LOG_AUTH, AUTHPRIV, LOG_LOCAL0, local5, etc.
       LOCAL0 - LOCAL7 are for custom use, for alerting mechanisms such as this 
       script

 RHA_syslog_priority
 
   This is the syslog log level (man 3 syslog)
     Examples:
       LOG_EMERG, LOG_ALERT, LOG_CRIT, ERR, WARNING, NOTICE, INFO, DEBUG

 RHA_syslog_tag
 
   This is the syslog "tag" attribute which is supported by many aggreggators, useful for additional filtering

 RHA_syslog_port
 
   This is the port the syslog aggregator is listening on 

 RHA_syslog_proto
 
   This is the protocol syslog is listening for; valid values are tcp or udp 



# Recent feature enhancements

You can improve upon the granularity of the alerting by matching 
substrings in variables such as CRM_alert_desc and testing other
variables and creating more complex cases to drive filtering and 
turning individual alerts off and on. In this user's case, they 
only wanted fencing notices and wanted it to be filtered at the 
the alert generation stage rather than at the aggregator.

In the example below, we've defined an SMTP alert agent which will email only
fencing and unhandled alerts, because this is the only event type the particular 
sysadmin wanted notifications on; note the "RHA_alert_kind" alert agent option: 

## Sample configuration (cib fragment in xml notation)

```
    <alerts>
      <alert id="filtered-smtp" path="/var/lib/pacemaker/alert_smtp.sh">
        <instance_attributes id="filtered-smtp-instance_attributes">
          <nvpair id="filtered-smtp-instance_attributes-email_sender" name="email_sender" value="noreply@example.com"/>
          <nvpair id="filtered-smtp-instance_attributes-RHA_alert_kind" name="RHA_alert_kind" value="fencing"/>
        </instance_attributes>
        <recipient id="filtered-smtp-recipient" value="student@workstation.lab.example.com"/>
      </alert>
    </alerts>

```
