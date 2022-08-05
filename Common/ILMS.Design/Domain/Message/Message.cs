using System;
using System.ComponentModel.DataAnnotations;

namespace ILMS.Design.Domain
{
	[Serializable]
	public class Message : Common
	{
		public Message() { }

		[Display(Name = "발송 번호")]
		public Int64 SendNo { get; set; }

		[Display(Name = "발송 사용자 번호")]
		public Int64 SendUserNo { get; set; }

		[Display(Name = "발송자 휴대폰 번호")]
		public string SendPhoneNo { get; set; }

		[Display(Name = "발송 내용")]
		public string SendContents { get; set; }

		[Display(Name = "예약발송")]
		public string SendGubun { get; set; }

		[Display(Name = "예약발송 시간")]
		public string ReservationSenderDateTime { get; set; }

		[Display(Name = "발송건수")]
		public int SendCount { get; set; }

		[Display(Name = "강좌번호")]
		public int CourseNo { get; set; }

		[Display(Name = "보낸사람 이름")]
		public string SendUserName { get; set; }

		[Display(Name = "받는사람 이름")]
		public string ReceiveUserName { get; set; }

		[Display(Name = "받는사람 사용자번호")]
		public long ReceiveUserNo { get; set; }

		[Display(Name = "받는사람 핸드폰번호")]
		public string ReceivePhoneNo { get; set; }

		[Display(Name = "받는사람 이름과 핸드폰 번호들")]
		public string Address { get; set; }

		[Display(Name = "받는사람 유저번호")]
		public string[] ReceiveUserNos { get; set; }
	}
}
