package com.potmo.tdm.connection
{
	import com.potmo.tdm.connection.protocol.IPacket;
	import com.potmo.tdm.connection.protocol.PacketDelimiters;
	import com.potmo.tdm.connection.protocol.packets.WelcomePacket;
	import com.potmo.util.logger.Logger;

	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;

	import org.osmf.logging.Log;

	public class Connector
	{

		private var connection:NetConnection;
		private var group:NetGroup;
		private var isConnected:Boolean = false;
		private var groupName:String;
		private var userNick:String;
		private static const IP_MULTICAST_ADDRESS:String = "224.0.0.1:1337";

		private var serialNumber:uint = 0;


		public function Connector()
		{

		}


		/**
		 * Connect to the group using a group name
		 */
		public function connect( groupName:String, userNick:String ):void
		{
			this.groupName = groupName;
			this.userNick = userNick;
			connection = new NetConnection();
			connection.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
			connection.connect( "rtmfp:" );
		}


		/**
		 * Send to all connected devices in the group
		 */
		public function send( packet:IPacket ):void
		{

			// add overhead
			var outgoing:String = serialNumber + PacketDelimiters.ARGUMENT + packet.getPacketType() + PacketDelimiters.ARGUMENT + packet.encode();

			serialNumber++;

			Logger.log( "Sending: " + outgoing );

			group.sendToAllNeighbors( outgoing );
		}


		private function onConnected():void
		{
			Logger.log( "Connected" );
			joinGroup();
		}


		private function onConnectedToGroup():void
		{
			Logger.log( "connected to group" );
		}


		private function onReceivedData( message:String ):void
		{
			Logger.log( "Got message: " + message );
		}


		private function onOtherClientConnected( peerID:String ):void
		{
			Logger.log( "Other connected: " + peerID );

			var welcomeMessage:WelcomePacket = new WelcomePacket();
			welcomeMessage.setData( userNick );
			send( welcomeMessage );
		}


		private function onOtherClientDisconnected( peerID:String ):void
		{
			Logger.log( "Other disconnected: " + peerID );
		}


		private function joinGroup():void
		{
			Logger.log( "joining group: " + groupName );

			var groupSpec:GroupSpecifier = new GroupSpecifier( groupName );
			groupSpec.routingEnabled = true;
			groupSpec.ipMulticastMemberUpdatesEnabled = true;
			groupSpec.addIPMulticastAddress( IP_MULTICAST_ADDRESS );
			groupSpec.multicastEnabled = true;

			group = new NetGroup( connection, groupSpec.groupspecWithAuthorizations() );
			group.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );

		}


		private function onNetStatus( event:NetStatusEvent ):void
		{

			switch ( event.info.code )
			{
				case ( "NetConnection.Connect.Success" ):
					onConnected();
					break;

				case ( "NetGroup.Connect.Success" ):
					onConnectedToGroup();
					break;

				case ( "NetGroup.SendTo.Notify" ):
					onReceivedData( event.info.message );
					break;

				case ( "NetGroup.Neighbor.Connect" ):
					onOtherClientConnected( event.info.peerID );
					break;

				case ( "NetGroup.Neighbor.Disconnect" ):
					onOtherClientDisconnected( event.info.peerID );
					break;

				default:
					Logger.warn( "Code not handled: " + event.info.code );
					break;
			}
		}
	}
}