class CmpSDKOptions {
    String appURL = "";
    String cdnURL = "";
    String tenantID = "";
    String appID = "";
    bool testingMode = false;
    String loggerLevel = "DEBUG";
    int consentsCheckInterval = 1800;
    String? subjectId;
    String? languageCode;
    String? locationCode;

    Map<String, dynamic> toMap() {
      return {
        'appURL': appURL,
        'cdnURL': cdnURL,
        'tenantID': tenantID,
        'appID': appID,
        'testingMode': testingMode,
        'loggerLevel': loggerLevel,
        'consentsCheckInterval': consentsCheckInterval,
        'subjectId': subjectId,
        'languageCode': languageCode,
        'locationCode': locationCode,
      };
    }
}