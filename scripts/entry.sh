#!/bin/bash

echo "Loading Steam Release Branch"
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
                    +login anonymous \
                    +app_update "${STEAMAPPID}" validate \
                    +quit

if [ $? -eq 0 ]; then

  LOCAL_CONFIG="~/PalWorldSettings.ini"
  DEST_PATH="${STEAMAPPDIR}/Pal/Saved/Config/LinuxServer"
  DEST_CONFIG="${DEST_PATH}/PalWorldSettings.ini"

  replace_config_value() {
    local key="$1"
    local value="$2"
    local env_var="$3"

    if [ -n "${!env_var}" ]; then
      local new_value="${!env_var}"

      sed -i "s|^\($key=\).*|\1$new_value|" "$LOCAL_CONFIG"
    fi
  }

replace_config_value "Difficulty" "$DIFFICULTY" "DIFFICULTY"
replace_config_value "DayTimeSpeedRate" "$DAY_TIME_SPEED_RATE" "DAY_TIME_SPEED_RATE"
replace_config_value "NightTimeSpeedRate" "$NIGHT_TIME_SPEED_RATE" "NIGHT_TIME_SPEED_RATE"
replace_config_value "ExpRate" "$EXP_RATE" "EXP_RATE"
replace_config_value "PalCaptureRate" "$PAL_CAPTURE_RATE" "PAL_CAPTURE_RATE"
replace_config_value "PalDamageRateAttack" "$PAL_DAMAGE_RATE_ATTACK" "PAL_DAMAGE_RATE_ATTACK"
replace_config_value "PalDamageRateDefense" "$PAL_DAMAGE_RATE_DEFENSE" "PAL_DAMAGE_RATE_DEFENSE"
replace_config_value "PlayerDamageRateAttack" "$PLAYER_DAMAGE_RATE_ATTACK" "PLAYER_DAMAGE_RATE_ATTACK"
replace_config_value "PlayerDamageRateDefense" "$PLAYER_DAMAGE_RATE_DEFENSE" "PLAYER_DAMAGE_RATE_DEFENSE"
replace_config_value "PlayerStomachDecreaseRate" "$PLAYER_STOMACH_DECREASE_RATE" "PLAYER_STOMACH_DECREASE_RATE"
replace_config_value "PlayerStaminaDecreaseRate" "$PLAYER_STAMINA_DECREASE_RATE" "PLAYER_STAMINA_DECREASE_RATE"
replace_config_value "PalStomachDecreaseRate" "$PAL_STOMACH_DECREASE_RATE" "PAL_STOMACH_DECREASE_RATE"
replace_config_value "PalStaminaDecreaseRate" "$PAL_STAMINA_DECREASE_RATE" "PAL_STAMINA_DECREASE_RATE"
replace_config_value "CollectionDropRate" "$COLLECTION_DROP_RATE" "COLLECTION_DROP_RATE"
replace_config_value "DeathPenalty" "$DEATH_PENALTY" "DEATH_PENALTY"
replace_config_value "bEnableInvaderEnemy" "$ENABLE_INVADER_ENEMY" "ENABLE_INVADER_ENEMY"
replace_config_value "BaseCampWorkerMaxNum" "$BASE_CAMP_WORKER_MAX_NUM" "BASE_CAMP_WORKER_MAX_NUM"
replace_config_value "PalEggDefaultHatchingTime" "$PAL_EGG_DEFAULT_HATCHING_TIME" "PAL_EGG_DEFAULT_HATCHING_TIME"
replace_config_value "WorkSpeedRate" "$WORK_SPEED_RATE" "WORK_SPEED_RATE"
replace_config_value "bIsMultiplay" "$IS_MULTIPLAY" "IS_MULTIPLAY"
replace_config_value "bIsPvP" "$IS_PVP" "IS_PVP"
replace_config_value "ServerName" "$SERVER_NAME" "SERVER_NAME"
replace_config_value "AdminPassword" "$ADMIN_PASSWORD" "ADMIN_PASSWORD"
replace_config_value "ServerPassword" "$SERVER_PASSWORD" "SERVER_PASSWORD"
replace_config_value "PublicIP" "$PUBLIC_IP" "PUBLIC_IP"

mkdir -p "$DEST_PATH"

  cp "$LOCAL_CONFIG" "$DEST_CONFIG"

  bash "${STEAMAPPDIR}/PalServer.sh" \
      -EpicApp="PalServer" \
      -players=32 \
      -useperfthreads \
      -NoAsyncLoadingThread \
      -UseMultithreadForDS

  tail -f /dev/null
else
  echo "Failed to install the PalWorld app. Exiting."
  exit 1
fi
