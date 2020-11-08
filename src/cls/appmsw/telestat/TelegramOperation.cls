Class appmsw.telestat.TelegramOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "appmsw.telestat.TelegramOutboundAdapter";

Parameter INVOCATION = "Queue";

Property Adapter As appmsw.telestat.TelegramOutboundAdapter;

Method SendMessage(pInput As appmsw.telestat.Msg.TextRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendMessage(pInput.ChatId,pInput.Text,1)
}

Method SendButton(pInput As appmsw.telestat.Msg.ButtonRequest, Output pOutput As Ens.Response) As %Status
{
	Quit ..Adapter.SendButton(pInput.ChatId,pInput.Text,pInput.Button,1)
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="appmsw.telestat.Msg.TextRequest">
        <Method>SendMessage</Method>
    </MapItem>
    <MapItem MessageType="appmsw.telestat.Msg.ButtonRequest">
        <Method>SendButton</Method>
    </MapItem>
</MapItems>
}

}

