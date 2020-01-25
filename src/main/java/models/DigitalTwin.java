package models;

public class DigitalTwin {
    private String id;
    private String name;
    private String primaryType;
    private String secondaryType;
    private Service[] services;

    public DigitalTwin() {
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getPrimaryType() {
        return primaryType;
    }

    public String getSecondaryType() {
        return secondaryType;
    }

    public Service[] getServices() {
        return services;
    }
}
