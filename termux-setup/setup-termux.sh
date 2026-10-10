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

# 4. Descarca FRP ARM64
FRP_VERSION="0.61.1"
cd ~
curl -L -o frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm64.tar.gz"
tar xzf frp.tar.gz
cp frp_${FRP_VERSION}_linux_arm64/frpc $PREFIX/bin/frpc
chmod +x $PREFIX/bin/frpc
rm -rf frp.tar.gz frp_${FRP_VERSION}_linux_arm64

# 5. Copiaza config FRP
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.config/frp
cp "$SCRIPT_DIR/frpc.toml" ~/.config/frp/frpc.toml

# 6. Creeaza script pornire
cat > ~/start-ssh-frp.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
sshd
echo "SSH pornit pe port 8022"
frpc -c ~/.config/frp/frpc.toml
EOF
chmod +x ~/start-ssh-frp.sh

echo ""
echo "=== GATA! ==="
echo "Porneste cu: bash ~/start-ssh-frp.sh"
echo "Conectare SSH: ssh -p 8022 $(whoami)@140.238.218.210"