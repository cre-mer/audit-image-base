# Use an official Ubuntu image as the base
FROM ubuntu:latest

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Define arguments for user configuration (can be overridden at build time)
ARG USERNAME=auditor
ARG USER_UID=1001
ARG USER_GID=1001
ARG USER_HOME=/home/$USERNAME

# Update package lists and install essential tools, zsh, git, sudo, and CA certificates
# ca-certificates is needed for secure HTTPS connections
# remove package lists metadata downloaded by apt-get update for faster image pulls and lighter builds
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    git \
    zip \
    unzip \
    zsh \
    procps \
    ca-certificates \
    jq \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Add /bin/zsh to /etc/shells if it's not already there
RUN echo "/bin/zsh" | tee -a /etc/shells

# Create the non-root user with zsh as the default shell
# qq what is this`
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID --shell /bin/zsh --create-home --home-dir $USER_HOME $USERNAME

# Switch to the non-root user
USER $USERNAME

# Set the working directory to the user's home directory
WORKDIR $USER_HOME

# Clone Oh-My-Zsh repository directly
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

# TOCHECK will this copy .zshrc from my home directory?
# Create a .zshrc file that sources Oh-My-Zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

# Set the default command to run zsh
CMD ["zsh"]