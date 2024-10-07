#!/bin/bash

# 下载 Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz

# 解压缩文件
tar -xzvf prometheus-2.54.1.linux-amd64.tar.gz

# 移动解压后的目录
mv prometheus-2.54.1.linux-amd64/ prometheus

# 进入目录
cd prometheus/

# 创建必要的目录
mkdir bin conf data

# 移动文件到相应目录
mv prometheus bin/
mv prometheus.yml conf/

# 设置环境变量
echo "export PROMETHEUS_HOME=/opt/prometheus" > /etc/profile.d/prometheus.sh
echo "export PATH=\${PROMETHEUS_HOME}/bin:\$PATH" >> /etc/profile.d/prometheus.sh

# 使环境变量生效
source /etc/profile.d/prometheus.sh

# 移动到目标位置
mv ../prometheus/ /opt/

# 创建 systemd 服务文件
cat <<EOL > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Documentation=prometheus
After=network.target

[Service]
User=root
WorkingDirectory=/opt/prometheus
ExecStart=/opt/prometheus/bin/prometheus --config.file=/opt/prometheus/conf/prometheus.yml
ExecReload=/bin/kill -HUP \$MAINPID
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOL

# 启动服务
systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# 查看服务状态
sudo systemctl status prometheus
