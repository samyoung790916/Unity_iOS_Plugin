using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using AOT;

//using for DllImport
using System.Runtime.InteropServices;

public class iOSManager : MonoBehaviour 
{
    static iOSManager _instance;

    delegate void NativeDelegateNotification(bool bSuccess, string strMessage);
    delegate void NativeDelegateStatusNotification(bool bSuccess);

    [DllImport("__Internal")]
    private static extern void JoinReqeust(string strEmail,string strpw,string strName, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void LoginReqeust(string strEmail, string strpw, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void SendMessageRequest(string strMessage, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void DeviceConnectRequest(string strDevice, string strEmail, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void DeviceQuitRequest(string strDevice, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void DeviceListRequest(string strEmail, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void snsJoinReqeust(string strDevice, string strEmail, string snsToken, string strTwiterToken, strig strSort, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void memberIntegrateRequest(string strDevice, string strsnsToken, string strsnsTwiterToken, string strSort, string strEmail, string strpwd, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void snsLoginReqeust(string strSortDevice, string strsnsToken, string strsnsTwiterToken, string strSort, string strEmail, string strsnsId, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void retirementRequest(string strEmail, string strpw, string strsort, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void passwordEmailTransRequest(string strEmail, string strSort, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void passwordResetRequest(string strpw, string strSort, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void appListSearchRequest(string strcountry, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void appDetailReqeust(string strproductid, string strcountry, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void setDeviceStatus(NativeDelegateStatusNotification callback); // 디바이스 상태가 on/off  line 확인


    public static iOSManager GetInstance()
    {
        if( _instance == null )
        {
            _instance = new GameObject("iOSManager").AddComponent<iOSManager>();
        }
        return _instance;
    }
    [MonoPInvokeCallback(typeof(NativeDelegateNotification))]
    public static void iOS_Callback(bool bSuccess, string strMessage)
    {
        Debug.Log("***************************");
        Debug.Log(strMessage);

        Postbox.GetInstance.PushData(strMessage);
    }

    [MonoPInvokeCallback(typeof(NativeDelegateStatusNotification))]
    public static void iOS_STATUS_Callback(bool bSuccess)
    {
        Debug.Log("===========>");

    }




    public void CalliOSLogin()
    {
        Debug.Log("Unity::Plugin::LoginReqeust");
        LoginReqeust("samyoung79@naver.com","sam30230",iOS_Callback);
    }
    public void CalliOSSendMessage()
    {
        Debug.Log("Unity::Plugin::SendMessageRequest");
        SendMessageRequest("fjkfjalksjdfkljs",iOS_Callback);
    }

    public void CalliOSJoin()
    {
        Debug.Log("Unity::Plugin::JoinReqeust");
        JoinReqeust("samyoung79@naver.com","sam30230","jung",iOS_Callback);
    }
    public void CalliOSDeviceConnect()
    {
        Debug.Log("Unity::Plugin::DeviceConnectRequest");
        DeviceConnectRequest("test_ios_service_001",iOS_Callback);   
    }
    public void CalliOSDeviceRelease()
    {
       Debug.Log("Unity::Plugin::DeviceQuitRequest");
       DeviceQuitRequest("test_ios_service_001",iOS_Callback);
    }
    public void CalliOSDeviceList()
    {
        
    }


    public void CallDeviceStatus(){
        Debug.Log("Unity::Plugin::setDeviceStatus");

        setDeviceStatus(iOS_STATUS_Callback);
        

    }


    public void ResponseData(string data)
    {
        Debug.Log("Unity ==> ResponseData :" + data);
    //    LoadingDialog.Dismiss();
    //    t.text = "AADVD";
    //    Test.TestFoo();
    //    Dialog.Show(data);
    }



    private IEnumerator CheckQueue() // 아이아라 커스텀
    {
        Debug.Log("Unity ==> CheckQueue :start "); 
        WaitForSeconds waitSec = new WaitForSeconds(2);

        while (true)
        {
            //우편함에서 데이타 꺼내기
            string data = Postbox.GetInstance.GetData();

            //우편함에 데이타가 있는 경우
            if (!data.Equals(string.Empty))
            {
                //데이타로 UI 갱신
                Debug.Log("Unity ==> CheckQueue :" + data);
                //ResponseData(data);
                //yield break;
            }

            yield return waitSec;
        }
    }

}
