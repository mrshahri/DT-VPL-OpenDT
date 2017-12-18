package com.cpmc.ultimaker.controller;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by Rakib on 5/25/2017.
 */
@Controller
public class BaseController {

    private static int counter = 0;
    private static final String VIEW_INDEX = "index";
    private final static org.slf4j.Logger logger = LoggerFactory.getLogger(BaseController.class);

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String welcome(ModelMap model) {
        model.addAttribute("postUrl", "http://uaf132854.ddns.uark.edu:8100/app-ultimaker/operate-device");
        model.addAttribute("monitorUrl", "http://uaf132854.ddns.uark.edu:9002/virtualization-uark/monitor");
        return "virtual_printer";
    }

    @RequestMapping(value = "/{name}", method = RequestMethod.GET)
    public String welcomeName(@PathVariable String name, ModelMap model) {

        model.addAttribute("message", "Welcome " + name);
        model.addAttribute("counter", ++counter);
        logger.debug("[welcomeName] counter : {}", counter);
        return VIEW_INDEX;

    }

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
        model.addAttribute("monitorUrl", "http://uaf132854.ddns.uark.edu:9002/virtualization-uark/monitor");
        return "virtual_printer";
    }
}