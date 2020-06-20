package com.cpmc.controllers;

import com.cpmc.models.DTModel;
import com.cpmc.models.TestOpModel;
import com.cpmc.utils.DTPlatform;
import com.cpmc.utils.DTPlatformManager;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.UUID;

@Controller
@RequestMapping("mashup")
public class DTMashupCenter {

    @RequestMapping(value = "publication", method = RequestMethod.GET)
    public String getPublicationCenterPage(ModelMap model) {
        DTPlatformManager dtPlatformManager = new DTPlatformManager();
        model.addAttribute("publishedDTs", dtPlatformManager.getAllModels());
        return "dt-publication-center";
    }

    @RequestMapping(value = "publish", method = RequestMethod.POST)
    public ResponseEntity publishDigitalTwin(@RequestBody DTModel dtModel, ModelMap model) {
        if (isNullorEmpty(dtModel.getDtName()) || isNullorEmpty(dtModel.getDtEndpoint())) {
            return new ResponseEntity(HttpStatus.BAD_REQUEST);
        }
        dtModel.setDtId(UUID.randomUUID().toString());
        DTPlatformManager dtPlatformManager = new DTPlatformManager();
        dtPlatformManager.insertDTModel(dtModel);
        model.addAttribute("publishedDTs", dtPlatformManager.getAllModels());
        dtPlatformManager.persist();
        return new ResponseEntity(dtModel, HttpStatus.OK);
    }

    @RequestMapping(value = "creation", method = RequestMethod.GET)
    public String getMashupCreationCenter(ModelMap model) {

        return "dt-mashup-creation-center";
    }

    private boolean isNullorEmpty(String string) {
        if (string == null || string.equals("")) {
            return true;
        }
        return false;
    }

    @RequestMapping(value = "demo", method = RequestMethod.GET)
    public String getMashupDemoPage() {
        return "demo-mashup";
    }




    @RequestMapping(value = "getData", method = RequestMethod.POST)
    public ResponseEntity getData(@RequestBody TestOpModel testOpModel) {
        String data = DTPlatform.getPlatform().getPlatformManager().getDT(testOpModel.getDtId())
                .getData(testOpModel.getOperationId());
        return new ResponseEntity(data, HttpStatus.OK);
    }



    @RequestMapping(value = "execute", method = RequestMethod.POST)
    public ResponseEntity execute(@RequestBody TestOpModel testOpModel) {
        String data = DTPlatform.getPlatform().getPlatformManager().getDT(testOpModel.getDtId())
                .invokeService(testOpModel.getOperationId());
        return new ResponseEntity(data, HttpStatus.OK);
    }
}
