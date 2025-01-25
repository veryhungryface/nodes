# 1. 시스템 서비스 제거
sudo systemctl stop GalaNodeService.service 2>/dev/null
sudo systemctl disable GalaNodeService.service 2>/dev/null
sudo rm -f /etc/systemd/system/GalaNodeService.service

# 2. 관련 파일 및 디렉터리 삭제
sudo rm -rf /usr/local/bin/gala-node
sudo rm -rf /opt/gala-node
sudo rm -rf ~/.gala-node
sudo rm -f ~/DownloadLinuxNode
sudo rm -rf ~/gala-node

# 3. 관련 파일 검색 및 삭제
sudo find / -type f -name "*gala*" -exec rm -f {} \;
sudo find / -type d -name "*gala*" -exec rm -rf {} \;

# 4. 남아있는 패키지 정리
sudo apt autoremove -y
sudo apt autoclean

# 5. 확인
sudo systemctl daemon-reload
echo "모든 GalaNode 관련 파일 및 설정이 삭제되었습니다."