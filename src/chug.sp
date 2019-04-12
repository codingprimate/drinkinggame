public Action DG_Chug_ChugRound(int client1, int args) {
	char str[256];
	GetCmdArgString(str, sizeof(str));

	if (strlen(str) < 1) {
		str = "CHUG ROUND!!! CHEERS";
	}
	if (!canChugRound) {
		//PrintToChat(client1, "There has been a chug round too recently to chug again");
		return Plugin_Handled;
	}
	canChugRound = false;
	for(int i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) {
			continue;
		}
		char playerName[64];
		GetClientName(i, playerName,sizeof(playerName));
		if (DG_IsPlayerPlaying(playerName)) {
			EmitSoundToClient(i,"vo/burp05.mp3");
			PrintCenterText(i,str);
			if (IsPlayerAlive(i)) {
				int rand = GetRandomInt(6,8);
				for (int k=0;k<rand;k++) {
					CreateTimer(0.2 * k, DG_Chug_ChugRoundBottles, i);
				}
			}
		}
	}
	CreateTimer(6.0, DG_Chug_ResetChugRound);
	return Plugin_Handled;
}

public Action DG_Chug_ChugRoundBottles(Handle timer, any client) {
	float vel[3];
	float ang[3];
	GetClientEyeAngles(client, ang);
	GetAngleVectors(ang, vel, NULL_VECTOR, NULL_VECTOR);
	ScaleVector(vel, GetRandomFloat(150.0, 300.0));
	for (int l=0;l<3;l++) {
		vel[l] += GetRandomFloat(-20.0,20.0);
	}
	DG_Effects_SpawnBottleAtClient(client, vel);
}

public Action DG_Chug_ResetChugRound(Handle timer) {
	canChugRound = true;
}
