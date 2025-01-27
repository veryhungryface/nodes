#!/bin/bash

echo "### GalaNode 및 Docker 제거 스크립트 시작 ###"

# 1. GalaNode 관련 서비스 중지 및 제거
echo "1. GalaNode 서비스 중지 및 제거..."
sudo systemctl stop GalaNodeService.service 2>/dev/null
sudo systemctl disable GalaNodeService.service 2>/dev/null
sudo rm -f /etc/systemd/system/GalaNodeService.service

# 2. 실행 중인 프로세스 강제 종료
echo "2. 실행 중인 프로세스 종료..."
pkill -9 -f gala-node 2>/dev/null

# 3. GalaNode 관련 파일 및 디렉토리 삭제
echo "3. GalaNode 관련 파일 및 디렉토리 삭제..."
sudo rm -rf /usr/local/bin/gala-node
sudo rm -rf /opt/gala-node
sudo rm -rf ~/.gala-node
sudo rm -rf ~/gala-node
sudo rm -f ~/DownloadLinuxNode

# 4. Gala 관련 파일 및 디렉토리 검색 후 삭제
echo "4. Gala 관련 파일 및 디렉토리 삭제..."
sudo find / -type f -name "*gala*" -exec rm -f {} \; 2>/dev/null
sudo find / -type d -name "*gala*" -exec rm -rf {} \; 2>/dev/null

# 5. Docker 컨테이너, 이미지, 네트워크, 볼륨 삭제
echo "5. Docker 관련 모든 구성 요소 삭제..."
docker ps -a | awk '{if(NR>1) print $1}' | xargs -r docker rm -f
docker volume ls -q | xargs -r docker volume rm
docker images -q | xargs -r docker rmi -f
docker network ls | grep "bridge\|host\|none" -v | awk '{if(NR>1) print $1}' | xargs -r docker network rm

# 6. Docker 소프트웨어 제거
echo "6. Docker 소프트웨어 제거..."
sudo apt-get purge -y docker docker-engine docker.io containerd runc
sudo apt-get autoremove -y
sudo apt-get autoclean

# 7. Docker 관련 디렉토리 삭제
echo "7. Docker 관련 디렉토리 삭제..."
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf /var/lib/containerd

# 8. 시스템 서비스 재로드
echo "8. 시스템 서비스 재로드..."
sudo systemctl daemon-reload

# 9. 최종 확인
echo "### GalaNode 및 Docker와 관련된 모든 파일과 설정이 완전히 삭제되었습니다. ###"