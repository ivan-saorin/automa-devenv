# Use Ubuntu 22.04.3 LTS as the base image
FROM ubuntu:22.04.3

# Install dependencies (add your specific dependencies here)
# The list below starts with essential tools and then installs OpenSSH server
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim \
    openssh-server \
    # Add any additional dependencies below
    # [your-dependencies]

# Setup SSH for connectivity test
# Create a user for SSH
RUN useradd -m dev && echo "dev:automatic" | chpasswd

# Set up SSH to accept login requests
RUN mkdir /var/run/sshd
RUN echo 'root:automatic' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expose the SSH port
EXPOSE 22

# Define the volume
# It's better to use absolute paths for volumes
VOLUME /projects

# Set the working directory
WORKDIR /projects

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]
