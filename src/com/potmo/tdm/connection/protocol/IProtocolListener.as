package com.potmo.tdm.connection.protocol
{

	public interface IProtocolListener
	{
		function handleWelcomePacket( userNick:String ):void;
	}
}