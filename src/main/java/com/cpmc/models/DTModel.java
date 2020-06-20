package com.cpmc.models;

import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

public class DTModel {
    private String dtId;
    private String dtName;
    private String dtType;
    private String dtEndpoint;
    private String dtDescription;
    private String dtPrimaryCategory;
    private String dtSecondaryCategory;
    private String scope;

    public DTModel() {
    }

    public String getDtId() {
        return dtId;
    }

    public void setDtId(String dtId) {
        this.dtId = dtId;
    }

    public String getDtName() {
        return dtName;
    }

    public void setDtName(String dtName) {
        this.dtName = dtName;
    }

    public String getDtType() {
        return dtType;
    }

    public void setDtType(String dtType) {
        this.dtType = dtType;
    }

    public String getDtEndpoint() {
        return dtEndpoint;
    }

    public void setDtEndpoint(String dtEndpoint) {
        this.dtEndpoint = dtEndpoint;
    }

    public String getDtDescription() {
        return dtDescription;
    }

    public void setDtDescription(String dtDescription) {
        this.dtDescription = dtDescription;
    }

    public String getDtPrimaryCategory() {
        return dtPrimaryCategory;
    }

    public void setDtPrimaryCategory(String dtPrimaryCategory) {
        this.dtPrimaryCategory = dtPrimaryCategory;
    }

    public String getDtSecondaryCategory() {
        return dtSecondaryCategory;
    }

    public void setDtSecondaryCategory(String dtSecondaryCategory) {
        this.dtSecondaryCategory = dtSecondaryCategory;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public String getData(String param) {
        if (param==null || param.isEmpty()) {
            throw new IllegalArgumentException("Request parameter not valid");
        }
        final String uri = "http://localhost:9002/virtualization-uark/monitor?deviceId=" + dtName;
        RestTemplate restTemplate = new RestTemplate();
        Monitor monitor = restTemplate.getForObject(uri, Monitor.class);
        if ("nozzleTemperature".equals(param)) {
            return monitor.getNozzleTemperature();
        } else if ("bedTemperature".equals(param)) {
            return monitor.getBedTemperature();
        } else if ("progress".equals(param)) {
            return monitor.getProgress();
        } else {
            return "Data item not found. Please check item name.";
        }
    }

    public String invokeService(String param) {
        String jsonString = "{\"deviceId\":\""+ dtName + "\", \"operationId\":\"reset\", \"parameters\":[]}";
        final String uri = "http://localhost:9002/virtualization-uark/operate/device";
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.postForEntity(uri, jsonString, ResponseEntity.class);
        return "Success";
    }
}
