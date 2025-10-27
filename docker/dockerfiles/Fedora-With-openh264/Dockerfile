FROM fedora:42

RUN dnf update -y && dnf install bash-completion nano wget -y

# Cisco
COPY openh264-2.5.1-1.fc42.x86_64.rpm /
RUN dnf install /openh264-2.5.1-1.fc42.x86_64.rpm -y
