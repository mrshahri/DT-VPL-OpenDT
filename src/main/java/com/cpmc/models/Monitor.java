package com.cpmc.models;

/**
 * Created by Rakib on 11/18/2015.
 */
public class Monitor {
    private String deviceName = "NA";
    private String deviceUUID = "NA";

    private String timeStamp = "NA";
    private String bedTemperature = "NA";
    private String nozzleTemperature = "NA";
    private String progress = "NA";
    private String availability = "NA";
    private String grabber = "NA";
    private String grabRotation = "NA";

    private String xPosition = "NA";
    private String xTimeStamp = "NA";
    private String yPosition = "NA";
    private String yTimeStamp = "NA";
    private String zPosition = "NA";
    private String zTimeStamp = "NA";

    public Monitor() {
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getDeviceUUID() {
        return deviceUUID;
    }

    public void setDeviceUUID(String deviceUUID) {
        this.deviceUUID = deviceUUID;
    }

    public String getTimeStamp() {
        return timeStamp;
    }

    public void setTimeStamp(String timeStamp) {
        this.timeStamp = timeStamp;
    }

    public String getBedTemperature() {
        return bedTemperature;
    }

    public void setBedTemperature(String bedTemperature) {
        this.bedTemperature = bedTemperature;
    }

    public String getNozzleTemperature() {
        return nozzleTemperature;
    }

    public void setNozzleTemperature(String nozzleTemperature) {
        this.nozzleTemperature = nozzleTemperature;
    }

    public String getProgress() {
        return progress;
    }

    public void setProgress(String progress) {
        this.progress = progress;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }


    public String getGrabber() {
        return grabber;
    }

    public void setGrabber(String grabber) {
        this.grabber = grabber;
    }

    public String getGrabRotation() {
        return grabRotation;
    }

    public void setGrabRotation(String grabRotation) {
        this.grabRotation = grabRotation;
    }

    public String getxPosition() {
        return xPosition;
    }

    public void setxPosition(String xPosition) {
        this.xPosition = xPosition;
    }

    public String getyPosition() {
        return yPosition;
    }

    public void setyPosition(String yPosition) {
        this.yPosition = yPosition;
    }

    public String getzPosition() {
        return zPosition;
    }

    public void setzPosition(String zPosition) {
        this.zPosition = zPosition;
    }

    public String getxTimeStamp() {
        return xTimeStamp;
    }

    public void setxTimeStamp(String xTimeStamp) {
        this.xTimeStamp = xTimeStamp;
    }

    public String getyTimeStamp() {
        return yTimeStamp;
    }

    public void setyTimeStamp(String yTimeStamp) {
        this.yTimeStamp = yTimeStamp;
    }

    public String getzTimeStamp() {
        return zTimeStamp;
    }

    public void setzTimeStamp(String zTimeStamp) {
        this.zTimeStamp = zTimeStamp;
    }
}
