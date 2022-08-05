using ILMS.Data.Dao;
using ILMS.Design.Domain;

namespace ILMS.Service
{
	public class TeamProjectService
	{
		public TeamProjectDao teamProjectDao { get; set; }

		public int TeamProjectInsert(TeamProject teamProject)
		{
			return teamProjectDao.TeamProjectInsert(teamProject);
		}

		public int TeamProjectUpdate(TeamProject teamProject)
		{
			return teamProjectDao.TeamProjectUpdate(teamProject);
		}
	}
}
