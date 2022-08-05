using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;

namespace ILMS.Data.Dao
{
	public class AccountDao : BaseDAO
	{
		// 로그인용(RowState A:정상로그인에만 사용 - 암호화서비스 사용으로 인한 분리)
		public User Login(Hashtable paramHash)
		{
			return DaoFactory.Instance.QueryForObject<User>("account.LOGIN_SELECT_A", paramHash);
		}

		// 회원 수정
		public int UpdateUser(Student user)
		{
			int cnt = 0;

			DaoFactory.Instance.BeginTransaction();

			try
			{
				cnt = DaoFactory.Instance.Update("account.USER_SAVE_U", user);

				if (cnt > 0)
				{
					cnt = DaoFactory.Instance.Update("student.STUDENT_SAVE_U", user);
					DaoFactory.Instance.CommitTransaction();
				}
				else
				{
					DaoFactory.Instance.RollBackTransaction();
				}
				
			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				cnt = 0;
				DaoFactory.Instance.RollBackTransaction();
			}

			return cnt;
		}

		// 일반회원 일괄등록
		public int ImportGeneralSave(Student user)
		{
			int userNo = 0;
			int cnt = 0;
			DaoFactory.Instance.BeginTransaction();

			try
			{
				userNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("account.USER_SAVE_C", user));
				user.UserNo = userNo;

				if (userNo > 0)
				{
					cnt = Convert.ToInt32(DaoFactory.Instance.QueryForObject("student.STUDENT_SAVE_C", user));
				}	

				DaoFactory.Instance.CommitTransaction();


			}
			catch (Exception ex)
			{
				string errorMessage = ex.Message;
				userNo = 0;
				DaoFactory.Instance.RollBackTransaction();
			}


			return userNo;
		}
	}
}
