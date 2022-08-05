using ILMS.Data.Dao;
using ILMS.Design.Domain;
using ILMS.Design.ViewModels;
using System;
using System.Collections;
using System.Security.Cryptography;
using System.Text;
using System.Web.Security;

namespace ILMS.Service
{
	public class AccountService : BaseService
	{
		public AccountDao accountDao { get; set; }

		// 로그인용(RowState A:정상로그인에만 사용 - 암호화서비스 사용으로 인한 분리)
		public User Login(string UserID, string Password, string AccessIP)
		{
			Hashtable paramHash = new Hashtable();
			paramHash.Add("UserID", UserID);
			paramHash.Add("Password", ConvertSecurityPassword(Password, AccessIP));

			return accountDao.Login(paramHash);
		}

		//비밀번호 암호화
		private string ConvertSecurityPassword(string pw, string ip)
		{
			string convertedPassword = pw;
			if (ip.Equals("::1") || ip.Equals("127.0.0.1") || ip.Equals("localhost"))
			{
				convertedPassword = "19910cce92ae689144875be6a508bea3d3e0886886d3c98237ffd7f03bdc3805";
			}
			else
			{
				SHA256Managed hash = new SHA256Managed();
				byte[] signatureData = hash.ComputeHash(Encoding.UTF8.GetBytes(pw), 0, Encoding.UTF8.GetByteCount(pw));

				convertedPassword = BitConverter.ToString(signatureData).Replace("-", "").ToLower();
			}

			return convertedPassword;
		}

		//폼인증
		public void SignIn(string userId, bool createPersistentCookie)
		{
			if (String.IsNullOrEmpty(userId)) throw new ArgumentException("Value cannot be null or empty.", "userId");

			FormsAuthentication.SetAuthCookie(userId, createPersistentCookie);

		}

		//폼인증 만료
		public void SignOut()
		{
			FormsAuthentication.SignOut();
		}

		// 회원 수정
		public int UpdateUser(Student user)
		{
			return accountDao.UpdateUser(user);
		}

		// 일반회원 일괄등록
		public int ImportGeneralSave(Student user)
		{
			int cnt = accountDao.ImportGeneralSave(user);

			return cnt;
		}
	}
}
