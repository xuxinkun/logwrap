FROM centos:7
RUN yum install -y wget logrotate crontabs curl
COPY logwrap.sh /.
ENTRYPOINT ["/logwrap.sh"]