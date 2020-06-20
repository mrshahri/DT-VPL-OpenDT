package com.cpmc.models;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class DigitalTwinFactory {
    public static DigitalTwin createDigitalTwin(String name) {
        DigitalTwin digitalTwin = null;
        try {
            ClassLoader classLoader = DigitalTwinFactory.class.getClassLoader();
            File file = new File(classLoader.getResource("/dt-descriptors/" + name + ".json").getFile());
            JsonReader reader = new JsonReader(new FileReader(file));
            Gson gson = new Gson();
            digitalTwin = gson.fromJson(reader, DigitalTwin.class);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return digitalTwin;
    }
}
