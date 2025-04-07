#Base Bind9 Image
FROM internetsystemsconsortium/bind9:9.18

#Install required tools and dependencies
RUN apt update && apt install -y \  
        bind9-doc \  
        dnsutils \  
        geoip-bin \  
        mariadb-server \  
        net-tools

#Copy configuration files
#COPY configuration/named.conf.options /etc/bind/
#COPY configuration/named.conf.local /etc/bind/
#COPY configuration/db.dockerhosting.lan /etc/bind/zones/

# Expose Ports
EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 953/tcp

# Start the Name Service
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
