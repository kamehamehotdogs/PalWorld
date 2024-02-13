#!/bin/bash

echo "Loading Steam Release Branch"
bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
                    +login anonymous \
                    +app_update "${STEAMAPPID}" validate \
                    +quit

DEFAULT_CONFIG="${STEAMAPPDIR}/DefaultPalWorldSettings.ini"

DEST_CONFIG="${STEAMAPPDIR}/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

replace_config_value() {
  local key="$1"
  local value="$2"
  sed -i "s|^$key=.*$|$key=$value|" "$DEST_CONFIG"
}

while [ ! -f "$DEFAULT_CONFIG" ]; do
  sleep 1
done

cp "$DEFAULT_CONFIG" "$DEST_CONFIG"

replace_config_value "OptionSettings=(Difficulty" "$DIFFICULTY"
replace_config_value "DayTimeSpeedRate" "$DAY_TIME_SPEED_RATE"
replace_config_value "NightTimeSpeedRate" "$NIGHT_TIME_SPEED_RATE"
replace_config_value "ExpRate" "$EXP_RATE"
replace_config_value "PalCaptureRate" "$PAL_CAPTURE_RATE"
replace_config_value "PalDamageRateAttack" "$PAL_DAMAGE_RATE_ATTACK"
replace_config_value "PalDamageRateDefense" "$PAL_DAMAGE_RATE_DEFENSE"
replace_config_value "PlayerDamageRateAttack" "$PLAYER_DAMAGE_RATE_ATTACK"
replace_config_value "PlayerDamageRateDefense" "$PLAYER_DAMAGE_RATE_DEFENSE"
replace_config_value "PlayerStomachDecreaseRate" "$PLAYER_STOMACH_DECREASE_RATE"
replace_config_value "PlayerStaminaDecreaseRate" "$PLAYER_STAMINA_DECREASE_RATE"
replace_config_value "PalStomachDecreaseRate" "$PAL_STOMACH_DECREASE_RATE"
replace_config_value "PalStaminaDecreaseRate" "$PAL_STAMINA_DECREASE_RATE"
replace_config_value "CollectionDropRate" "$COLLECTION_DROP_RATE"
replace_config_value "DeathPenalty" "$DEATH_PENALTY"
replace_config_value "bEnableInvaderEnemy" "$ENABLE_INVADER_ENEMY"
replace_config_value "BaseCampWorkerMaxNum" "$BASE_CAMP_WORKER_MAX_NUM"
replace_config_value "PalEggDefaultHatchingTime" "$PAL_EGG_DEFAULT_HATCHING_TIME"
replace_config_value "WorkSpeedRate" "$WORK_SPEED_RATE"
replace_config_value "bIsMultiplay" "$IS_MULTIPLAY"
replace_config_value "bIsPvP" "$IS_PVP"
replace_config_value "ServerName" "$SERVER_NAME"
replace_config_value "AdminPassword" "$ADMIN_PASSWORD"
replace_config_value "ServerPassword" "$SERVER_PASSWORD"
replace_config_value "PublicIP" "$PUBLIC_IP"


bash "${STEAMAPPDIR}/PalServer.sh" \
  -EpicApp="PalServer" \
  -players=32 \
  -useperfthreads \
  -NoAsyncLoadingThread \
  -UseMultithreadForDS

tail -f /dev/null
