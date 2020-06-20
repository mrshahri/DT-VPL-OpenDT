package com.cpmc.controllers;

import com.cpmc.models.DTRepoMock;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by Rakib on 5/25/2017.
 */
@Controller
public class BaseController {

    private static int counter = 0;
    private static final String VIEW_INDEX = "index";
//    private static final String baseUrl = "http://uaf132854.ddns.uark.edu";
    private static final String baseUrl = "http://localhost";
    private final static org.slf4j.Logger logger = LoggerFactory.getLogger(BaseController.class);

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String welcome(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "virtual_printer";
    }

    @RequestMapping(value = "/bukito", method = RequestMethod.GET)
    public String welcome1(ModelMap model) {
        model.addAttribute("postDeviceUrl", baseUrl + ":9002/virtualization-uark/operate/device");
        model.addAttribute("postComponentUrl", baseUrl + ":9002/virtualization-uark/operate/component");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        model.addAttribute("dataUrl", baseUrl + ":9002/virtualization-uark/data");
        return "virtual_bukito";
    }

    @RequestMapping(value = "/uarm", method = RequestMethod.GET)
    public String getUarmPage(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + "http:8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "virtual_uarm";
    }


    @RequestMapping(value = "/composite-1", method = RequestMethod.GET)
    public String getCompositePage(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "bukito-uarm";
    }

    @RequestMapping(value = "/bukito-uarm", method = RequestMethod.GET)
    public String getBukitoUarmView(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "bukito-uarm";
    }

    @RequestMapping(value = "/composite-2", method = RequestMethod.GET)
    public String getUltimakerUarmXcarveView(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "ultimaker-uarm-xcarve";
    }

    @RequestMapping(value = "/virtual-factory", method = RequestMethod.GET)
    public String getVirtualFactory(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "virtual-composite";
    }

    @RequestMapping(value = "/bukito-ultimaker", method = RequestMethod.GET)
    public String getBukitoUltimaker(ModelMap model) {
        model.addAttribute("postUrl", baseUrl + ":8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "bukito-ultimaker";
    }

/*

    @RequestMapping(value = "/{name}", method = RequestMethod.GET)
    public String welcomeName(@PathVariable String name, ModelMap model) {

        model.addAttribute("message", "Welcome " + name);
        model.addAttribute("counter", ++counter);
        logger.debug("[welcomeName] counter : {}", counter);
        return VIEW_INDEX;
    }
*/

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test() {
        return "test";
    }

    @RequestMapping(value = "/collaboraction-diagnosis", method = RequestMethod.GET)
    public String collaborationDiagnosis(ModelMap model) {
        return "collaboration_fault_detection";
    }

    @RequestMapping(value = "/virtual", method = RequestMethod.GET)
    public String virtunPrinter(ModelMap model) {
        model.addAttribute("monitorUrl", baseUrl + ":9002/virtualization-uark/monitor");
        return "virtual_printer";
    }

//    @RequestMapping(value = "/twins", method = RequestMethod.GET, produces = "application/json")
    @GetMapping(value = "twins")
    public ResponseEntity getDigitalTwins() {
        DTRepoMock dtRepoMock = new DTRepoMock();
        return new ResponseEntity(dtRepoMock, HttpStatus.OK);
    }

    @GetMapping(value = "vff-suite")
    public String getVffSuite() {
        return "vff-suite";
    }
}