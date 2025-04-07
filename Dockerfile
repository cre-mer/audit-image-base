# Use an official Alpine image as the base
FROM alpine:latest

# Update package lists and install essential tools, zsh, and git for oh-my-zsh
RUN apk update && apk add --no-cache \
    curl \
    wget \
    vim \
    neovim \
    git \
    zip \
    unzip \
    zsh \
    bash \
    shadow
RUN rm -rf /var/cache/apk/*

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
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN addgroup -g $USER_GID $USERNAME && \
    adduser -u $USER_UID -G $USERNAME -s /bin/zsh -D $USERNAME

# Set the working directory
WORKDIR /home/$USERNAME/app

# Switch to the non-root user
USER $USERNAME

# Set zsh as the default shell for the dev user
RUN chsh -s /bin/zsh $USERNAME

# Define the default command
CMD ["zsh"]
