package com.cpmc.models;

public class Service {
    private String serviceName;
    private String endPoint;
    private String type;
    private String scope;
    private String[] config;

    public Service() {
    }

    public String getServiceName() {
        return serviceName;
    }

    public String getEndPoint() {
        return endPoint;
    }

    public String getType() {
        return type;
    }

    public String getScope() {
        return scope;
    }

    public String[] getConfig() {
        return config;
    }

    public Boolean isMashup() {
        if (config == null) {
            return false;
        }
        return true;
    }
}
