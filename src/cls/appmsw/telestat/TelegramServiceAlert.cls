/// Alerting service
Class appmsw.telestat.TelegramServiceAlert Extends appmsw.telestat.API.service
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property ServiceList As %String(MAXLEN = "");

Parameter SETTINGS = "ServiceList";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	s alarm=$wc($zhex("1F6A8"))	
	do ##class(appmsw.telestat.API.commands).GetAlerts(.str,.return)
	set i="",return=""
	for ii=1:1 { set i=$Order(str(i),-1,val) quit:i=""
		if ii>10 quit
		if $P(val," ",3)>2,'$D(@..#GNtmp@("Alert",$P(val," ",1,2))) {
			set Alert=$G(Alert)+1
			,@..#GNtmp@("Alert",$P(val," ",1,2))=$h
			,last=val
		}
	}
	if $G(Alert) {
		$$$TRACE("Error "_last)
		set message=alarm_$G(last)_$$$NL_$G(return)
		set result=##CLASS(%ResultSet).%New("%DynamicQuery:SQL")
		set tSC=result.Prepare("select ID,NameFirst,NameLast,Number,Access,Notify,TelegramToken,ChatId,Resource,TimeStamp,Groups,IsAdmin,Allow FROM appmsw_telestat.Bots where Notify ='Yes' and ChatId is not null")
		set:tSC tSC=result.Execute()
		if '$$$ISOK(tSC) {
			QUIT tSC
		}
		else {
			while result.Next() {
				set ChatId=result.Data("ChatId")
				set TelegramToken =result.Data("TelegramToken")
				set st=##class(appmsw.telestat.API.util).TelegramSendMessage(TelegramToken ,ChatId,"sendMessage",message)
				$$$TRACE("Sent "_result.Data("NameFirst")_" "_result.Data("NameLast"))
			}
		}
	}
	/*
	s msg=##class(appmsw.telestat.API.service).GetStat(.err)
	if $d(err) {

		$$$TRACE("Error "_msg)
		;s GN=##class(appmsw.telestat.API.service).#GN
		;i $d(@GN@(..TelegramToken)) {
		;	s id=""
		;	for { s id=$o(@GN@(..TelegramToken,id)) q:id=""
		;		i $GET(@GN@(..TelegramToken,id,"allow")) { 
		;			$$$TRACE("Send message "_id)
		;			;do ##class(appmsw.telestat.API.service).SendMsg(id,alarm_"Attention ! Systems crash "_$$$NL_msg)
		;		}
		;	}
		;}
	}*/
	return $$$OK
}

}

