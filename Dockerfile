############################################################
# Dockerfile that builds a PalWorld Gameserver
############################################################
FROM debian:bullseye-slim as build_stage

LABEL maintainer="admin@palworldrealm.com"
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"
ENV STEAMAPPID 2394010
ENV STEAMAPP PalWorld
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"

# Install required packages and SteamCMD
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6=10.2.1-6 \
        lib32gcc-s1=10.2.1-6 \
        ca-certificates=20210119 \
        nano=5.4-2+deb11u2 \
        curl=7.74.0-1.3+deb11u11 \
        locales=2.31-13+deb11u7 \
        procps=2:3.3.17-5 \
        xdg-utils=1.1.3-2 \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && useradd -u "${PUID}" -m "${USER}" \
    && su "${USER}" -c \
        "mkdir -p \"${STEAMCMDDIR}\" \
        && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
        && \"./${STEAMCMDDIR}/steamcmd.sh\" +quit \
        && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
        && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
        && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
        && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
        && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
        && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
        && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
        && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
    && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
    && rm -rf /var/lib/apt/lists/*

# Copy entry script and PalWorld settings
COPY /scripts/entry.sh ${HOMEDIR}
COPY /custom-configs/PalWorldSettings.ini ${HOMEDIR}

# Set permissions for entry script and PalWorld directory
RUN set -x \
        && mkdir -p "${STEAMAPPDIR}" \
        && chmod 755 "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
        && chown "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}"

# Switch to unprivileged user
USER ${USER}

WORKDIR ${HOMEDIR}

ENV PORT=8211 \
        QUERYPORT=27165 \
        RCONPORT=21114 \
        MAXPLAYERS=32

EXPOSE 8211/udp \
        27165/tcp \
        27165/udp \
        21114/tcp \
        21114/udp

CMD ["bash", "entry.sh"]
