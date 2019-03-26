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
    delegate void NativeDelegateDataNotification(bool bSuccess, string strMessage,string[] data);


    [DllImport("__Internal")]
    private static extern void JoinReqeust(string strEmail,string strpw,string strName, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void LoginReqeust(string strEmail, string strpw, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void SendMessageRequest(string strMessage, NativeDelegateDataNotification callback);

    [DllImport("__Internal")]
    private static extern void DeviceConnectRequest(string strDevice, string strEmail, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void DeviceQuitRequest(string strDevice, NativeDelegateNotification callback);

    [DllImport("__Internal")]
    private static extern void DeviceListRequest(string strEmail, NativeDelegateDataNotification callback);


    public static iOSManager GetInstance()
    {
        if( _instance == null )
        {
            _instance = new GameObject("iOSManager").AddComponent<iOSManager>();
        }
        return _instance;
    }


    [MonoPInvokeCallback(typeof(NativeDelegateNotification))]
    public static void JoinCallback(bool bSuccess, string strMessage)
    {
        Debug.Log("Unity::Plugin::JoinCallback");
    }

     [MonoPInvokeCallback(typeof(NativeDelegateNotification))]
    public static void LoginCallback(bool bSuccess, string strMessage)
    {
        Debug.Log("Unity::Plugin::LoginCallback");
    }

    [MonoPInvokeCallback(typeof(NativeDelegateDataNotification))]
    public static void SendMessageCallback(bool bSuccess, string strMessage,string[] data)
    {
        Debug.Log("Unity::Plugin::SendMessageCallback");

    }

    [MonoPInvokeCallback(typeof(NativeDelegateNotification))]
    public static void DeviceConnectCallback(bool bSuccess, string strMessage)
    {
        Debug.Log("Unity::Plugin::DeviceConnectCallback");

    }
    
    [MonoPInvokeCallback(typeof(NativeDelegateNotification))]
    public static void DeviceQuitCallback(bool bSuccess, string strMessage)
    {
         Debug.Log("Unity::Plugin::DeviceQuitCallback");

    }

    [MonoPInvokeCallback(typeof(NativeDelegateDataNotification))]
    public static void DeviceListCallback(bool bSuccess, string strMessage, string[] data)
    {
        Debug.Log("Unity::Plugin::DeviceListCallback");
        Debug.Log("Device List : " + data[0]);
    }
  
    public void CalliOSLogin()
    {
        Debug.Log("Unity::Plugin::LoginReqeust");
        LoginReqeust("samyoung79@naver.com","sam30230",LoginCallback);
    }
    public void CalliOSSendMessage()
    {
        Debug.Log("Unity::Plugin::SendMessageRequest");
        SendMessageRequest("fjkfjalksjdfkljs",SendMessageCallback);
    }

    public void CalliOSJoin()
    {
        Debug.Log("Unity::Plugin::JoinReqeust");
        JoinReqeust("samyoung79@naver.com","sam30230","jung",JoinCallback);
    }
    public void CalliOSDeviceConnect()
    {
        Debug.Log("Unity::Plugin::DeviceConnectRequest");
        DeviceConnectRequest("test_ios_service_001","samyoung79@naver.com",DeviceConnectCallback);   
    }
    public void CalliOSDeviceRelease()
    {
       Debug.Log("Unity::Plugin::DeviceQuitRequest");
       DeviceQuitRequest("test_ios_service_001",DeviceQuitCallback);
    }
    public void CalliOSDeviceList()
    {
        Debug.Log("Unity::Plugin::DeviceListRequest");
        DeviceListRequest("samyoung79@naver.com",DeviceListCallback);
    }

}
