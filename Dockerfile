############################################################
# Dockerfile that builds a PalWorld Gameserver
############################################################
FROM cm2network/steamcmd:root

LABEL maintainer="admin@palworldrealm.com"

ENV STEAMAPPID 2394010
ENV STEAMAPP PalWorld
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}"

COPY /scripts/entry.sh ${HOMEDIR}
COPY /custom-configs/PalWorldSettings.ini ${HOMEDIR}

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& chmod 755 "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	&& chown "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" 

ENV PORT=8211 \
	QUERYPORT=27165 \
	RCONPORT=21114 \
	MAXPLAYERS=32

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 8211/udp \
	27165/tcp \
	27165/udp \
	21114/tcp \
	21114/udp
