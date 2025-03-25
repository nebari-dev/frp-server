#!/bin/bash

sep="================================================"

remote_access_dir=/opt/remote-access
version=0.61.2
os=linux
arch=amd64
frp_component=frps

log() {
  echo $sep
  echo "$1"
  echo $sep
}

download_frp() {
  sudo mkdir -p $remote_access_dir
  log "Downloading frp"
  download_file_name=frp_${version}_${os}_${arch}
  wget https://github.com/fatedier/frp/releases/download/v${version}/${download_file_name}.tar.gz -O /tmp/$download_file_name.tar.gz
  log "Extract frp"
  tar -xvf /tmp/${download_file_name}.tar.gz -C /tmp/
  ls /tmp/${download_file_name}
  log "Stop $frp_component server, before copying new binary"
  sudo systemctl stop $frp_component || true
  log "Copy frp binary"
  sudo cp $remote_access_dir/frp_${version}/$frp_component $remote_access_dir/$frp_component
  log "Make frp binary executable"
  sudo chmod +x $remote_access_dir/$frp_component
  log "Cleanup downloads"
  sudo rm /tmp/${download_file_name}.tar.gz
  sudo rm /tmp/${download_file_name} -rf
}

copy_config() {
  log "Copy $frp_component config"
  escaped_token=$(printf '%s\n' "$FRP_TOKEN" | sed 's/[&/\]/\\&/g')
  sed -i 's|{{ token }}|'"$escaped_token"'|g' frp_config/$frp_component.toml
  sudo cp frp_config/$frp_component.toml $remote_access_dir/$frp_component.toml
}

create_and_start_service() {
  log "Copy systemd service file"
  sudo cp frp_config/$frp_component.service /etc/systemd/system/$frp_component.service
  log "Change systemd service file permissions"
  sudo chmod 644 /etc/systemd/system/$frp_component.service
  log "Reload systemd service"
  sudo systemctl daemon-reload
  log "Start $frp_component systemd service"
  sudo systemctl start $frp_component
  log "Check systemd service status"
  sudo systemctl status $frp_component
  sleep 5
  sudo systemctl status $frp_component
}

download_frp
copy_config
create_and_start_service
log "Done"
