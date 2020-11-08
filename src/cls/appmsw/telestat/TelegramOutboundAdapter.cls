Class appmsw.telestat.TelegramOutboundAdapter Extends Ens.OutboundAdapter
{

Property TelegramName As %String;

Property TelegramToken As %String;

Property SSLConfiguration As %String;

Property API As appmsw.telestat.API [ Private ];

Parameter SETTINGS = "TelegramName,TelegramToken,SSLConfiguration";

Method OnInit() As %Status
{
	set ..API = ##class(appmsw.telestat.API).%New(..TelegramToken, ..SSLConfiguration)
	if '$isobject(..API) {
		return 0
	}
	return $$$OK
}

Method SendMessage(chatId As %String, text As %String, removeKeyboard As %Boolean = 0) As %Integer
{
	if (removeKeyboard) {
		set obj = {"remove_keyboard":true}
		set res = ..API.SendMessage(chatId,text,,,,,obj)
	} else {
		set res = ..API.SendMessage(chatId,text)
	}
	
	if (res.ok) {
		return res.result."message_id"
	}
	return $$$ERROR($$$GeneralError, "Error while sending a message")
}

Method SendButton(chatId As %String, text As %String, buttonText As %String = "", getPhone As %Boolean = 0) As %Status
{
	set button = {}
	if (getPhone=1) { //запрос телефона или геолокации
		do button.%Set("request_contact",1,"boolean") 
		;do button.%Set("request_location",1,"boolean") 
	} 
	set button.text = buttonText
	
	set buttons = []
	do buttons.%Push(button)
	/*
	f i=1:1:10 {
		set button2 = {}
		set button2.text = i
		do buttons.%Push(button2)
	}
	*/
	set obj = {"one_time_keyboard":true,"resize_keyboard":true}
	set obj.keyboard = []
	do obj.keyboard.%Push(buttons)
	;set $$$AppL("TLG",chatId_"-Butt-obj")=$$$AppObJs(obj)
	set res = ..API.SendMessage(chatId,text,,,,,obj)
	;set $$$AppL("TLG",chatId_"-But-res2")=$$$AppObJs(res)
	if (res.ok) {
		return res.result."message_id"
	}
	return $$$ERROR($$$GeneralError, "Error while sending a button "_res."description")
}

}

