package com.potmo.tdm.connection.protocol
{

	/**
	 * Provides the interface for packets that should be serialized and deserialized.
	 * @note a setData function must be used where appropriate
	 */
	public interface IPacket
	{

		/**
		 * The type the packet handles
		 */
		function getPacketType():uint;

		/**
		 * Decodes a string and calls the listener with the appropriate function
		 */
		function decode( data:String, listener:IProtocolListener ):void;

		/**
		 * Encodes it's data into a string. The data should be provided in a setData() function
		 */
		function encode():String;

	}
}