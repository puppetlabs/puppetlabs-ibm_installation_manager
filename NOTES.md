# IBM Installation Manager Notes

## Known Issues

### It's a fragile piece of something

If a "install.xml" file is not present in the source directory, the thing will
fail, so don't overwrite it.  You can specify the options on the command-line,
I think.

```
Debug: Exec[Install IBM Installation Manager](provider=posix): Executing '/vagrant/ibm/IM/installc -acceptLicense -s -log /tmp/IM_install.20151301_040540.log.xml'
Debug: Executing '/vagrant/ibm/IM/installc -acceptLicense -s -log /tmp/IM_install.20151301_040540.log.xml'
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns: ERROR: Failed to read response file "/vagrant/ibm/IM/install.xml".
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns: 00:01.24 ERROR [main] com.ibm.cic.agent.core.application.HeadlessApplication run
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:   java.io.FileNotFoundException: /vagrant/ibm/IM/install.xml (No such file or directory)
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:   java.io.FileNotFoundException: /vagrant/ibm/IM/install.xml (No such file or directory)
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:     at java.io.FileInputStream.<init>(FileInputStream.java:123)
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:     at com.ibm.cic.agent.core.internal.commands.Input.load(Input.java:215)
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:     at com.ibm.cic.agent.core.internal.commands.Input.load(Input.java:693)
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:     at com.ibm.cic.agent.core.application.HeadlessApplication.run(HeadlessApplication.java:452)
Notice: /Stage[main]/Ibm_installation_manager/Exec[Install IBM Installation Manager]/returns:     ...
```

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

This isn't an issue with Puppet - it's IBM's shitty software.
