import 'package:flutter/cupertino.dart';
import 'package:mesibo_flutter_sdk/mesibo.dart';

class MesiboService implements MesiboConnectionListener,MesiboLocationListener  {

  static Mesibo mesibo = Mesibo();
  static MesiboUI _mesiboUi = MesiboUI();
  String _mesiboStatus = 'Mesibo status: Not Connected.';
  Text? mStatusText;
  bool authFail = false;
  String mAppId = "com.example.mesibo_chat_assignment";
  bool mOnline = false;
   Future<void> initMesibo(String token) async {
    // optional - only to show alert in AUTHFAIL case
    Future<String> asyncAppId = mesibo.getAppIdForAccessToken();
    asyncAppId.then((String appid) { mAppId = appid; });

    // initialize mesibo
    mesibo.setAccessToken(token);
    mesibo.setListener(this);
    mesibo.start();

    /* Optional - to get missed call notification MesiboCall_onNotify */
    // MesiboCall.setListener(this);

    /**************************************************************************************************
        Optional - To use mesibo Location APIs

        https://docs.mesibo.com/api/secure-location/
     **************************************************************************************************/
    mesibo.getLocationManager().setListener(this);


    /**************************************************************************************************
        override default UI text, colors, etc.Refer to the documentation

        https://docs.mesibo.com/ui-modules/

        Also refer to the header file for complete list of parameters (applies to both Android/iOS)
        https://github.com/mesibo/mesiboframeworks/blob/main/mesiboui.framework/Headers/MesiboUI.h#L170
     **************************************************************************************************/

    _mesiboUi.getUiDefaults().then((MesiboUIOptions options) {
      options.enableBackButton = true;
      options.appName = "My First App";
      options.toolbarColor = 0xff00868b;
      _mesiboUi.setUiDefaults(options);
    });

    /**************************************************************************************************
        The code below enables basic UI customization.

        However, you can customize entire user interface by implementing MesiboUIListner for Android and
        iOS. Refer to

        https://docs.mesibo.com/ui-modules/customizing/
     **************************************************************************************************/

    MesiboUIButtons buttons = MesiboUIButtons();
    buttons.message = true;
    buttons.audioCall = true;
    buttons.videoCall = true;
    buttons.groupAudioCall = true;
    buttons.groupVideoCall = true;
    buttons.endToEndEncryptionInfo = false; // e2ee should be enabled
    _mesiboUi.setupBasicCustomization(buttons, null);

    MesiboCallUiProperties cp = MesiboCallUiProperties();
    cp.showScreenSharing = false;
    _mesiboUi.setCallUiDefaults(cp);
  }
  void showUserList() {
    if(!mOnline) return;
    _mesiboUi.launchUserList();
  }

  @override
  void Mesibo_onConnectionStatus(int status) {
    print('Mesibo_onConnectionStatus: ' + status.toString());

    if(authFail) return;  // to prevent overwriting displayed status
    String statusText = status.toString();
    if(status == Mesibo.MESIBO_STATUS_ONLINE) {
      statusText = "Online";
      mOnline=true;
    } else if(status == Mesibo.MESIBO_STATUS_CONNECTING) {
      statusText = "Connecting";
    } else if(status == Mesibo.MESIBO_STATUS_CONNECTFAILURE) {
      statusText = "Connect Failed";
    } else if(status == Mesibo.MESIBO_STATUS_NONETWORK) {
      statusText = "No Network";
    } else if(status == Mesibo.MESIBO_STATUS_AUTHFAIL) {
      authFail = true;
      String warning = "The token is invalid. Ensure that you have used appid \"" + mAppId + "\" to generate Mesibo user access token";
      statusText = warning;
      print(warning);

    }

    _mesiboStatus = 'Mesibo status: ' + statusText;



  }

  @override
  void Mesibo_onDeviceLocation(MesiboLocation location) {
    printLocation(location, "Device Location Update");
  }

  @override
  void Mesibo_onLocationReceived(MesiboProfile profile) async {
    print("Mesibo_onLocationReceived");
    // MesiboLocation? loc = await profile.location().get() as MesiboLocation?;
    // printLocation(loc, "profile Location updated");
  }

  @override
  void Mesibo_onLocationRequest(MesiboProfile profile, int duration) {
    print("Mesibo_onLocationRequest");
  }

  @override
  void Mesibo_onLocationShared(MesiboProfile profile, int duration) {
    print("Mesibo_onLocationShared");
  }

  @override
  void Mesibo_onLocationError(MesiboProfile profile, int error) {
    print("Mesibo_onLocationError");
  }





  void printLocation(MesiboLocation? loc, String name) {
    if(null == loc)
      print("${name}: null");
    else
      print("${name}: lat ${loc.latitude} lon ${loc.longitude}");
  }


}