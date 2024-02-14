#!/bin/bash

echo "Loading Steam Release Branch"
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
                    +login anonymous \
                    +app_update "${STEAMAPPID}" validate \
                    +quit

if [ $? -eq 0 ]; then

  DEST_PATH="${STEAMAPPDIR}/Pal/Saved/Config/LinuxServer"
  DEST_CONFIG="${DEST_PATH}/PalWorldSettings.ini"
  DEFAULT_CONFIG="${STEAMAPPDIR}/DefaultPalWorldSettings.ini"

  # Step 2: Start PalServer.sh script in the background
  bash "${STEAMAPPDIR}/PalServer.sh" \
      -EpicApp=PalServer \
      -players=32 \
      -useperfthreads \
      -NoAsyncLoadingThread \
      -UseMultithreadForDS &

  # Step 3: Wait for PalServer.sh to start
  sleep 10  # Adjust the sleep time as needed

  # Check if PalServer.sh process is running
  PALSERVER_PID=$(pgrep -x "PalServer.sh")
  if [ -n "$PALSERVER_PID" ]; then
    echo "PalServer.sh started successfully with PID: $PALSERVER_PID."
    
    # Step 4: Stop the PalServer.sh script
    pkill -i "palserver.sh"
    pkill -i "palserver-linux-test"

  sleep 20

    cp "$DEFAULT_CONFIG" "$DEST_CONFIG"

    sed -i "s|^Difficulty=.*$|Difficulty=${DIFFICULTY:-None}|" "$DEST_CONFIG"
    sed -i "s|^DayTimeSpeedRate=.*$|DayTimeSpeedRate=${DAY_TIME_SPEED_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^NightTimeSpeedRate=.*$|NightTimeSpeedRate=${NIGHT_TIME_SPEED_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^ExpRate=.*$|ExpRate=${EXP_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PalCaptureRate=.*$|PalCaptureRate=${PAL_CAPTURE_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PalDamageRateAttack=.*$|PalDamageRateAttack=${PAL_DAMAGE_RATE_ATTACK:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PalDamageRateDefense=.*$|PalDamageRateDefense=${PAL_DAMAGE_RATE_DEFENSE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PlayerDamageRateAttack=.*$|PlayerDamageRateAttack=${PLAYER_DAMAGE_RATE_ATTACK:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PlayerDamageRateDefense=.*$|PlayerDamageRateDefense=${PLAYER_DAMAGE_RATE_DEFENSE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PlayerStomachDecreaseRate=.*$|PlayerStomachDecreaseRate=${PLAYER_STOMACH_DECREASE_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PlayerStaminaDecreaseRate=.*$|PlayerStaminaDecreaseRate=${PLAYER_STAMINA_DECREASE_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PalStomachDecreaseRate=.*$|PalStomachDecreaseRate=${PAL_STOMACH_DECREASE_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^PalStaminaDecreaseRate=.*$|PalStaminaDecreaseRate=${PAL_STAMINA_DECREASE_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^CollectionDropRate=.*$|CollectionDropRate=${COLLECTION_DROP_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^DeathPenalty=.*$|DeathPenalty=${DEATH_PENALTY:-All}|" "$DEST_CONFIG"
    sed -i "s|^bEnableInvaderEnemy=.*$|bEnableInvaderEnemy=${ENABLE_INVADER_ENEMY:-True}|" "$DEST_CONFIG"
    sed -i "s|^BaseCampWorkerMaxNum=.*$|BaseCampWorkerMaxNum=${BASE_CAMP_WORKER_MAX_NUM:-15}|" "$DEST_CONFIG"
    sed -i "s|^PalEggDefaultHatchingTime=.*$|PalEggDefaultHatchingTime=${PAL_EGG_DEFAULT_HATCHING_TIME:-72.000000}|" "$DEST_CONFIG"
    sed -i "s|^WorkSpeedRate=.*$|WorkSpeedRate=${WORK_SPEED_RATE:-1.000000}|" "$DEST_CONFIG"
    sed -i "s|^bIsMultiplay=.*$|bIsMultiplay=${IS_MULTIPLAY:-False}|" "$DEST_CONFIG"
    sed -i "s|^bIsPvP=.*$|bIsPvP=${IS_PVP:-False}|" "$DEST_CONFIG"
    sed -i "s|^ServerName=.*$|ServerName=${SERVER_NAME:-Default Palworld Server}|" "$DEST_CONFIG"
    sed -i "s|^AdminPassword=.*$|AdminPassword=${ADMIN_PASSWORD}|" "$DEST_CONFIG"
    sed -i "s|^ServerPassword=.*$|ServerPassword=${SERVER_PASSWORD}|" "$DEST_CONFIG"
    sed -i "s|^PublicIP=.*$|PublicIP=${PUBLIC_IP}|" "$DEST_CONFIG"

sleep 30
 
    # Step 5: Start the PalServer.sh script again
    bash "${STEAMAPPDIR}/PalServer.sh" \
        -EpicApp=PalServer \
        -players=32 \
        -useperfthreads \
        -NoAsyncLoadingThread \
        -UseMultithreadForDS

    # Step 6: Keep the container running
    tail -f /dev/null

  else
    echo "Failed to start PalServer.sh. Exiting."
    exit 1
  fi

else
  echo "Failed to install the PalWorld app. Exiting."
  exit 1
fi
