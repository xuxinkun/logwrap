FROM centos:7
RUN yum install -y wget logrotate crontabs curl && cp /etc/cron.daily/logrotate /etc/cron.hourly && rm -rf /etc/cron.hourly/0anacron
COPY logwrap.sh /.
ENTRYPOINT ["/logwrap.sh"]