package com.cpmc.models;

import java.util.ArrayList;
import java.util.List;

/**
 * This class mocks a Digital Twin repository. As there are
 * only 5 Digital Twins to save, we are not making a database.
 *
 */
public class DTRepoMock {
    private List<MockDigitalTwin> mockDigitalTwins;

    public DTRepoMock() {
        // initiate the list
        mockDigitalTwins = new ArrayList<>();

        // DT Bukito
        MockDigitalTwin bukitoDT = new MockDigitalTwin();
        bukitoDT.setDigitalTwinId("bukito");
        bukitoDT.setDigitalTwinName("Bukito 3D Printer");
        bukitoDT.setAssemblyLine(new ArrayList<MockDigitalTwin>());
        bukitoDT.setMonitorUrl("");
        bukitoDT.setOperationUrl("");
        bukitoDT.setOperations(new ArrayList<String>());
        List<String> modelUrls = new ArrayList<>();
        modelUrls.add("/resources/models/bukito/bed-assembly");
        modelUrls.add("/resources/models/bukito/crane-arm-assembly");
        modelUrls.add("/resources/models/bukito/hotend-carriage-assembly");
        modelUrls.add("/resources/models/bukito/machine-assembly");
        bukitoDT.setModelURLs(modelUrls);
        bukitoDT.setPreviewImageUrl("/resources/images/bukito.jpg");
        mockDigitalTwins.add(bukitoDT);

        // DT UARM 1
        MockDigitalTwin uarmDT = new MockDigitalTwin();
        uarmDT.setDigitalTwinId("uarm");
        uarmDT.setDigitalTwinName("UARM Robotic Arm");
        uarmDT.setAssemblyLine(new ArrayList<MockDigitalTwin>());
        uarmDT.setMonitorUrl("");
        uarmDT.setOperationUrl("");
        bukitoDT.setOperations(new ArrayList<String>());
        modelUrls = new ArrayList<>();
        modelUrls.add("/resources/models/uarm/uarm-single-assembly");
        uarmDT.setModelURLs(modelUrls);
        uarmDT.setPreviewImageUrl("/resources/models/uarm.jpg");
        mockDigitalTwins.add(uarmDT);

        // DT UARM 2

        // DT Ultimaker

        // DT XCarve
    }

    public List<MockDigitalTwin> getMockDigitalTwins() {
        return mockDigitalTwins;
    }

    public void setMockDigitalTwins(List<MockDigitalTwin> mockDigitalTwins) {
        this.mockDigitalTwins = mockDigitalTwins;
    }
}
