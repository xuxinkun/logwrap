# logwrap

A shell script used to direct the stdout/stderr to the file.

Many info of the program will be printed to stdout/stderr. With logwrap, the info from stdout/stderr will be directed to the file for easy reading.

Logwrap provides many env params as follows. 


| env                      | usage                                                        | default                    |
| ------------------------ | ------------------------------------------------------------ | -------------------------- |
| LOGWRAP_ENABLE_LOGWRAP   | whether enable logwrap feature.                              | true                       |
| LOGWRAP_ENABLE_STDERR    | whether direct stderr to the log file.                       | true                       |
| LOGWRAP_ENABLE_LOGROTATE | whether enable logrotate feature.                            | true                       |
| LOGWRAP_LOGROTATE_ROTATE | rotate param of logrotate configuration.                     | 4                          |
| LOGWRAP_LOGROTATE_CYCLE  | cycle param of logrotate configuration, must be either of daily, weekly. | daily                      |
| LOGWRAP_LOGROTATE_SIZE   | minsize param of logroate configuration.                     | 100M                       |
| LOGWRAP_COMMAND          | command wanted to exec.                                      | $1                         |
| LOGWRAP_FILE             | the logfile location.                                        | /home/$LOGWRAP_COMMAND.log |


# usage

## with docker

`logwrap.sh` can be put on the `entrypoint`. The actual command should be put ont the `command`. 

The example Dockerfile is provided in the project. And the entrypoint is set to `/logwrap.sh`. If the command `echo hello world` wants to be executed. Just execute as follows.

```
[root@localhost logwrap]# docker build -t logwrap .
[root@localhost logwrap]# docker run -it -v /home:/home -d logwrap echo hello world
bcb519361ada5f4d0872d73281e775407bfa88bac9005a6429b94f236b7b9e49
[root@localhost logwrap]# cat /home/echo.log 
hello world
```

## with shell

Just use `./logwrap.sh + {command}`. For example.

```
[root@localhost logwrap]# ./logwrap.sh echo hello world
LOGWRAP will direct stdout to  /home/echo.log
LOGWRAP ensure log dir  /home
LOGWRAP enable logrotate.
LOGWRAP found crond alreay running.
LOGWRAP generate logrotate file.
LOGWRAP_COMMAND is  echo
LOGROATE_FILE is /etc/logrotate.d/echo
/etc/logrotate.d/echo alreay exist.
    /home/echo.log {
            daily
            missingok
            rotate 4
            compress
            delaycompress
            dateext
            dateformat %Y-%m-%d-%s
            copytruncate
            size 100M
    }
exec command: echo hello world
--------------------
[root@localhost logwrap]# cat /home/echo.log 
hello world
```

