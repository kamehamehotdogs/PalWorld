#!/bin/bash
	echo "Loading Steam Release Branch"
	bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
					+login anonymous \
					+app_update "${STEAMAPPID}" validate \
					+quit

bash "${STEAMAPPDIR}/PalServer.sh" \
			-EpicApp="PalServer" \
			-players=32 \
			-useperfthreads \
			-NoAsyncLoadingThread \
			-UseMultithreadForDS
