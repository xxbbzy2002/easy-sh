#!/bin/bash

# 下载 node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

# 解压缩
tar -xzvf node_exporter-1.8.2.linux-amd64.tar.gz

# 进入目录
cd node_exporter-1.8.2.linux-amd64/ || exit

# 移动可执行文件
mv node_exporter /usr/bin

# 创建 systemd 服务文件
cat >/etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=node_exporter
After=network.target

[Service]
ExecStart=/usr/bin/node_exporter --web.listen-address=:9100
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 配置
systemctl daemon-reload

# 启用并启动 node_exporter 服务
systemctl enable --now node_exporter

# 显示服务状态
systemctl status node_exporter
