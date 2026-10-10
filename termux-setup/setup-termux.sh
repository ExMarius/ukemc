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
cd "$HOME"
curl -L -o frp.tar.gz "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm64.tar.gz"
tar xzf frp.tar.gz
cp "frp_${FRP_VERSION}_linux_arm64/frpc" "$PREFIX/bin/frpc"
chmod +x "$PREFIX/bin/frpc"
rm -rf frp.tar.gz "frp_${FRP_VERSION}_linux_arm64"

# 5. Copiaza config FRP - ia frpc.toml din acelasi director cu scriptul
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.config/frp"
cp "$SCRIPT_DIR/frpc.toml" "$HOME/.config/frp/frpc.toml"
echo "Config copiat din: $SCRIPT_DIR/frpc.toml"

# 6. Creeaza script pornire
cat > "$HOME/start-ssh-frp.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
sshd
echo "SSH pornit pe port 8022"
frpc -c /data/data/com.termux/files/home/.config/frp/frpc.toml
EOF
chmod +x "$HOME/start-ssh-frp.sh"

echo ""
echo "=== GATA! ==="
echo "Porneste cu: bash ~/start-ssh-frp.sh"
echo "Conectare SSH: ssh -p 8022 $(whoami)@140.238.218.210"