package edu.sm.controller;



import edu.sm.util.FileUploadUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@Slf4j
public class MainRestController {

    @RequestMapping("/saveaudio")
    public String saveaudio(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/audios/");
        return "Ok";
    }
    @RequestMapping("/saveimg")
    public String saveimg(@RequestParam("file") MultipartFile file) throws IOException {
        FileUploadUtil.saveFile(file, "C:/smspring/imgs/");
        return "Ok";
    }
}

