package com.cpmc.twins;

import com.cpmc.models.DigitalTwin;
import com.cpmc.models.DigitalTwinFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("ultimaker")
public class UltimakerTwinController {

    private static final String baseUrl = "http://localhost";
    private static String twiName = "ultimaker";

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String getUltimaker(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "ultimaker";
    }

    @RequestMapping(value = "descriptor", method = RequestMethod.GET)
    public ResponseEntity getDescriptor() {
        DigitalTwin ultimakerTwin = DigitalTwinFactory.createDigitalTwin(twiName);
        return new ResponseEntity(ultimakerTwin, HttpStatus.OK);
    }

}
