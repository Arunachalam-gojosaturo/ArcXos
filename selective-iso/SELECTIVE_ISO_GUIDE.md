# ArcXos Selective & Optimized ISO Build Guide

This profile creates a highly optimized, lightweight version of **ArcXos Linux** without modifying or removing any existing project files in `slim-iso` or `full-iso`.

---

## 🎯 Profile Overview & Philosophy

- **OS Core & Hardware Stack**: Includes full Linux Kernel, system libraries, assets, sound stack (PulseAudio/ALSA), graphics drivers (Intel, AMD, Nvidia/nouveau, Mesa, Vulkan), and display manager (LightDM + XFCE4 Desktop).
- **Network Stack**: Full NetworkManager integration with Wi-Fi, Ethernet, VPN, WPA Supplicant, and Bluetooth tools (`networkmanager`, `network-manager-applet`, `blueman`, etc.).
- **Optimized Size**: Hundreds of heavy security tools present in full BlackArch have been trimmed down, retaining **ONLY** the 21 explicitly specified tools and system dependencies.

---

## 🛠️ Included Tools (Exact 21 Toolset)

1. **Nmap & Zenmap** (`nmap`, `zenmap`) - Network scanner & GUI
2. **Wireshark** (`wireshark-qt`, `wireshark-cli`) - Network packet analyzer
3. **OpenVAS / GVM** (`gvm`, `openvas-scanner`) - Vulnerability scanner
4. **Aircrack-ng** (`aircrack-ng`) - 802.11 WEP/WPA key cracker
5. **Nikto** (`nikto`) - Web server scanner
6. **Metasploit** (`metasploit`, `msfdb`) - Exploitation framework
7. **John the Ripper** (`john`) - Password cracker
8. **Hashcat** (`hashcat`, `hashcat-utils`) - Password recovery utility
9. **SQLMap** (`sqlmap`) - Automatic SQL injection tool
10. **Snort** (`snort`) - Network intrusion detection system
11. **OWASP ZAP** (`zaproxy`) - Web application security scanner
12. **Snyk** (`snyk`) - Developer security platform CLI
13. **Cuckoo Sandbox** (`cuckoo`) - Automated malware analysis system
14. **Visual Studio Code** (`code`) - Development IDE
15. **Kali Linux** (`kali-tools-setup`) - Kali compatibility launcher & toolset helper
16. **Splunk** (`splunk-setup`) - Splunk Enterprise / Universal Forwarder launcher
17. **CrowdStrike Falcon** (`falcon-sensor-setup`) - Falcon EDR sensor helper
18. **SentinelOne** (`sentinelone-setup`) - Singularity EDR agent helper
19. **Tenable Nessus Professional** (`nessus-setup`) - Nessus scanner setup helper
20. **Security Onion** (`security-onion-setup`) - SOC sensor & log collector helper
21. **Okta** (`okta-setup`) - Enterprise identity & CLI setup helper

---

## 🚀 How to Build the Selective ISO

Run the build script with root privileges from the workspace:

```bash
sudo ./build-selective-iso.sh
```

Or invoke `mkarchiso` directly:

```bash
sudo mkarchiso -v -w /home/arunachalam/blackarch-iso/selective-iso/work \
                  -o /home/arunachalam/blackarch-iso/selective-iso/out \
                  /home/arunachalam/blackarch-iso/selective-iso
```

### Output ISO Location
After build completion, the ISO will be located at:
`/home/arunachalam/blackarch-iso/selective-iso/out/arcxos-selective-YYYY.MM.DD-x86_64.iso`
