/// Alerting service
Class appmsw.telestat.TelegramServiceAlert Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property ServiceList As %String(MAXLEN = "");

Parameter SETTINGS = "ServiceList";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	s alarm=$wc($zhex("1F6A8"))	
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
	}
	return $$$OK
}

}

