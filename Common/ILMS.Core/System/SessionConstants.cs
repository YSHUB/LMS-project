namespace ILMS.Core.System
{
	public enum SessionConstants
	{
		IsLogin,        //로그인여부
		IsAutoLogin,    //연동로그인여부
		IsAdmin,		//관리자여부
		IsGeneral,      //일반회원여부
		IsLecturer,		//교수자여부(교직원/관리자 등)

		UserInfo,		//사용자 정보
		UserNo,			//사용자 번호
		UserType,		//사용자 유형
		LoginNo,        //로그인번호
		AdminUserNo		//관리자 사용자 번호(AutoLogin해제용)
	}
}
