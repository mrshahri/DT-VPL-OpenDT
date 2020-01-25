package com.cpmc.ultimaker.controller;

import models.DTModel;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import utils.DTStorageManager;

import java.util.UUID;

@Controller
@RequestMapping("mashup")
public class DTMashupCenter {

    @RequestMapping(value = "publication", method = RequestMethod.GET)
    public String getPublicationCenterPage(ModelMap model) {
        DTStorageManager dtStorageManager = new DTStorageManager();
        model.addAttribute("publishedDTs", dtStorageManager.getExistingDTModels());
        return "dt-publication-center";
    }

    @RequestMapping(value = "publish", method = RequestMethod.POST)
    public ResponseEntity publishDigitalTwin(@RequestBody DTModel dtModel, ModelMap model) {
        if (isNullorEmpty(dtModel.getDtName()) || isNullorEmpty(dtModel.getDtEndpoint())) {
            return new ResponseEntity(HttpStatus.BAD_REQUEST);
        }
        dtModel.setDtId(UUID.randomUUID().toString());
        DTStorageManager dtStorageManager = new DTStorageManager();
        dtStorageManager.insertDTModel(dtModel);
        model.addAttribute("publishedDTs", dtStorageManager.getExistingDTModels());
        dtStorageManager.persist();
        return new ResponseEntity(dtModel, HttpStatus.OK);
    }

    @RequestMapping(value = "creation", method = RequestMethod.GET)
    public String getMashupCreationCenter() {
        return "dt-mashup-creation-center";
    }

    private boolean isNullorEmpty(String string) {
        if (string == null || string.equals("")) {
            return true;
        }
        return false;
    }
}
