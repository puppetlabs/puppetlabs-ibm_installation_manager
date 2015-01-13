# IBM Installation Manager Notes

## Known Issues

### Installation Manager returns 0 even if failed

```
[root@dmgr examples]# /vagrant/ibm/downloads/im/installc -acceptLicense -sP -log /tmp/IM_install.20151301_035917.log.xml;echo $?
libgcc_s.so.1 must be installed for pthread_cancel to work
JVMDUMP006I Processing dump event "abort", detail "" - please wait.
JVMDUMP032I JVM requested System dump using '/vagrant/modules/ibm_installation_manager/examples/core.20150113.040024.19642.0001.dmp' in response to an event
JVMPORT030W /proc/sys/kernel/core_pattern setting "|/usr/libexec/abrt-hook-ccpp %s %c %p %u %g %t e" specifies that the core dump is to be piped to an external program.  Attempting to rename either core or core.19652.

libgcc_s.so.1 must be installed for pthread_cancel to work
0
```
