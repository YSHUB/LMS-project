using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Service
{
	public class DiscussionService
	{
		public DiscussionDao discussionDao { get; set; }

		public int DiscussionInsert(Discussion discussion)
		{
			return discussionDao.DiscussionInsert(discussion);
		}

		public int DiscussionUpdate(Discussion discussion)
		{
			return discussionDao.DiscussionUpdate(discussion);
		}
	}
}
