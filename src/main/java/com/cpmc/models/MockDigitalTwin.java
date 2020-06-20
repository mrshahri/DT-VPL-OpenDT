package com.cpmc.models;

import java.util.List;

public class MockDigitalTwin {
    private String digitalTwinId;
    private String digitalTwinName;
    private List<MockDigitalTwin> assemblyLine;
    private String monitorUrl;
    private String operationUrl;
    private List<String> operations;
    private List<String> modelURLs;

    private String previewImageUrl;

    public MockDigitalTwin() {
    }

    public String getDigitalTwinId() {
        return digitalTwinId;
    }

    public void setDigitalTwinId(String digitalTwinId) {
        this.digitalTwinId = digitalTwinId;
    }

    public String getDigitalTwinName() {
        return digitalTwinName;
    }

    public void setDigitalTwinName(String digitalTwinName) {
        this.digitalTwinName = digitalTwinName;
    }

    public List<MockDigitalTwin> getAssemblyLine() {
        return assemblyLine;
    }

    public void setAssemblyLine(List<MockDigitalTwin> assemblyLine) {
        this.assemblyLine = assemblyLine;
    }

    public String getMonitorUrl() {
        return monitorUrl;
    }

    public void setMonitorUrl(String monitorUrl) {
        this.monitorUrl = monitorUrl;
    }

    public String getOperationUrl() {
        return operationUrl;
    }

    public void setOperationUrl(String operationUrl) {
        this.operationUrl = operationUrl;
    }

    public List<String> getOperations() {
        return operations;
    }

    public void setOperations(List<String> operations) {
        this.operations = operations;
    }

    public List<String> getModelURLs() {
        return modelURLs;
    }

    public void setModelURLs(List<String> modelURLs) {
        this.modelURLs = modelURLs;
    }

    public String getPreviewImageUrl() {
        return previewImageUrl;
    }

    public void setPreviewImageUrl(String previewImageUrl) {
        this.previewImageUrl = previewImageUrl;
    }
}
