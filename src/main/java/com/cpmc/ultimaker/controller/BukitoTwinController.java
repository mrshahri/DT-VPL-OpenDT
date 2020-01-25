package com.cpmc.ultimaker.controller;

import models.DigitalTwin;
import models.DigitalTwinFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("bukito")
public class BukitoTwinController {

    private static String twiName = "bukito";

    @RequestMapping(value = "descriptor", method = RequestMethod.GET)
    public ResponseEntity getDescriptor() {
        DigitalTwin bukitoTwin = DigitalTwinFactory.createDigitalTwin(twiName);
        return new ResponseEntity(bukitoTwin, HttpStatus.OK);
    }
}
