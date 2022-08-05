using ILMS.Data.Dao;
using ILMS.Design.Domain;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace ILMS.Service
{
	public class SystemService
	{
		public BaseDAO baseDao { get; set; }
		public SystemDao systemDao { get; set; }

		public int PermessionSave(AuthorityGroup authorityGroup)
		{
			int result = 0;

			UserAuthority userAuthority = new UserAuthority();
			userAuthority.RowState = authorityGroup.RowState;
			userAuthority.GroupNo = authorityGroup.GroupNo;
			userAuthority.UserNo = authorityGroup.UserNo;

			string[] userTypeArray = (authorityGroup.UserTypeArray ?? "").Split('|');

			DaoFactory.Instance.BeginTransaction();
			
			try
			{
				if (authorityGroup.RowState.Equals("C"))
				{
					int groupNo = baseDao.Get<int>("system.AUTHORITY_GROUP_SAVE_C", authorityGroup);

					userAuthority.GroupNo = groupNo;
					foreach(var userType in userTypeArray)
					{
						userAuthority.UserType = userType;
						result += baseDao.Save("system.AUTHORITY_USER_SAVE_CU", userAuthority);
					}
				}
				else if(authorityGroup.RowState.Equals("U"))
				{
					result += baseDao.Save("system.AUTHORITY_GROUP_SAVE_U", authorityGroup);
					foreach (var userType in userTypeArray)
					{
						userAuthority.UserType = userType;
						result += baseDao.Save("system.AUTHORITY_USER_SAVE_CU", userAuthority);
					}
				}
				else if (authorityGroup.RowState.Equals("D"))
				{
					result += baseDao.Save("system.AUTHORITY_GROUP_SAVE_D", authorityGroup);
					foreach (var userType in userTypeArray)
					{
						userAuthority.UserType = userType;
						result += baseDao.Save("system.AUTHORITY_USER_SAVE_D", userAuthority);
					}
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}

		public int PermessionMenuSave(MenuAuthority menuAuthority)
		{
			int result = 0;

			string[] menuCodeArray = (menuAuthority.MenuCodeArray ?? "").Split('|');

			DaoFactory.Instance.BeginTransaction();

			try
			{
				menuAuthority.RowState = "D";
				result = baseDao.Save("system.AUTHORITY_MENU_SAVE_D", menuAuthority);

				menuAuthority.RowState = "C";
				foreach (var menuCode in menuCodeArray)
				{
					string[] menuCodeDetail = menuCode.Split('_');
					menuAuthority.MenuCode = menuCodeDetail[0];
					menuAuthority.IncludeYN = menuCodeDetail[1];
					result += baseDao.Save("system.AUTHORITY_MENU_SAVE_CU", menuAuthority);
				}

				DaoFactory.Instance.CommitTransaction();
			}
			catch (Exception)
			{
				result = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return result;
		}
	}
}
