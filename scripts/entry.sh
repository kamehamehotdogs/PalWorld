#!/bin/bash
	echo "Loading Steam Release Branch"
	bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
					+login anonymous \
					+app_update "${STEAMAPPID}" -beta experimental -betapassword "KwB3Aun4KVgH" validate \
					+quit

bash "${STEAMAPPDIR}/PalServer.sh" \
                        -beta      \
			-players=32 \
			-useperfthreads \
			-NoAsyncLoadingThread \
			-UseMultithreadForDS
