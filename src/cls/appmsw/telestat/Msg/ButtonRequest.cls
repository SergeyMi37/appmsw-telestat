Class appmsw.telestat.Msg.ButtonRequest Extends Ens.Request
{

Property ChatId As %Integer;

/// Message text
Property Text As %String(MAXLEN = "");

/// Comma-separated text of buttons
Property Button As %String(MAXLEN = "");

Storage Default
{
<Data name="ButtonRequestDefaultData">
<Subscript>"ButtonRequest"</Subscript>
<Value name="1">
<Value>ChatId</Value>
</Value>
<Value name="2">
<Value>Text</Value>
</Value>
<Value name="3">
<Value>Button</Value>
</Value>
</Data>
<DefaultData>ButtonRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

