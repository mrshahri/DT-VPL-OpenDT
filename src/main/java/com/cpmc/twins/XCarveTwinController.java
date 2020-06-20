package com.cpmc.twins;

import com.cpmc.models.DigitalTwin;
import com.cpmc.models.DigitalTwinFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("xcarve")
public class XCarveTwinController {

    private static String twiName = "xcarve";

    @RequestMapping(value = "descriptor", method = RequestMethod.GET)
    public ResponseEntity getDescriptor() {
        DigitalTwin xcarveTwin = DigitalTwinFactory.createDigitalTwin(twiName);
        return new ResponseEntity(xcarveTwin, HttpStatus.OK);
    }
}
