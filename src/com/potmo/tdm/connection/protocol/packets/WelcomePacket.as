package com.potmo.tdm.connection.protocol.packets
{
	import com.potmo.tdm.connection.protocol.IPacket;
	import com.potmo.tdm.connection.protocol.IProtocolListener;
	import com.potmo.tdm.connection.protocol.PacketTypeEnum;

	/**
	 * Welcome packet is sent from all users in a group when another new user just joined.
	 * It contains the information about the sending user so the new user can relate it to the peerID
	 *
	 */
	public class WelcomePacket implements IPacket
	{

		private var userNick:String;


		public function WelcomePacket()
		{

		}


		public function getPacketType():uint
		{
			return PacketTypeEnum.WELCOME;
		}


		public function setData( userNick:String ):void
		{
			this.userNick = userNick;

		}


		public function decode( data:String, listener:IProtocolListener ):void
		{
			userNick = data;
			listener.handleWelcomePacket( userNick );
		}


		public function encode():String
		{
			return userNick;
		}
	}
}