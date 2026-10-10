#!/data/data/com.termux/files/usr/bin/bash
# =============================================
# Termux SSH + FRP Setup Script
# Ruleaza asta pe telefon in Termux
# =============================================

set -e

echo "=========================================="
echo "  Termux SSH + FRP Auto Setup"
echo "=========================================="

# --- 1. Update & install packages ---
echo ""
echo "[1/5] Updating packages..."
pkg update -y && pkg upgrade -y

echo ""
echo "[2/5] Installing openssh..."
pkg install -y openssh

echo ""
echo "[2.5/5] Downloading FRP client (ARM64)..."
FRP_VERSION="0.61.1"
FRP_URL="https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_arm64.tar.gz"
cd ~
curl -L -o frp.tar.gz "$FRP_URL"
tar xzf frp.tar.gz
cp frp_${FRP_VERSION}_linux_arm64/frpc $PREFIX/bin/frpc
chmod +x $PREFIX/bin/frpc
rm -rf frp.tar.gz frp_${FRP_VERSION}_linux_arm64
echo "  frpc instalat in $PREFIX/bin/frpc"

# --- 2. Setup SSH ---
echo ""
echo "[3/5] Configuring SSH..."
echo ""
echo "  !! SETEAZA O PAROLA PENTRU SSH !!"
echo "  (asta va fi parola cu care te conectezi)"
echo ""
passwd

# Start sshd
sshd
echo "  SSH daemon pornit pe port 8022"

# --- 3. Copy FRP config ---
echo ""
echo "[4/5] Configuring FRP client..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -f "$SCRIPT_DIR/frpc.toml" ]; then
    mkdir -p ~/.config/frp
    cp "$SCRIPT_DIR/frpc.toml" ~/.config/frp/frpc.toml
    echo "  Config copiat in ~/.config/frp/frpc.toml"
else
    echo "  ATENTIE: frpc.toml nu a fost gasit in directorul scriptului!"
    echo "  Copiaza manual frpc.toml in ~/.config/frp/"
fi

# --- 4. Create startup script ---
echo ""
echo "[5/5] Creating startup script..."

cat > ~/start-ssh-frp.sh << 'STARTEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Starting SSH..."
sshd
echo "SSH running on port 8022"

echo "Starting FRP client..."
frpc -c ~/.config/frp/frpc.toml
STARTEOF

chmod +x ~/start-ssh-frp.sh

echo ""
echo "=========================================="
echo "  SETUP COMPLET!"
echo "=========================================="
echo ""
echo "  Pentru a porni SSH + FRP:"
echo "    bash ~/start-ssh-frp.sh"
echo ""
echo "  Conectare SSH (de pe orice calculator):"
echo "    ssh -p 6000 <username>@140.238.218.210"
echo "    (username = cel din Termux, ruleaza 'whoami' pe telefon)"
echo ""
echo "  FRP admin panel:"
echo "    http://140.238.218.210:8081"
echo ""
echo "  Minecraft server:"
echo "    140.238.218.210:25565"
echo ""
echo "=========================================="