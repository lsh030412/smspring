package edu.sm.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
@Slf4j
public class MainController {
    @RequestMapping("/")
    public String main(Model model) {
        log.info("Start Main ,,,,,,");
        return "index";
    }

    @RequestMapping("/audio")
    public String audio(Model model) {
        model.addAttribute("center", "audio");
        return "index";
    }
    @RequestMapping("/pic")
    public String pic(Model model) {
        model.addAttribute("center", "pic");
        return "index";
    }
}