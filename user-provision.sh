#!/bin/bash

# git configuration
git config --global user.name "Jose Mokeni"
git config --global user.email "jmmokeni@gmail.com"

# SSH key generation
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
