using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Note : Common
	{
		public Note() { }

		public Note(string rowState)
		{
			RowState = rowState;
		}
		public Note(string rowState, Int64 noteNo)
		{
			RowState = rowState;
			NoteNo = noteNo;
		}

		public Note(string noteTitle, string noteContent, Int64 receiveUserNo, Int64 sendUserNo, Int64? fileGroupNo) {
			NoteTitle = noteTitle;
			NoteContents = noteContent;
			ReceiveUserNo = receiveUserNo;
			SendUserNo = sendUserNo;
			FileGroupNo = fileGroupNo;
		}

		[Display(Name = "쪽지 번호")]
		public Int64 NoteNo { get; set; }

		[Display(Name = "쪽지 제목")]
		public string NoteTitle { get; set; }

		[Display(Name = "쪽지 내용")]
		public string NoteContents { get; set; }

		[Display(Name = "발송 사용자 아이디")]
		public string SendUserID { get; set; }

		[Display(Name = "발송 사용자 번호")]
		public Int64 SendUserNo { get; set; }

		[Display(Name = "발송 사용자 이름")]
		public string SendUserName { get; set; }

		[Display(Name = "수신 사용자 아이디")]
		public string ReceiveUserID { get; set; }

		[Display(Name = "수신 사용자 이름")]
		public string ReceiveUserName { get; set; }

		[Display(Name = "수신 사용자 번호")]
		public Int64 ReceiveUserNo { get; set; }

		[Display(Name = "발송일시")]
		public string SendDateTime { get; set; }

		[Display(Name = "수신(열람)일시")]
		public string ReceiveDateTime { get; set; }

		[Display(Name = "전체 쪽지 수")]
		public int NoteCount { get; set; }

		[Display(Name = "읽지 않은 쪽지 수")]
		public int NotReadNoteCount { get; set; }

		[Display(Name = "파일그룹번호")]
		public Int64? FileGroupNo { get; set; }
		
		[Display(Name = "사용자 아이디")]
		public string UserID { get; set; }

		[Display(Name = "삭제할 쪽지 번호")]
		public string DelNoteNo { get; set; }
	}
}
