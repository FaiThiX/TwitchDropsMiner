FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    git \
    python3-tk \
    xvfb \
    libcairo2-dev \
    libgirepository1.0-dev \
    gir1.2-gtk-3.0 \
    gir1.2-ayatanaappindicator3-0.1 \
    pkg-config \
    dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN git clone https://github.com/DevilXD/TwitchDropsMiner.git .

RUN python3 -m venv env && \
    ./env/bin/pip install --upgrade pip wheel && \
    ./env/bin/pip install -r requirements.txt

VOLUME ["/app"]

ENV DISPLAY=:99

ENV PYTHONUNBUFFERED=1

RUN echo '#!/bin/bash\n\
rm -f /tmp/.X99-lock\n\
echo "Starting virtual display (Xvfb)..."\n\
Xvfb :99 -screen 0 1280x720x24 > /dev/null 2>&1 &\n\
sleep 3\n\
echo "Starting TwitchDropsMiner..."\n\
touch log.log\n\
tail -f log.txt &\n\
cd /app && ./env/bin/python3 main.py --log ${ARGS:-"-vv"}' > /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]
