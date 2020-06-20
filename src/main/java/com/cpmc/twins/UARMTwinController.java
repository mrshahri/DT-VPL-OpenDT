package com.cpmc.twins;

import com.cpmc.models.DigitalTwin;
import com.cpmc.models.DigitalTwinFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("uarm")
public class UARMTwinController {

    private static String twiName = "uarm";

    @RequestMapping(value = "descriptor", method = RequestMethod.GET)
    public ResponseEntity getDescriptor() {
        DigitalTwin uarmTwin = DigitalTwinFactory.createDigitalTwin(twiName);
        return new ResponseEntity(uarmTwin, HttpStatus.OK);
    }
}
