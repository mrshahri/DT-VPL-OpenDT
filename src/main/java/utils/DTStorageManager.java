package utils;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;
import models.DTModel;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DTStorageManager {

    private String fileName = "/storage/published-dt.json";
    private Gson gson;
    private List<DTModel> models;

    public DTStorageManager() {
        gson = new Gson();
        models = new ArrayList<>();
        try {
            ClassLoader classLoader = getClass().getClassLoader();
            File file = new File(classLoader.getResource(fileName).getFile());
            JsonReader reader = new JsonReader(new FileReader(file));
            DTModel[] models = gson.fromJson(reader, DTModel[].class);
            if (models != null && models.length > 0) {
                this.models.addAll(Arrays.asList(models));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<DTModel> getExistingDTModels () {
        return this.models;
    }

    public void insertDTModel (DTModel model) {
        for (DTModel m : this.models) {
            if (m.getDtName().equals(model.getDtName())) {
                return;
            }
        }
        this.models.add(model);
    }

    public void persist() {
//        TypeA[] array = a.toArray(new TypeA[a.size()]);

        DTModel[] models = this.models.toArray(new DTModel[this.models.size()]);
        // Java objects to File
        ClassLoader classLoader = getClass().getClassLoader();
        try (FileWriter writer = new FileWriter(classLoader.getResource(fileName).getFile())) {
            //Object to JSON in file
            gson.toJson(models, writer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
