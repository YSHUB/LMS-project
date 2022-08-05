using ILMS.Design.Domain;
using System.Collections;
using System.Collections.Generic;
using System;

namespace ILMS.Data.Dao
{
	public class MessageDao : BaseDAO
	{

        public int MessageUpdate(Message message, IList<Message> messageList)
        {
            int rsCount = 0;

            DaoFactory.Instance.BeginTransaction();

            try
            {
                int sendNo = 0;

                //if (System.Web.Configuration.WebConfigurationManager.AppSettings["UnivName"] == "동주대학교")
                //    sendNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("message.MESSAGE_SAVE_A", message)); // LMS logTable임. 혼동X
                //else
                    sendNo = Convert.ToInt32(DaoFactory.Instance.QueryForObject("message.MESSAGE_SAVE_C", message)); // LMS logTable임. 혼동X

                message.SendNo = sendNo;

                foreach (var item in messageList)
                {
                    message.ReceiveUserNo = item.ReceiveUserNo;
                    message.ReceivePhoneNo = item.ReceivePhoneNo;
                    message.ReceiveUserName = item.ReceiveUserName;

                    //DB입력방식(현재 LMS로그만 남김)
                    rsCount += DaoFactory.Instance.Update("message.MESSAGE_SAVE_B", message);
                }

                DaoFactory.Instance.CommitTransaction();

            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                rsCount = 0;
                DaoFactory.Instance.RollBackTransaction();
            }

            return rsCount;
        }

    }
}
