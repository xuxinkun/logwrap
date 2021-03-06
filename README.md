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
| LOGWRAP_LOGROTATE_CYCLE  | cycle param of logrotate configuration, must be either of daily, weekly, monthly or yearly. | weekly                     |
| LOGWRAP_LOGROTATE_SIZE   | minsize param of logroate configuration.                     | 100M                       |
| LOGWRAP_COMMAND          | command wanted to exec.                                      | $1                         |
| LOGWRAP_DIR              | the dir of logfile. If the LOGWRAP_DIR is set, LOGWRAP_FILE will be $LOGWRAP_DIR/$LOGWRAP_COMMAND.log | ""                         |
| LOGWRAP_FILE             | the path of logfile. If the LOGWRAP_DIR is not set, the LOGWRAP_FILE must be set or just use the default value. | /home/$LOGWRAP_COMMAND.log |


# usage

## with docker

`logwrap.sh` can be put on the `entrypoint`. The actual command should be put ont the `command`. 

The example Dockerfile is provided in the project. And the entrypoint is set to `/logwrap.sh`. If the command `echo hello world` wants to be executed. Just execute as follows.

```
[root@localhost logwrap]# docker build -t logwrap:base .
[root@localhost logwrap]# docker run -it --rm -v /home:/home logwrap:base echo hello world
LOGWRAP will direct stdout to  /home/echo.log
LOGWRAP ensure log dir  /home
LOGWRAP enable logrotate.
LOGWRAP start crond.
LOGWRAP generate logrotate file.
LOGWRAP_COMMAND is  echo
LOGROATE_FILE is /etc/logrotate.d/echo
/etc/logrotate.d/echo does not exist. Generate it.
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

