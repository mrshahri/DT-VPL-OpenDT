package models;

import java.util.ArrayList;
import java.util.List;

/**
 * This class mocks a Digital Twin repository. As there are
 * only 5 Digital Twins to save, we are not making a database.
 *
 */
public class DTRepoMock {
    private List<DigitalTwin> digitalTwins;

    public DTRepoMock() {
        // initiate the list
        digitalTwins = new ArrayList<>();

        // DT Bukito
        DigitalTwin bukitoDT = new DigitalTwin();
        bukitoDT.setDigitalTwinId("bukito");
        bukitoDT.setDigitalTwinName("Bukito 3D Printer");
        bukitoDT.setAssemblyLine(new ArrayList<DigitalTwin>());
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
        digitalTwins.add(bukitoDT);

        // DT UARM 1
        DigitalTwin uarmDT = new DigitalTwin();
        uarmDT.setDigitalTwinId("uarm");
        uarmDT.setDigitalTwinName("UARM Robotic Arm");
        uarmDT.setAssemblyLine(new ArrayList<DigitalTwin>());
        uarmDT.setMonitorUrl("");
        uarmDT.setOperationUrl("");
        bukitoDT.setOperations(new ArrayList<String>());
        modelUrls = new ArrayList<>();
        modelUrls.add("/resources/models/uarm/uarm-single-assembly");
        uarmDT.setModelURLs(modelUrls);
        uarmDT.setPreviewImageUrl("/resources/models/uarm.jpg");
        digitalTwins.add(uarmDT);

        // DT UARM 2

        // DT Ultimaker

        // DT XCarve
    }

    public List<DigitalTwin> getDigitalTwins() {
        return digitalTwins;
    }

    public void setDigitalTwins(List<DigitalTwin> digitalTwins) {
        this.digitalTwins = digitalTwins;
    }
}
