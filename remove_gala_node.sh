#!/bin/bash

echo "### GalaNode 및 Docker 완전 제거 스크립트 시작 ###"

# 1. GalaNode 관련 서비스 중지 및 제거
echo "1. GalaNode 서비스 중지 및 제거..."
sudo systemctl stop GalaNodeService.service 2>/dev/null || true
sudo systemctl disable GalaNodeService.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/GalaNodeService.service

# 2. 실행 중인 GalaNode 프로세스 강제 종료
echo "2. 실행 중인 GalaNode 프로세스 종료..."
pkill -9 -f gala-node 2>/dev/null || true

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
docker network ls | grep -v "bridge\|host\|none" | awk '{if(NR>1) print $1}' | xargs -r docker network rm

# 6. Docker 소프트웨어 및 구성 제거
echo "6. Docker 소프트웨어 제거..."
sudo apt-get purge -y docker docker-engine docker.io containerd runc
sudo apt-get autoremove -y
sudo apt-get autoclean

# 7. Docker 관련 디렉토리 삭제
echo "7. Docker 관련 디렉토리 삭제..."
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
sudo rm -rf /run/docker
sudo rm -rf /var/run/docker.sock
sudo rm -rf /var/run/docker*
sudo rm -rf /var/lib/containerd
sudo rm -rf ~/.docker
sudo rm -rf /usr/bin/docker*
sudo rm -rf /usr/local/bin/docker*
sudo rm -rf /lib/systemd/system/docker*
sudo rm -rf /usr/lib/docker

# 8. 시스템 서비스 및 PID 파일 정리
echo "8. Docker 및 GalaNode 관련 서비스 재로드 및 PID 파일 삭제..."
sudo rm -f /var/run/docker.pid
sudo systemctl daemon-reload

# 9. Docker 및 GalaNode 관련 잔여 패키지 확인
echo "9. Docker 및 GalaNode 관련 패키지 확인..."
dpkg -l | grep -i docker
if [ $? -eq 0 ]; then
    echo "Docker 관련 패키지가 남아 있습니다. 아래 결과를 참고하여 수동으로 제거하세요."
    dpkg -l | grep -i docker
else
    echo "Docker 및 GalaNode 관련 패키지가 모두 제거되었습니다."
fi

# 10. 최종 확인
echo "### GalaNode 및 Docker와 관련된 모든 파일과 설정이 완전히 삭제되었습니다. ###"