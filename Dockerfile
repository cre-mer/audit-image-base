# Use an official Ubuntu image as the base
FROM ubuntu:latest

# Update package lists and install essential tools, zsh, and git for oh-my-zsh
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    vim \
    neovim \
    git \
    zip \
    unzip \
    zsh \
    bash \
    passwd \
    && rm -rf /var/lib/apt/lists/*

# Add /bin/zsh to /etc/shells
RUN echo "/bin/zsh" >> /etc/shells

# Verify /etc/shells content (for debugging)
RUN cat /etc/shells

# Set zsh as the default shell for root
RUN chsh -s /bin/zsh root

# Install oh-my-zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create a non-root user for development
ARG USERNAME=auditor
ARG USER_UID=1001
ARG USER_GID=1000
RUN useradd --uid $USER_UID --gid $USER_GID --shell /bin/zsh --create-home $USERNAME

# Set the working directory
WORKDIR /home/$USERNAME/app

# Switch to the non-root user
USER $USERNAME

# Define the default command
CMD ["zsh"]