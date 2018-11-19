#!/bin/bash

######################
# git alias 
#####################
git config --global alias.co checkout  
git config --global alias.br branch  
git config --global alias.ci commit  
git config --global alias.st status  
git config --global alias.last 'log -1 HEAD'
git config --global alias.df diff
git config --global  alias.lg "log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ci) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global core.editor vim

########################
# git color
########################
git config --global color.ui true
git config --global color.ui auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.status auto  
