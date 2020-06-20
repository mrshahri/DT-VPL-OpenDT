package com.cpmc.utils;

import com.cpmc.models.DTModel;

public class DTPlatform {
    public String getTestName() {
        return testName;
    }

    private String testName = "testadsadsads";
    private DTPlatformManager platformManager;
    private static DTPlatform platform;

    private DTPlatform() {
        platformManager = new DTPlatformManager();

//         Dummy
//        DTModel dtModel = new DTModel();
//        dtModel.setDtId("Ultimaker01");
//        platformManager.getAllModels().add(dtModel);
    }

    public DTPlatformManager getPlatformManager() {
        return this.platformManager;
    }

    public static DTPlatform getPlatform() {
        if (platform == null) {
            platform = new DTPlatform();
        }
        return platform;
    }
}
