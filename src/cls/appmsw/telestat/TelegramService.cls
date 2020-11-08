Class appmsw.telestat.TelegramService Extends Ens.BusinessService
{

/// Ens.InboundAdapter
Parameter ADAPTER = "appmsw.telestat.TelegramInboundAdapter";

Property TelegramOperation As %String;

Property ClassMessage As %String;

Parameter SETTINGS = "ClassMessage,TelegramOperation";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	if (pInput.message="") {
		return $$$OK // skipping, if update type not equal to "message" 
	}
	$$$TRACE(pInput.message.chat.id)
	;set $$$AppL("TLG","-input--")=$$$AppObJs(pInput)
	
	;do ##class(appmsw.telestat.API.service).GetMessage(..Adapter.TelegramToken,pInput,.msg)
	s st=$classmethod(..ClassMessage,"GetMessage",..Adapter.TelegramToken,pInput,.msg)
	
	if (msg.Text'="") {
		return ..SendRequestAsync(..TelegramOperation,msg)
	}
	return $$$OK
}

}

