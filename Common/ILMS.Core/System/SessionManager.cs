using System;
using System.Web;
using System.Web.Security;

namespace ILMS.Core.System
{
	public class SessionManager
	{
		public bool IsLogin
		{
			get
			{
				try
				{
					return (bool)GetValue(SessionConstants.IsLogin);
				}
				catch
				{
					return false;
				}
			}
			set
			{
				SetValue(SessionConstants.IsLogin, value);
			}
		}

		public bool IsAutoLogin
		{
			get
			{
				try
				{
					return (bool)GetValue(SessionConstants.IsAutoLogin);
				}
				catch
				{
					return false;
				}
			}
			set
			{
				SetValue(SessionConstants.IsAutoLogin, value);
			}
		}

		public bool IsAdmin
		{
			get
			{
				try
				{
					return (bool)GetValue(SessionConstants.IsAdmin);
				}
				catch
				{
					return false;
				}
			}
			set
			{
				SetValue(SessionConstants.IsAdmin, value);
			}
		}

		public bool IsGeneral
		{
			get
			{
				try
				{
					return (bool)GetValue(SessionConstants.IsGeneral);
				}
				catch
				{
					return false;
				}
			}
			set
			{
				SetValue(SessionConstants.IsGeneral, value);
			}
		}

		public bool IsLecturer
		{
			get
			{
				try
				{
					return (bool)GetValue(SessionConstants.IsLecturer);
				}
				catch
				{
					return false;
				}
			}
			set
			{
				SetValue(SessionConstants.IsLecturer, value);
			}
		}

		public Int64 UserNo
		{
			get
			{
				try
				{
					return (Int64)GetValue(SessionConstants.UserNo);
				}
				catch
				{
					return 0;
				}
			}
			set
			{
				SetValue(SessionConstants.UserNo, value);
			}
		}

		public Int64 AdminUserNo
		{
			get
			{
				try
				{
					return (Int64)GetValue(SessionConstants.AdminUserNo);
				}
				catch
				{
					return 0;
				}
			}
			set
			{
				SetValue(SessionConstants.AdminUserNo, value);
			}
		}

		public string UserType
		{
			get
			{
				try
				{
					return (string)GetValue(SessionConstants.UserType);
				}
				catch
				{
					return string.Empty;
				}
			}
			set
			{
				SetValue(SessionConstants.UserType, value);
			}
		}

		public Int64 LoginNo
		{
			get
			{
				try
				{
					return (Int64)GetValue(SessionConstants.LoginNo);
				}
				catch
				{
					return 0;
				}
			}
			set
			{
				SetValue(SessionConstants.LoginNo, value);
			}
		}

		public void Clear()
		{
			HttpContext.Current.Session.Clear();
		}

		public void Abandon()
		{
			FormsAuthentication.SignOut();
			HttpContext.Current.Session.Clear();
			HttpContext.Current.Session.Abandon();
		}

		public Object GetValue(SessionConstants sessionName)
		{
			return HttpContext.Current.Session[sessionName.ToString()];
		}

		public void SetValue(SessionConstants sessionName, Object value)
		{
			HttpContext.Current.Session[sessionName.ToString()] = value;
		}
	}
}
