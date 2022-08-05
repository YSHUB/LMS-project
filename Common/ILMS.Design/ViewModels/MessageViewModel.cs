using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using ILMS.Design.Domain;

namespace ILMS.Design.ViewModels
{
	//메세지 관련 페이지
	public class MessageViewModel : BaseViewModel
	{

		[Display(Name = "메세지")]
		public Message Message { get; set; }

		[Display(Name = "쪽지번호")]
		public int MessageNo { get; set; }

		[Display(Name = "수신대상구분")]
		public string ReceiveTargetGubun { get; set; }

		[Display(Name = "쪽지제목")]
		public string MessageTitle { get; set; }

		[Display(Name = "마스터정보")]
		public BoardMaster BoardMaster { get; set; }

		[Display(Name = "쪽지내용")]
		public string MessageContents { get; set; }

		[Display(Name = "발신일시")]
		public string SendDateTime { get; set; }

		[Display(Name = "발신자 유저번호")]
		public int SendUserNo { get; set; }

		[Display(Name = "발신자 전화번호")]
		public string SendPhoneNo { get; set; }

		[Display(Name = "삭제여부")]
		public string DeleteYesNo { get; set; }

		[Display(Name = "파일그룹번호")]
		public int FileGroupNo { get; set; }

		[Display(Name = "받는사람 유저번호")]
		public string[] ReceiveUserNos { get; set; }

		[Display(Name = "학기")]
		public IList<Term> TermList { get; set; }

		[Display(Name = "받는사람 리스트")]
		public IList<Message> ReceiverUserList { get; set; }

		[Display(Name = "교수 리스트")]
		public IList<Course> CourseList { get; set; }

		[Display(Name = "수강생 리스트")]
		public IList<Note> NoteList { get; set; }

	}
}
