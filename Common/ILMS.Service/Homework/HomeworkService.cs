using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;

namespace ILMS.Service
{
	public class HomeworkService
	{
		public HomeworkDao homeworkDao { get; set; }

		public int HomeworkInsert(Homework homework)
		{
			return homeworkDao.HomeworkInsert(homework);
		}

		public int HomeworkUpdate(Homework homework)
		{
			return homeworkDao.HomeworkUpdate(homework);
		}

		public int HomeworkSubmitUpdate(HomeworkSubmit homeworksubmit)
		{
			return homeworkDao.HomeworkSubmitUpdate(homeworksubmit);
		}

		public int HomeworkCopy(Homework homework)
		{
			return homeworkDao.HomeworkCopy(homework);
		}

	}
}
