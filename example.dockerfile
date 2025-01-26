# Example: install dotfiles on Ubuntu
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt-get install -y git wget
WORKDIR /root

# In interactive shells, `. <(curl -L https://j.mp/_rc) runsascoded/.rc` is my preferred one-liner, but below
# is an equivalent formulation that works in a Docker build.
RUN wget -qO- https://j.mp/_rc | bash -s runsascoded/.rc
SHELL ["bash", "-ic"]

# As an example, this `e` function (alias for "echo", defined in the "whitespace-helpers" submodule) is now available:
RUN e yay
