using UnityEngine;
using System.Collections;
using System;
using UnityEngine.UI;
using System.Runtime.InteropServices;
public class PluginMercury : MonoBehaviour
{

#if UNITY_ANDROID
    public static AndroidJavaObject _plugin;
#elif UNITY_IPHONE
    [DllImport ("__Internal")]
    private static extern void ActiveRewardVideo_IOS();
    [DllImport ("__Internal")]
    private static extern void ActiveInterstitial_IOS();
    [DllImport ("__Internal")]
    private static extern void ActiveBanner_IOS();
    [DllImport ("__Internal")]
    private static extern void ActiveNative_IOS();
    [DllImport ("__Internal")]
    private static extern void GameInit();
    [DllImport("__Internal")]
    private static extern void BuyProduct(string s);//购买商品(AppStore)
    [DllImport ("__Internal")]
    private static extern void MercuryLogin_IOS();
    [DllImport ("__Internal")]
    private static extern void UploadGameData_IOS(string data);
    [DllImport ("__Internal")]
    private static extern void DownloadGameData_IOS();
    [DllImport ("__Internal")]
    private static extern void Data_UseItem_IOS(string quantity,string item);
    [DllImport ("__Internal")]
    private static extern void Data_LevelBegin_IOS(string eventID);
    [DllImport ("__Internal")]
    private static extern void Data_LevelCompleted_IOS(string eventID);
    [DllImport ("__Internal")]
    private static extern void Data_Event_IOS(string eventID);
    [DllImport ("__Internal")]
    private static extern void Redeem_IOS(string code);
    
#endif

    public static PluginMercury pInstance;
    public static String my_redeem_code="abc";
    public static PluginMercury Instance
    {
        get
        {
            return pInstance;
        }
    }
    private void Update() {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            ExitGame();
        }
    }
    void Awake()
    {
        if (pInstance != null)
        {
            Destroy(gameObject);
            return;
        }
        DontDestroyOnLoad(gameObject);
        pInstance = this;
        GetAndroidInstance();//得到安卓实例
    }

    public void GetAndroidInstance()
    {
#if UNITY_EDITOR
    print("[UNITY_EDITOR]->GetAndroidInstance");
#elif UNITY_ANDROID
        //安卓获取实例
        using (var pluginClass = new AndroidJavaClass("com.singmaan.game.GameActivity"))
        {
            _plugin = pluginClass.CallStatic<AndroidJavaObject>("getInstance");
        }
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->GameInit()");
        GameInit();
#endif
    }

    public void Purchase(string strProductId)
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->Purchase()->strProductId=" + strProductId);
#elif UNITY_ANDROID
        print("[UNITY_ANDROID]->Purchase()->strProductId="+strProductId);
        _plugin.Call("Purchase", strProductId );
#elif UNITY_IPHONE
        BuyProduct(strProductId);
#endif
    }
    public void Redeem()
    {
#if UNITY_EDITORRedeem
        print("[UNITY_EDITOR]->Redeem()");
#elif UNITY_ANDROID
        print("[Android]->Redeem()");_plugin.Call("Redeem");
#elif UNITY_IPHONE
        Redeem_IOS(my_redeem_code);
#endif
    }

    public void GetProductionInfo()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->GetProductionInfo()");
#elif UNITY_ANDROID
        print("[Android]->GetProductionInfo()");_plugin.Call("GetProductionInfo");
#endif
    }

    public void RestorePruchase()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->RestorePruchase()");
#elif UNITY_ANDROID
        print("[Android]->RestorePruchase()");_plugin.Call("RestorePruchase");
#endif
    }


    public void ExitGame()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->ExitGame()");
#elif UNITY_ANDROID
        print("[Android]->ExitGame()");_plugin.Call("ExitGame");
#elif UNITY_IPHONE
        print("a");
#endif
    }


    public void UploadGameData(String data)
    {
        print("[UNITY_EDITOR]->UploadGameData():"+data);
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->UploadGameData()");
#elif UNITY_ANDROID
        print("[Android]->UploadGameData()");_plugin.Call("UploadGameData",data);
#elif UNITY_IPHONE
        UploadGameData_IOS(data);
#endif
    }

    public void DownloadGameData()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->DownloadGameData()");
#elif UNITY_ANDROID
        print("[Android]->DownloadGameData()");_plugin.Call("DownloadGameData");
#elif UNITY_IPHONE
        DownloadGameData_IOS();
#endif
    }


    public void SingmaanLogin()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->SingmaanLogin()");
#elif UNITY_ANDROID
        print("[Android]->SingmaanLogin()");_plugin.Call("SingmaanLogin");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->MercuryLogin()");
        MercuryLogin_IOS();
#endif
    }

    public void SingmaanLogout()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->SingmaanLogout()");
#elif UNITY_ANDROID
        print("[Android]->SingmaanLogout()");_plugin.Call("SingmaanLogout");
#endif
    }


    public void ActiveRewardVideo()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->ActiveRewardVideo()");
#elif UNITY_ANDROID
        print("[Android]->ActiveRewardVideo()");_plugin.Call("ActiveRewardVideo");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->ActiveRewardVideo()");
        ActiveRewardVideo_IOS();
#endif
    }

    public void ActiveInterstitial()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->ActiveInterstitial()");
#elif UNITY_ANDROID
        print("[Android]->ActiveInterstitial()");_plugin.Call("ActiveInterstitial");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->ActiveInterstitial()");
        ActiveInterstitial_IOS();
#endif
    }
    public void ActiveBanner()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->ActiveBanner()");
#elif UNITY_ANDROID
        print("[Android]->ActiveBanner()");_plugin.Call("ActiveBanner");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->ActiveBanner()");
#endif
    }
    public void ActiveNative()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->ActiveNative()");
#elif UNITY_ANDROID
        print("[Android]->ActiveNative()");_plugin.Call("ActiveNative");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->ActiveNative()");
#endif
    }

    public void Data_UseItem(string quantity,string item)
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->Data_UseItem()->eventID=" + quantity);
#elif UNITY_ANDROID
        print("[UNITY_ANDROID]->Data_UseItem()->eventID="+quantity);
        _plugin.Call("Data_UseItem", quantity, item);
#elif UNITY_IPHONE
        Data_UseItem_IOS(quantity,item);
#endif
    }

    public void Data_LevelBegin(string eventID)
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->Data_LevelBegin()->eventID=" + eventID);
#elif UNITY_ANDROID
        print("[UNITY_ANDROID]->Data_LevelBegin()->eventID="+eventID);
        _plugin.Call("Data_LevelBegin", eventID);
#elif UNITY_IPHONE
        Data_LevelBegin_IOS(eventID);
#endif
    }

    public void Data_LevelCompleted(string eventID)
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->Data_LevelCompleted()->eventID=" + eventID);
#elif UNITY_ANDROID
        print("[UNITY_ANDROID]->Data_LevelCompleted()->eventID="+eventID);
        _plugin.Call("Data_LevelCompleted", eventID);
#elif UNITY_IPHONE
        Data_LevelCompleted_IOS(eventID);
#endif
    }

    public void Data_Event(string eventID)
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->Data_Event()->eventID=" + eventID);
#elif UNITY_ANDROID
        print("[UNITY_ANDROID]->Data_Event()->eventID="+eventID);
        _plugin.Call("Data_Event", eventID);
#elif UNITY_IPHONE
        Data_Event_IOS(eventID);
#endif
    }

    public void RateGame()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->RateGame()");
#elif UNITY_ANDROID
        print("[Android]->RateGame()");_plugin.Call("RateGame");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->RateGame()");
#endif
    }


    public void ShareGame()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->ShareGame()");
#elif UNITY_ANDROID
        print("[Android]->ShareGame()");_plugin.Call("ShareGame");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->ShareGame()");
#endif
    }

        public void VIPPanel()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->VIPPanel()");
#elif UNITY_ANDROID
        print("[Android]->VIPPanel()");_plugin.Call("VIPPanel");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->VIPPanel()");
#endif
    }


    public void DailyCheckInPanel()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->DailyCheckInPanel()");
#elif UNITY_ANDROID
        print("[Android]->DailyCheckInPanel()");_plugin.Call("DailyCheckInPanel");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->DailyCheckInPanel()");
#endif
    }


    public void OpenGameCommunity()
    {
#if UNITY_EDITOR
        print("[UNITY_EDITOR]->OpenGameCommunity()");
#elif UNITY_ANDROID
        print("[Android]->OpenGameCommunity()");_plugin.Call("OpenGameCommunity");
#elif UNITY_IPHONE
        print("[UNITY_IPHONE]->OpenGameCommunity()");
#endif
    }

    public void PurchaseSuccessCallBack(string msg)
    {
        print("[Unity]->PurchaseSuccessCallBack"+msg);
    }
    public void PurchaseFailedCallBack(string msg)
    {
        print("[Unity]->PurchaseFailedCallBack"+msg);
    }
    public void LoginSuccessCallBack(string msg)
    {
        print("[Unity]->LoginSuccessCallBack"+msg);
    }
    public void LoginCancelCallBack(string msg)
    {
        print("[Unity]->LoginCancelCallBack"+msg);
    }
    public void AdLoadSuccessCallBack(string msg)
    {
        print("[Unity]->AdLoadSuccessCallBack"+msg);
    }
    public void AdLoadFailedCallBack(string msg)
    {
        print("[Unity]->AdLoadFailedCallBack"+msg);
    }
    public void AdShowSuccessCallBack(string msg)
    {
        print("[Unity]->AdShowSuccessCallBack"+msg);
    }
    public void AdShowFailedCallBack(string msg)
    {
        print("[Unity]->AdShowFailedCallBack"+msg);
    }
    public void onFunctionCallBack(string msg)
    {
        print("[Unity]->onFunctionCallBack"+msg);
    }
    public void ProductionIDCallBack(string msg)
    {
        print("[Unity]->ProductionIDCallBack"+msg);
    }
    public void OnClaimReward(string msg)
    {
        print("[Unity]->OnClaimReward"+msg);
    }

}

