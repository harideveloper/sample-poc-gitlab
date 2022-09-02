
## Step 1 : Docker Installation
if [ -x "$(command -v docker)" ]; then
  echo "docker is already installed, proceeding with next steps"
else
  echo "Install docker"
  curl -fsSL https://get.docker.com -o get-docker.sh
  if [[ $? -gt 0 ]];then
    echo "$(date +"%d-%m-%Y %T") Error 101: Unable to download docker from https://get.docker.com"
    echo "$(date +"%d-%m-%Y %T") Info : Please check your VM connection, setup or VM scope to access internet"
    exit
  else
    echo "$(date +"%d-%m-%Y %T") Info : docker install script downloaded successfully"
    sudo sh get-docker.sh
    if [[ $? -gt 0 ]];then
      echo "$(date +"%d-%m-%Y %T") Error 102: Docker installation failed, Please install docker manually"
      exit
    else
      echo "$(date +"%d-%m-%Y %T") Info : Docker installed successfully"
    fi
    docker --version
  fi
fi

## Step 2 : Install & Register Gitlab Runner
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
if [[ $? -gt 0 ]];then
  echo "$(date +"%d-%m-%Y %T") Error 103: Unable to install gitlab runner, Please install manually"
  exit
else
  echo "$(date +"%d-%m-%Y %T") Info : Gitlab runner installed manually"
  sudo docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
  if [[ $? -gt 0 ]];then
    echo "$(date +"%d-%m-%Y %T") Error 104: Gitlab docker run failed, please check logs"
    exit
  else
    echo "$(date +"%d-%m-%Y %T") Info : Gitlab docker machine container is running successful"
    sudo docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register  --non-interactive --executor "docker" --docker-image gitlab/gitlab-runner:latest --url "https://pscode.lioncloud.net/" --registration-token "GR13489416fx9zhVdA8ziA3zmxy8S" --description "gitlab runners used by enabler team POC " --maintenance-note "NA" --tag-list "enablers poc" --run-untagged="true" --locked="false" --access-level="not_protected"
    if [[ $? -gt 0 ]];then
      echo "$(date +"%d-%m-%Y %T") Error 105: Gitlab registration failed"
      exit
    else
      echo "$(date +"%d-%m-%Y %T") Info : gitlab registered successfully"
    fi
  fi
fi



# sudo echo "check 1" >> test.txt
# sudo apt-get update
# sudo echo "check 2" >> test.txt
# pwd
# ls -lta

# # Install docker
# curl -fsSL https://get.docker.com -o get-docker.sh
# if [[ $? -gt 0 ]];then
#   echo "$(date +"%d-%m-%Y %T") Error 101: Unable to download docker from https://get.docker.com"
#   echo "$(date +"%d-%m-%Y %T") Info : Please check your VM connection, setup or VM scope to access internet"
#   exit
# else
#   echo "$(date +"%d-%m-%Y %T") Info : docker install script downloaded successfully"
#   sudo sh get-docker.sh
#   if [[ $? -gt 0 ]];then
#     echo "$(date +"%d-%m-%Y %T") Error 102: Docker installation failed, Please install docker manually"
#     exit
#   else
#     echo "$(date +"%d-%m-%Y %T") Info : Docker installed successfully"
#     curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
#     if [[ $? -gt 0 ]];then
#       echo "$(date +"%d-%m-%Y %T") Error 103: Unable to install gitlab runner, Please install manually"
#       sudo docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
#       exit
#     else
#       echo "$(date +"%d-%m-%Y %T") Info : Gitlab runner installed manually"
#       if [[ $? -gt 0 ]];then
#         echo "$(date +"%d-%m-%Y %T") Error 104: Gitlab docker run failed, please check logs"
#         exit
#       else
#         echo "$(date +"%d-%m-%Y %T") Info : Gitlab docker machine container is running successful"
#         sudo docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register  --non-interactive --executor "docker" --docker-image gitlab/gitlab-runner:latest --url "https://pscode.lioncloud.net/" --registration-token "GR13489416fx9zhVdA8ziA3zmxy8S" --description "gitlab runners used by enabler team POC " --maintenance-note "NA" --tag-list "enablers poc" --run-untagged="true" --locked="false" --access-level="not_protected"
#         if [[ $? -gt 0 ]];then
#           echo "$(date +"%d-%m-%Y %T") Error 105: Gitlab registration failed"
#           exit
#         else
#           echo "$(date +"%d-%m-%Y %T") Info : gitlab registered successfully"
#         fi
#       fi
#     fi
#   fi
# fi

# sudo sh get-docker.sh

# curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

# sudo echo "check 2" >> test.txt

# sudo docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
# sudo echo "check 3" >> test.txt

# sudo docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register  --non-interactive --executor "docker" --docker-image gitlab/gitlab-runner:latest --url "https://pscode.lioncloud.net/" --registration-token "GR13489416fx9zhVdA8ziA3zmxy8S" --description "gitlab runners used by enabler team POC " --maintenance-note "NA" --tag-list "enablers poc" --run-untagged="true" --locked="false" --access-level="not_protected"

# sudo echo "check 4" >> test.txt

# #run the gitlab as docker container
# sudo docker run -d --name gitlab-runner --restart always \
#     -v /srv/gitlab-runner/config:/etc/gitlab-runner \
#     -v /var/run/docker.sock:/var/run/docker.sock \
#     gitlab/gitlab-runner:latest

# sudo docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
#   --non-interactive \
#   --executor "docker" \
#   --docker-image gitlab/gitlab-runner:latest \
#   --url "https://pscode.lioncloud.net/" \
#   --registration-token "GR13489416fx9zhVdA8ziA3zmxy8S" \
#   --description "gitlab runners used by enabler team POC " \
#   --maintenance-note "NA" \
#   --tag-list "enablers poc" \
#   --run-untagged="true" \
#   --locked="false" \
#   --access-level="not_protected"


  