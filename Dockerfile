FROM jenkins/inbound-agent
USER root

RUN apt update && apt install -y unzip git-ftp
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
apt install -y nodejs

RUN curl -L -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
RUN unzip sonar-scanner-cli-5.0.1.3006-linux.zip
RUN mkdir sonar-scanner
RUN cd sonar-scanner-5.0.1.3006-linux && mv bin conf jre lib ../sonar-scanner
RUN rm sonar-scanner-cli-5.0.1.3006-linux.zip
RUN rmdir sonar-scanner-5.0.1.3006-linux
ENV PATH="$PATH:/home/jenkins/sonar-scanner/bin/"

# Add Docker's official GPG key:
RUN apt-get update
RUN apt-get install ca-certificates curl
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
RUN chmod a+r /etc/apt/keyrings/docker.asc
    
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "bookworm") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
