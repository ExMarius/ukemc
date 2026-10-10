#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "=== Termux SSH + FRP Setup ==="

# 1. Update si instaleaza openssh
pkg update -y && pkg upgrade -y
pkg install -y openssh curl

# 2. Seteaza parola SSH
echo ""
echo "Seteaza parola SSH:"
passwd

# 3. Porneste SSH
sshd
echo "SSH pornit pe port 8022"

# 4. Descarca FRP ARM64
FRP_VERSION="0.61.1"
cd /data/data/com.termux/files/home
curl -L -o frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm64.tar.gz"
tar xzf frp.tar.gz
cp "frp_${FRP_VERSION}_linux_arm64/frpc" /data/data/com.termux/files/usr/bin/frpc
chmod +x /data/data/com.termux/files/usr/bin/frpc
rm -rf frp.tar.gz "frp_${FRP_VERSION}_linux_arm64"
echo "frpc instalat"

# 5. Creeaza direct config FRP (fara copiere)
mkdir -p /data/data/com.termux/files/home/.config/frp
cat > /data/data/com.termux/files/home/.config/frp/frpc.toml << 'FRPCONF'
serverAddr = "140.238.218.210"
serverPort = 7000
auth.token = "minecraft12345"

[[proxies]]
name = "ssh"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8022
remotePort = 8022

[[proxies]]
name = "webpanel"
type = "tcp"
localIP = "127.0.0.1"
localPort = 8081
remotePort = 8081

[[proxies]]
name = "minecraft"
type = "tcp"
localIP = "127.0.0.1"
localPort = 25565
remotePort = 25565
FRPCONF
echo "Config FRP creat"

# 6. Creeaza script pornire
cat > /data/data/com.termux/files/home/start-ssh-frp.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
sshd
echo "SSH pornit pe port 8022"
echo "Pornesc FRP..."
frpc -c /data/data/com.termux/files/home/.config/frp/frpc.toml
EOF
chmod +x /data/data/com.termux/files/home/start-ssh-frp.sh

echo ""
echo "=== GATA! ==="
echo "Porneste cu: bash ~/start-ssh-frp.sh"
echo "Conectare SSH: ssh -p 8022 $(whoami)@140.238.218.210"