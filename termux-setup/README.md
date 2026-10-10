# Termux SSH + FRP Setup

## Ce face asta?
- Instaleaza **OpenSSH** pe telefon (Termux)
- Instaleaza **FRP client** si se conecteaza la serverul tau FRP (140.238.218.210:7000)
- Forwardare port SSH prin FRP ca sa te poti conecta de oriunde

## Cum se foloseste

### Pasul 1 - Transfera fisierele pe telefon
Copiaja folderul `termux-setup/` pe telefon (cu `adb push`, `scp`, sau orice metoda).

### Pasul 2 - Ruleaza setup-ul
```bash
cd ~/storage/downloads/termux-setup   # sau unde ai copiat
chmod +x setup-termux.sh
./setup-termux.sh
```

### Pasul 3 - Porneste totul
```bash
bash ~/start-ssh-frp.sh
```

### Pasul 4 - Conectare SSH de pe calculator
```bash
ssh -p 6000 <user>@140.238.218.210
```
- `<user>` = username-ul din Termux (ruleaza `whoami` pe telefon)
- Parola = cea setata cu `passwd` in Termux

## Porturi forwardate prin FRP

| Serviciu     | Port local (telefon) | Port remote (server FRP) |
|-------------|---------------------|-------------------------|
| SSH         | 8022                | 6000                    |
| Web Panel   | 8081                | 8081                    |
| Minecraft   | 25565               | 25565                   |

## Info server FRP
- **Addr:** 140.238.218.210
- **Port:** 7000
- **Token:** (in frpc.toml)