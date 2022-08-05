using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Service
{
	public class MessageService
	{
		public MessageDao messageDao { get; set; }

		public int MessageUpdate(Message message, IList<Message> messageList)
		{
			return messageDao.MessageUpdate(message, messageList);
		}
	}
}
